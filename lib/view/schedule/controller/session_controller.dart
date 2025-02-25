import 'dart:async';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/schedule/model/sessin_detail_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/guide_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/customTextView.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../bestForYou/controller/aiMatchController.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../myFavourites/controller/favourite_session_controller.dart';
import '../../quiz/model/sessionPollModel.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../speakers/controller/speakersController.dart';
import '../model/sessionPollsStatus.dart';
import '../model/scheduleModel.dart';
import '../model/session_filter_model.dart';
import '../model/speaker_webinar_model.dart';
import '../request_model/session_request_model.dart';

class SessionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DashboardController dashboardController = Get.find();
  final CommonDocumentController commonController = Get.find();

  late final AuthenticationManager _authManager;
  ScrollController tabScrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  AuthenticationManager get authManager => _authManager;

  late TabController _tabController;
  TabController get tabController => _tabController;

  var loading = false.obs;
  var isFirstLoading = true.obs;

  var sessionList = <SessionsData>[].obs;
  var liveSessionList = <SessionsData>[].obs;
  var mySessionList = <SessionsData>[].obs;

  var menuParentItemList = <MenuItem>[];

  final mSessionDetailBody = SessionsData().obs;

  var dateObject = Params();

  SessionsData get sessionDetailBody => mSessionDetailBody.value;

  var selectedFilterSort = "ASC".obs;
  var defaultDate = "";

  final agendaPdf = "".obs;
  final selectedTabIndex = 0.obs;
  final selectedDayIndex = 0.obs;

  var userIdsList = <dynamic>[];
  var userSpeakerIdsList = <dynamic>[];
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;

  //reaction
  var emoticonsSelected = "".obs;

  //pagination of session
  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();

  Set<String> existingAuditoriumKeys = {};

  ///used for the filter data
  var isReset = false.obs;

  var sessionFilterBody = SessionFilterBody().obs;
  var tempSessionFilterBody = SessionFilterBody().obs;
  var isFilterApply = false.obs;
  var isActiveHappening = false.obs; // button `Happening Now`

  SessionRequestModel sessionRequestModel = SessionRequestModel();

  ///refresh the page.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  GlobalKey<RefreshIndicatorState> get refreshIndicatorKey =>
      _refreshIndicatorKey;

  ///better player controller
  late VideoPlayerController videoPlayerController;

  var isStreaming = false.obs;
  /*Duration duration = Duration(seconds: 1);
  Curve curve = Curves.fastOutSlowIn;*/
  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(vsync: this, length: 3);
    // _tabController.addListener(_handleTabChange);

    sessionRequestModel = SessionRequestModel(
        page: 1,
        favourite: 0,
        filters: RequestFilters(
            text: textController.text.trim().toString(),
            sort: "ASC",
            params: RequestParams(date: defaultDate)));
    _authManager = Get.find();
    getChildMenu();
    dependencies();
  }

  initApiCall() {
    getApiData();
    _loadInitialAudiFirebaseData();
  }

  getApiData() async {
    textController.clear();
    isFilterApply(false);
    sessionRequestModel.filters?.text = "";
    sessionRequestModel.filters?.params = RequestParams(date: defaultDate);
    if (await UiHelper.isNoInternet()) {
      return;
    }
    await getAndResetFilter(isRefresh: true, isFromReset: false);
    await getSessionList(isRefresh: false);
  }

  void dependencies() {
    Get.lazyPut(() => FavouriteController(), fenix: true);
    Get.lazyPut(() => SpeakersDetailController(), fenix: true);
    Get.lazyPut(() => FavSessionController(), fenix: true);
    Get.lazyPut(() => AiMatchController(), fenix: true);
    Get.lazyPut(() => UserDetailController(), fenix: true);
  }

  getFavSessionData() {
    if (Get.isRegistered<FavSessionController>()) {
      FavSessionController favSessionController = Get.find();
      favSessionController.getApiData();
    }
  }

  Future<void> _loadInitialAudiFirebaseData() async {
    DataSnapshot snapshot = await _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      // Store existing keys in the Set
      data.forEach((key, value) {
        existingAuditoriumKeys.add(key);
      });
      initAudiRefUpdate();
    } else {
      initAudiRefUpdate();
    }
  }

  initAudiRefUpdate() {
    _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        String childKey = event.snapshot.key!;
        if (!existingAuditoriumKeys.contains(childKey)) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          for (var index in Iterable<int>.generate(sessionList.length)) {
            if (sessionList[index].id == event.snapshot.key) {
              sessionList[index].status?.color = json['status']['color'];
              sessionList[index].status?.value = json['status']['value'];
              sessionList[index].status?.text = json['status']['text'];
              sessionList[index].embed = json['embed'];
              sessionList[index].embedPlayer = json['embed_player'];
              sessionList.refresh();
              if (mSessionDetailBody.value.id == event.snapshot.key) {
                mSessionDetailBody.value.status?.color =
                    json['status']['color'];
                mSessionDetailBody.value.status?.value =
                    json['status']['value'];
                mSessionDetailBody.value.status?.text = json['status']['text'];
                mSessionDetailBody.value.embed = json['embed'];
                mSessionDetailBody.value.embedPlayer = json['embed_player'];
                mSessionDetailBody.refresh();
              }
            }
          }
        }
      }
    });

    _authManager.firebaseDatabase
        .ref("${AppUrl.defaultFirebaseNode}/auditoriums")
        .onChildChanged
        .listen((event) {
      if (event.snapshot.value != null) {
        String childKey = event.snapshot.key!;
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        for (var index in Iterable<int>.generate(sessionList.length)) {
          if (sessionList[index].id == childKey) {
            sessionList[index].status?.color = json['status']['color'];
            sessionList[index].status?.value = json['status']['value'];
            sessionList[index].status?.text = json['status']['text'];
            sessionList[index].embed = json['embed'];
            sessionList[index].embedPlayer = json['embed_player'];
            sessionList.refresh();
            if (mSessionDetailBody.value.id == event.snapshot.key) {
              mSessionDetailBody.value.status?.color = json['status']['color'];
              mSessionDetailBody.value.status?.value = json['status']['value'];
              mSessionDetailBody.value.status?.text = json['status']['text'];
              mSessionDetailBody.value.embed = json['embed'];
              mSessionDetailBody.value.embedPlayer = json['embed_player'];
              mSessionDetailBody.refresh();
              update();
            }
          }
        }
      }
    });
  }

  Future<SessionPollModel> initAuditoriumsRef({auditoriumId, sessionId}) async {
    final snapshot = await authManager.firebaseDatabase
        .ref(AppUrl.defaultFirebaseNode)
        .child("auditoriums")
        .child(auditoriumId)
        .child("sessions")
        .child(sessionId)
        .child("poll")
        .get();
    if (snapshot.value != null) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      return SessionPollModel.fromJson(json);
    }
    return SessionPollModel();
  }

  //get session list data
  Future<void> getSessionList({required bool isRefresh}) async {
    if (await UiHelper.isNoInternet()) {
      return;
    }
    sessionRequestModel.page = 1;
    _pageNumber = 1;
    hasNextPage = false;
    isFirstLoading(!isRefresh);
    ScheduleModel? model =
        await apiService.getSessionList(sessionRequestModel, AppUrl.getSession);
    if (model.status == true && model.code == 200) {
      sessionList.clear();
      sessionList.addAll(model.body?.sessions ?? []);
      userIdsList.clear();
      if (model.body?.sessions != null) {
        userIdsList.addAll(model.body!.sessions!.map((obj) => obj.id).toList());
      }
      getBookmarkIds();
      getSpeakerWebinarList(userIdsList: userIdsList, sessionList: sessionList);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      if (hasNextPage) {
        _loadMore();
      }
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }

  ///get more session data
  Future<void> _loadMore() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        sessionRequestModel.page = _pageNumber;
        try {
          ScheduleModel? model = await apiService.getSessionList(
              sessionRequestModel, AppUrl.getSession);

          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            sessionList.addAll(model.body?.sessions ?? []);
            userIdsList
                .addAll(model.body!.sessions!.map((obj) => obj.id).toList());
            getBookmarkIds();
            getSpeakerWebinarList(
                userIdsList: userIdsList, sessionList: sessionList);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///get the panelist of session.
  Future<void> getSpeakerWebinarList(
      {required userIdsList, required sessionList}) async {
    if (userIdsList.isEmpty ?? [].isEmpty) {
      return;
    }
    var requestBody = {"webinars": userIdsList};
    SpeakerModelWebinarModel? model = await apiService.getSpeakerWebinarList(
        requestBody, AppUrl.getSpeakerByWebinarId);
    if (model.status! && model.code == 200) {
      for (var session in sessionList) {
        var matchingSpeakerData = model.body!
            .firstWhere((speakerData) => speakerData.id == session.id);
        if (matchingSpeakerData != null) {
          session.speakers.clear();
          session.speakers?.addAll(matchingSpeakerData.sessionSpeaker ?? []);
          sessionList.refresh();
        }
      }
    } else {
      print(model.code.toString());
    }
  }

  ///get the session details by id
  Future<Map> getSessionDetail({required requestBody}) async {
    isStreaming(false);
    var result = {};
    loading(true);
    SessionDetailModel? model = await apiService.getSessionDetail(requestBody);
    loading(false);
    if (model.status! && model.code == 200) {
      if (model.body != null) {
        if (bookMarkIdsList.contains(sessionDetailBody.id)) {
          sessionDetailBody.bookmark = sessionDetailBody.id;
        }
        mSessionDetailBody(model.body);
        result = {"status": model.status, "message": ""};
        getBookmarkIdDetail(sessionDetailBody.id);
        getSpeakerWebinarListDetail(sessionDetailBody.id);
      } else {
        result = {"status": false, "message": ""};
      }
    } else {
      result = {"status": false};
    }
    getSessionBanner();
    return result;
  }

  ///get the speaker of session
  Future<void> getSpeakerWebinarListDetail(sessionId) async {
    var requestBody = {
      "webinars": [sessionId]
    };
    SpeakerModelWebinarModel? model = await apiService.getSpeakerWebinarList(
        requestBody, AppUrl.getSpeakerByWebinarId);
    try {
      if (model.status! && model.code == 200) {
        if (model.body != null && model.body!.isNotEmpty) {
          sessionDetailBody.speakers = model.body![0].sessionSpeaker ?? [];
        }
      } else {
        print(model.code.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getSessionBanner() {
    commonController.getBannerList(
        itemId: sessionDetailBody.id ?? "", itemType: "webinar_banner");
  }

  Future<void> getAndResetFilter(
      {required isRefresh, bool? isFromReset}) async {
    isFirstLoading(isRefresh);
    SessionFilterModel? model =
        await apiService.getSessionsFilter(AppUrl.sessionsFilter);
    if (model.status! && model.code == 200) {
      sessionFilterBody(model.body!);
      if (isFromReset == false) {
        tempSessionFilterBody.value = model.body!;
      } else {
        isFirstLoading(false);
      }
      // Using firstWhere to find the date by name
      dateObject = sessionFilterBody.value.params!
          .firstWhere((obj) => obj.name == "date", orElse: () => Params());
      if (dateObject.options != null) {
        defaultDate =
            dateObject.value?.toString() ?? dateObject.options?[0].value ?? "";

        ///set the default date to request
        sessionRequestModel.filters?.params?.date = defaultDate;
        int index = dateObject.options!
            .indexWhere((dateItem) => dateItem.value == defaultDate);
        selectedDayIndex(index);
        if (selectedDayIndex.value != 0 &&
            dateObject.options != null &&
            dateObject.options!.isNotEmpty) {
          Future.delayed(const Duration(seconds: 1), () {
            // Scroll to the selected item
            double itemWidth = 140.h + 12; // Width + margin
            tabScrollController.animateTo(
              selectedDayIndex.value * itemWidth,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        }
      }
      update();
    }
  }

  ///this is used for the remove the filter is its not applied.
  clearFilterIfNotApply() {
    if (isReset.value) {
      sessionFilterBody(tempSessionFilterBody.value);
      isReset(false);
    }
    sessionFilterBody.value.params?.forEach((data) {
      if (data.value is List) {
        data.value = data.options
                ?.where((opt) => opt.apply)
                .map((opt) => opt.value)
                .toList() ??
            [];
      } else {
        data.value = data.options
            ?.firstWhere((opt) => opt.apply, orElse: () => Options(value: ""))
            .value;
      }
    });
  }

  Future<void> bookmarkToSession({required id}) async {
    var model = await commonController.bookmarkToItem(
        requestBody: BookmarkRequestModel(itemType: "webinar", itemId: id));
    if (model["status"]) {
      bookMarkIdsList.add(model["item_id"]);
      sessionDetailBody.bookmark = model["item_id"];
    } else {
      bookMarkIdsList.remove(model["item_id"]);
      sessionDetailBody.bookmark = "";
      removeItemFromBookmark(model["item_id"]);
    }
  }

  void removeItemFromBookmark(String id) {
    if (Get.isRegistered<FavSessionController>()) {
      FavSessionController favouriteController = Get.find();
      // Remove item where 'id' matches 'idToDelete'
      favouriteController.favouriteSessionList
          .removeWhere((item) => item.id == id);
      favouriteController.favouriteSessionList.refresh();
    }
  }

  Future<Map> getPollStatus({required requestBody}) async {
    var result = {};
    loading(true);
    SessionPollStatus? model = await apiService.getPollStatus(
        requestBody, AppUrl.sessionIsPollSubmitted);
    if (model.status! && model.code == 200) {
      result = {
        "status": false,
        "action": model.body?.userStatus ?? "",
        "message": model.body?.message ?? ""
      };
    } else {
      result = {
        "status": false,
        "action": model.body?.userStatus ?? "",
        "message": model.body?.message ?? ""
      };
    }
    loading(false);
    return result;
  }

  Future<Map> setSessionResponse({required requestBody}) async {
    var result = {};
    loading(true);
    CommonModel? model = await apiService.commonPostRequest(
        requestBody, AppUrl.sessionSavePolls);
    loading(false);
    if (model.status! && model.code == 200) {
      result = {"status": true};
    } else {
      result = {"status": false};
    }
    return result;
  }

  Future<void> getChildMenu() async {
    menuParentItemList.add(MenuItem.createItem(
        title: "polls".tr,
        iconUrl: ImageConstant.ic_poll,
        isSelected: false,
        id: "poll"));
    menuParentItemList.add(MenuItem.createItem(
        title: "ask_question".tr,
        iconUrl: ImageConstant.ic_ask_question,
        isSelected: false,
        id: "ask_a_question"));
    menuParentItemList.add(MenuItem.createItem(
        title: "chat".tr,
        iconUrl: ImageConstant.ic_chat_session,
        isSelected: false,
        id: "chat"));
    menuParentItemList.add(MenuItem.createItem(
        title: "feedback".tr,
        iconUrl: ImageConstant.menu_feedback,
        isSelected: false,
        id: "feedback"));
  }

  Event buildEvent({Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  Event buildEventDetail(
      {Recurrence? recurrence, required SessionsData sessions}) {
    return Event(
      title: sessions.label ?? "",
      description: sessions.description ?? "",
      location: '',
      startDate: DateTime.parse(sessions.startDatetime ?? ""),
      endDate: DateTime.parse(sessions.endDatetime ?? ""),
      allDay: false,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      recurrence: recurrence,
    );
  }

  Future<void> getBookmarkIds() async {
    if (userIdsList.isEmpty) {
      return;
    }
    bookMarkIdsList.value = await commonController.getCommonBookmarkIds(
        items: userIdsList, itemType: "webinar");
  }

  /// it is for temporary set
  Future<void> getBookmarkIdDetail(id) async {
    var bookMarkIdsList = await commonController
        .getCommonBookmarkIds(items: [id], itemType: "webinar");
    sessionDetailBody.bookmark = bookMarkIdsList.contains(id) ? id : "";
    mSessionDetailBody.refresh();
  }

  Future<void> sendEmoticonsRequest({required requestBody}) async {
    loading(true);
    CommonModel? model = await apiService.commonPostRequest(
        requestBody, AppUrl.webinarEmoticons);
    loading(false);
    if (model.status! && model.code == 200) {
      emoticonsSelected(requestBody["type"] ?? "");
      emoticonsSelected.refresh();
      UiHelper.showSuccessMsg(null, model.body?.message ?? "");
    } else {
      UiHelper.showFailureMsg(null, model.body?.message ?? "");
    }
  }

  List<dynamic> getSessionHallWise(sessionId) {
    List outputList = sessionList
        .where((parentRoomModel) => parentRoomModel.id != sessionId)
        .toList();
    return outputList;
  }

  var selectedPollIndex = 100.obs;

  shareTheSession() {
    Share.share(
        "${mSessionDetailBody.value.label}\n\n ${mSessionDetailBody.value.description ?? ""}\n\n ${mSessionDetailBody.value.embed ?? ""}");
  }

  showPollsView(
      BuildContext context, SessionPollModel pollModel, Map pollsApiObj) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(color: indicatorColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextView(
                    text: "polls".tr,
                    fontSize: 18,
                    color: colorSecondary,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: colorLightGray,
                          size: 40,
                        ),
                        Icon(Icons.close),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: grayColorLight,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextView(
                text: pollModel.action == "active" &&
                        pollsApiObj['action'] == "close"
                    ? pollsApiObj['message']
                    : pollModel.action == "active" &&
                            pollsApiObj['action'] == "active"
                        ? pollModel.question
                        : pollModel.action == "result"
                            ? pollModel.question
                            : "Stay Tuned,polls will active",
                fontSize: 18,
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 12,
              ),
              pollModel.action == "result"
                  ? buildPollResult(pollModel)
                  : pollModel.action == "active" &&
                          pollsApiObj['action'] == "active"
                      ? buildPollOption(pollModel)
                      : const SizedBox(),
              pollModel.action == "active" && pollsApiObj['action'] == "active"
                  ? Obx(
                      () => selectedPollIndex.value != 100
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: colorSecondary,
                                  side: const BorderSide(
                                      color: colorSecondary, width: 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                  ),
                                ),
                                onPressed: () async {
                                  var result = await setSessionResponse(
                                    requestBody: {
                                      "opinion":
                                          selectedPollIndex.value.toString(),
                                      "auditorium_session_poll_id": pollModel.id
                                    },
                                  );
                                  if (result["status"]) {
                                    Get.back();
                                  }
                                },
                                child: const CustomTextView(
                                  text: "Send Response",
                                  color: white,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  buildPollOption(SessionPollModel pollModel) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        itemCount: pollModel.options?.length ?? 0,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              selectedPollIndex(index);
            },
            child: Obx(
              () => Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                height: 65,
                decoration: BoxDecoration(
                  color:
                      selectedPollIndex.value == index ? colorLightGray : white,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                      width: 1,
                      color: selectedPollIndex.value == index
                          ? colorSecondary
                          : colorLightGray),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text: pollModel.options?[index] ?? "",
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildPollResult(SessionPollModel pollModel) {
    //print("my-result---${pollModel.result}");
    //var resultList = pollModel.result.entries.toList();
    List resultList = pollModel.result ?? [];
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          PollResultData mapEntry = resultList[index];
          return Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            height: 65,
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(width: 1, color: colorSecondary)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: mapEntry.opinion ?? "",
                      textAlign: TextAlign.start,
                    ),
                    CustomTextView(
                      text: "${mapEntry.percentage}%",
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: (mapEntry.percentage / 100),
                  backgroundColor: colorLightGray,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(colorSecondary),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
