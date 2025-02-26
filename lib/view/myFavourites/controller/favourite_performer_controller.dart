import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_speaker_model.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../representatives/request/network_request_model.dart';
import '../../representatives/model/user_model.dart';
import '../../speakers/model/speakersModel.dart';

class FavPerformerController extends GetxController {
  var favouriteSpeakerList = <SpeakersData>[].obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  NetworkRequestModel networkRequestModel = NetworkRequestModel();
  var loading = false.obs;
  var isFirstLoading = false.obs;

  FavouriteController favouriteController = Get.find();

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    ///its a initial request for the get the data
    networkRequestModel = NetworkRequestModel(
        role: MyConstant.attendee,
        page: 1,
        favorite: 1,
        filters: RequestFilters(
            text: favouriteController.textController.value.text.trim(),
            isBlocked: false,
            sort: "ASC",
            notes: false,
            params: {}));
    getBookmarkUser();
  }

  Future<void> getBookmarkUser() async {
    isFirstLoading(true);
    SpeakersModel? model = await apiService.getSpeakersApi(
        networkRequestModel, "${AppUrl.usersListApi}/search");
    if (model.status! && model.code == 200) {
      favouriteSpeakerList.clear();
      favouriteSpeakerList.value = model.body!.representatives??[];
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }
}

