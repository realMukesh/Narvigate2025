import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/breifcase/model/BriefcaseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../model/common_document_request.dart';

class CommonDocumentController extends GetxController {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  var isBookmarkLoading = false.obs;

  var resourceCenterList = <DocumentData>[].obs;
  var resourceCenterBookIds = <String>[].obs;
  var bannerList = <DocumentData>[].obs;
  var sessionBannerList = <DocumentData>[].obs;

  var briefcaseList = <DocumentData>[].obs;

  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var briefcaseIdsList = [];
  var isMoreData = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDocumentList(isRefresh: false, limitedMode: false);
  }

  ///get the list of resource center

  Future<void> getDocumentList(
      {required bool isRefresh, bool? limitedMode}) async {
    resourceCenterBookIds.clear();
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    if (limitedMode == true) {
      ParentCommonDocumentModel? model = await apiService.getCommonResourceList(
          CommonDocumentRequest(
              itemId: "",
              itemType: "event",
              favourite: 0,
              limitedMode: limitedMode));
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        resourceCenterList.clear();
        bookMarkIdsList.clear();
        resourceCenterList.addAll(model.body?.items ?? []);
        isMoreData(model.body?.hasNextPage ?? false);
        resourceCenterBookIds
            .addAll(resourceCenterList.map((obj) => obj.id ?? ""));
        if (resourceCenterBookIds.isNotEmpty) {
          getBookmarkIds();
        }
      } else {
        print(model.code.toString());
      }
    } else {
      CommonDocumentModel? model = await apiService.getCommonDocument(
          CommonDocumentRequest(
              itemId: "",
              itemType: "event",
              favourite: 0,
              limitedMode: limitedMode));
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        resourceCenterList.clear();
        bookMarkIdsList.clear();
        resourceCenterList.addAll(model.body ?? []);
        resourceCenterBookIds
            .addAll(resourceCenterList.map((obj) => obj.id ?? ""));
        if (resourceCenterBookIds.isNotEmpty) {
          getBookmarkIds();
        }
      } else {
        print(model.code.toString());
      }
    }
  }

  Future<void> getBookmarkIds() async {
    try {
      isBookmarkLoading(true);
      BookmarkIdsModel? model = await apiService.getBookmarkIds(
          {"items": resourceCenterBookIds, "item_type": MyConstant.document});
      isBookmarkLoading(false);
      if (model.status! && model.code == 200) {
        bookMarkIdsList.addAll(model.body!
            .where((obj) => obj.favourite != null && obj.favourite!.isNotEmpty)
            .map((obj) => obj.id)
            .toList());
      }
    } catch (exception) {
      isBookmarkLoading(false);
    }
  }

  ///get the list of resource center
  Future<void> getBriefcaseList({required bool isRefresh}) async {
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }

    CommonDocumentModel? model = await apiService.getCommonDocument(
        CommonDocumentRequest(itemId: "", itemType: "event", favourite: 1));
    isFirstLoadRunning(false);
    if (model.status! && model.code == 200) {
      briefcaseList.clear();
      briefcaseList.addAll(model.body ?? []);
    } else {
      print(model.code.toString());
    }
  }

  ///get the list of banner list
  Future<void> getBannerList(
      {required String itemId, required String itemType}) async {
    isFirstLoadRunning(true);

    CommonDocumentModel? model = await apiService.getCommonDocument(
        CommonDocumentRequest(itemId: itemId, itemType: itemType ?? ""));
    isFirstLoadRunning(false);

    if (model.status! && model.code == 200) {
      switch (itemType) {
        case "home_banner":
          bannerList.clear();
          bannerList.addAll(model.body ?? []);
          break;
        case "webinar_banner":
          sessionBannerList.clear();
          sessionBannerList.addAll(model.body ?? []);
          break;
      }
    }
  }

  var isFavLoading = false.obs;

  ///used for the the bookmark to item of every type
  Future<Map> bookmarkToItem(
      {required BookmarkRequestModel requestBody}) async {
    var requestResponse = {};
    BookmarkCommonModel? model = await apiService.bookmarkPutRequest(
        requestBody, AppUrl.commonBookmarkApi);
    if (model.status! && model.code == 200) {
      if (model.body?.id != null && model.body!.id!.isNotEmpty) {
        requestResponse = {"item_id": requestBody.itemId, "status": true};
        // UiHelper.showSuccessMsg(null, model.message ?? "");
      } else {
        requestResponse = {"item_id": requestBody.itemId, "status": false};
        // UiHelper.showFailureMsg(null, model.message ?? "");
      }
    }
    return requestResponse;
  }

  Future<List<dynamic>> getCommonBookmarkIds({required items, itemType}) async {

    print("UserID=${items}");
    var bookMarkIdsList = [];
    if (items.isEmpty) {
      return bookMarkIdsList;
    }
    try {
      BookmarkIdsModel? model = await apiService
          .getBookmarkIds({"items": items, "item_type": itemType});
      if (model.status! && model.code == 200) {
        bookMarkIdsList.clear();
        bookMarkIdsList.addAll(
          model.body!
              .where((obj) =>
                  obj.favourite?.isNotEmpty ==
                  true) // Apply the where condition here
              .map((obj) => obj.id) // Map to the id
              .toList(),
        );
      }
      return bookMarkIdsList;
    } catch (exception) {
      return bookMarkIdsList;
    }
  }

  ///get the block  list of user by ids
  Future<bool> getBlockListByIds(
      {required List<dynamic> items, String? itemType}) async {
    if (items.isEmpty) return false;

    try {
      final BookmarkIdsModel? model =
          await apiService.getBlockedIds({"items": items});

      if (model?.status == true && model?.code == 200) {
        final body = model?.body;
        if (body != null && body.isNotEmpty) {
          final isBlockedList = body.first.isBlocked;
          return isBlockedList != null && isBlockedList.isNotEmpty;
        }
      }
    } catch (exception) {
      return false;
      // Handle exceptions if necessary, e.g., logging
    }

    return false;
  }

  @override
  void dispose() {
    super.dispose();
    loading(false);
  }
}
