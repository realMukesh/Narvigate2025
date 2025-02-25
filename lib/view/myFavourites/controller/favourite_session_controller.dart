import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../schedule/model/speaker_webinar_model.dart';
import '../../schedule/request_model/session_request_model.dart';

class FavSessionController extends GetxController {
  var favouriteSessionList = <SessionsData>[].obs;

  var loading = false.obs;
  var isFirstLoading = false.obs;

  var userIdsList = <dynamic>[];
  FavouriteController favouriteController = Get.find();
  SessionRequestModel sessionRequestModel=SessionRequestModel();

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    sessionRequestModel = SessionRequestModel(
        page: 1,
        favourite: 1,
        filters: RequestFilters(
            text: favouriteController.textController.value.text.trim().toString(),
            sort: "ASC",
            params: RequestParams(date: "")));
    getBookmarkSession(isRefresh: false);
  }

  Future<void> getBookmarkSession(
      {required isRefresh}) async {
    if (!isRefresh ?? false) {
      isFirstLoading(true);
    }
    ScheduleModel? model =
        await apiService.getSessionList(sessionRequestModel, AppUrl.getSession);
    if (model.status! && model.code == 200) {
      favouriteSessionList.clear();
      favouriteSessionList.addAll(model.body?.sessions ?? []);
      favouriteSessionList.refresh();
      userIdsList.clear();
      if(favouriteSessionList.isNotEmpty){
        userIdsList.addAll(favouriteSessionList!.map((obj) => obj.id).toList());
        getSpeakerWebinarList(requestBody: {"webinars": userIdsList});
      }

      update();
      isFirstLoading(false);
    } else {
      isFirstLoading(false);
    }
  }

  Future<void> getSpeakerWebinarList({required requestBody}) async {
    SpeakerModelWebinarModel? model = await apiService.getSpeakerWebinarList(
        requestBody, AppUrl.getSpeakerByWebinarId);
    if (model.status! && model.code == 200 && model.body!=null) {
      for (var session in favouriteSessionList) {
        var matchingSpeakerData = model.body!
            .firstWhere((speakerData) => speakerData.id == session.id);
        if (matchingSpeakerData != null) {
          session.speakers?.addAll(matchingSpeakerData.sessionSpeaker ?? []);
          favouriteSessionList.refresh();
        }
      }
    } else {
      print(model.code.toString());
    }
  }
}
