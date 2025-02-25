import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_speaker_model.dart';
import 'package:dreamcast/view/representatives/request/network_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../representatives/model/user_model.dart';

class FavUserController extends GetxController {
  var favouriteAttendeeList = <Representatives>[].obs;

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
        role: MyConstant.networking,
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

    RepresentativeModel? model = await apiService.getUserList(
        networkRequestModel, "${AppUrl.usersListApi}/search");
    if (model.status! && model.code == 200) {
      favouriteAttendeeList.clear();
      favouriteAttendeeList.value = model.body!.representatives??[];
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }
}
