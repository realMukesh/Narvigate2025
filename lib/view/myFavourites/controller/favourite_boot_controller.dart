import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/exhibitors/request_model/request_model.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../routes/my_constant.dart';

class FavBootController extends GetxController {
  var favouriteBootList = <Exhibitors>[].obs;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var loading = false.obs;
  var isFirstLoading = false.obs;
  FavouriteController favouriteController = Get.find();
  BootRequestModel bootRequestModel = BootRequestModel();

  @override
  void onInit() {
    super.onInit();
    getApiData();
  }

  getApiData() async {
    bootRequestModel = BootRequestModel(
        favourite: 1,
        filters: RequestFilters(
            text: favouriteController.textController.value.text.trim() ?? "",
            sort: "ASC",
          notes: false
        ),
      page: 1
    );
    getBookmarkExhibitor();
  }

  Future<void> getBookmarkExhibitor() async {
    isFirstLoading(true);
    ExhibitorsModel? model = await apiService.getExhibitorsList(
      bootRequestModel,
      "${AppUrl.exhibitorsListApi}/search",
    );
    if (model.status! && model.code == 200) {
      favouriteBootList.clear();
      favouriteBootList.value = model.body!.exhibitors ?? [];
    } else {
      print(model.code.toString());
    }
    isFirstLoading(false);
  }
}
