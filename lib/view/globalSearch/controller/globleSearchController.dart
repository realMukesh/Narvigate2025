import 'package:dreamcast/routes/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api_repository/api_service.dart';
import '../../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../exhibitors/model/exibitorsModel.dart';
import '../../representatives/model/user_model.dart';
import '../../representatives/request/network_request_model.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../speakers/model/speakersModel.dart';

class GlobalSearchController extends GetxController {
  late final AuthenticationManager _authManager;
  AuthenticationManager get authManager => _authManager;
  var userList = <dynamic>[].obs;
  var speakerList = <dynamic>[].obs;
  var exhibitorsMatchesList = <Exhibitors>[].obs;
  var sessionList = <dynamic>[].obs;
  var isFirstLoadRunning = false.obs;
  var isLoading = false.obs;
  var selectedSearchTag = "Exhibitors".obs;
  var selectedSearchIndex = 0.obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final textController = TextEditingController().obs;

  ScrollController userScrollController = ScrollController();
  ScrollController exhibitorScrollController = ScrollController();
  ScrollController speakerScrollController = ScrollController();
  ScrollController sessionScrollController = ScrollController();

  late bool hasNextPage;
  late int _pageNumber;
  var isLoadMoreRunning = false.obs;
  var searchText = "".obs;

  ///used for the filter data
  NetworkRequestModel networkRequestModel = NetworkRequestModel();

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    networkRequestModel = NetworkRequestModel(
        role: MyConstant.networking,
        favorite: 0,
        filters: RequestFilters(
            text: textController.value.text.trim() ?? "",
            isBlocked: false,
            sort: "",
            notes: false,
            params: {}));
    getSearchExhibitorsApi(isRefresh: false);
  }

  ///search load user list
  Future<void> getSearchUserApi({bool? isRefresh}) async {
    _pageNumber = 1;
    networkRequestModel.page = 1;
    networkRequestModel.role = MyConstant.networking;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    isFirstLoadRunning(true);
    try {
      RepresentativeModel? model = await apiService.getUserList(
          networkRequestModel, "${AppUrl.usersListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        userList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          userList.addAll(model.body!.representatives ?? []);
          hasNextPage = model.body?.hasNextPage ?? false;
          if (hasNextPage) {
            _pageNumber = _pageNumber + 1;
            _loadMoreUser();
          }
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for attendee
  Future<void> _loadMoreUser() async {
    userScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          userScrollController.position.maxScrollExtent ==
              userScrollController.position.pixels) {
        isLoadMoreRunning(true);
        networkRequestModel.page = _pageNumber;
        try {
          RepresentativeModel? model = await apiService.getUserList(
              networkRequestModel, "${AppUrl.usersListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            userList.addAll(model.body!.representatives ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///search load speaker list
  Future<void> getSearchSpeakerApi({bool? isRefresh}) async {
    _pageNumber = 1;
    networkRequestModel.page = 1;
    networkRequestModel.role = MyConstant.speakers;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    isFirstLoadRunning(true);
    try {
      RepresentativeModel? model = await apiService.getUserList(
          networkRequestModel, "${AppUrl.usersListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        speakerList.clear();
        if (model.body?.representatives != null &&
            model.body!.representatives!.isNotEmpty) {
          speakerList.addAll(model.body!.representatives ?? []);
          hasNextPage = model.body?.hasNextPage ?? false;
          if (hasNextPage) {
            _pageNumber = _pageNumber + 1;
            _loadMoreSpeaker();
          }
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for speaker
  Future<void> _loadMoreSpeaker() async {
    speakerScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          speakerScrollController.position.maxScrollExtent ==
              speakerScrollController.position.pixels) {
        isLoadMoreRunning(true);
        networkRequestModel.page = _pageNumber;
        try {
          RepresentativeModel? model = await apiService.getUserList(
              networkRequestModel, "${AppUrl.usersListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            speakerList.addAll(model.body!.representatives ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///load get exhibitor list
  Future<void> getSearchExhibitorsApi({bool? isRefresh}) async {
    _pageNumber = 1;
    if (await UiHelper.isNoInternet()) {
      return;
    }
    var requestBody = {
      "filters": {
        "text": textController.value.text ?? "",
        "sort": "",
        /*ASC , DESC*/
        "params": {"interest": []}
      },
      "featured": 0,
      "favourite": 0,
      "page": 1
    };
    isFirstLoadRunning(true);
    try {
      ExhibitorsModel? model = await apiService.getExhibitorsList(
          requestBody, "${AppUrl.exhibitorsListApi}/search");
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        exhibitorsMatchesList.clear();
        exhibitorsMatchesList.value = model.body!.exhibitors ?? [];
        hasNextPage = model.body?.hasNextPage ?? false;
        if (hasNextPage) {
          _pageNumber = _pageNumber + 1;
          _loadMoreExhibitor(requestBody);
        }
      } else {
        debugPrint(model.code.toString());
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for exhibitor
  Future<void> _loadMoreExhibitor(Map<String, Object> newRequestBody) async {
    exhibitorScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          exhibitorScrollController.position.maxScrollExtent ==
              exhibitorScrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          ExhibitorsModel? model = await apiService.getExhibitorsList(
              newRequestBody, "${AppUrl.exhibitorsListApi}/search");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            exhibitorsMatchesList.addAll(model.body!.exhibitors ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///search session data
  Future<void> getSearchSessionApi({bool? isRefresh}) async {
    _pageNumber = 1;
    var requestBody = {
      "page": 1,
      "filters": {
        "text": textController.value.text ?? "",
        "sort": "ASC",
        "params": {
          "date": "",
          "keywords": []
          //  "status":1
        }
      },
      "favourite": 0
    };
    isFirstLoadRunning(true);
    ScheduleModel? model =
        await apiService.getSessionList(requestBody, AppUrl.getSession);
    isFirstLoadRunning(false);
    if (model.status! && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      hasNextPage = model.body?.hasNextPage ?? false;
      if (hasNextPage) {
        _pageNumber = _pageNumber + 1;
        _loadMoreSession(requestBody);
      }
    } else {
      debugPrint(model.code.toString());
    }
    try {} catch (exception) {
      debugPrint(exception.toString());
      isFirstLoadRunning(false);
    }
  }

  ///add the pagination to session
  Future<void> _loadMoreSession(Map<String, Object> newRequestBody) async {
    sessionScrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          sessionScrollController.position.maxScrollExtent ==
              sessionScrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          ScheduleModel? model = await apiService.getSessionList(
              newRequestBody, AppUrl.getSession);
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(model.body?.sessions ?? []);
            update();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
}
