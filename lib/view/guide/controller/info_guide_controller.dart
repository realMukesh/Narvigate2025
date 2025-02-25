import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/support/model/faq_model.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../breifcase/model/BriefcaseModel.dart';
import '../../breifcase/model/common_document_request.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../home/model/config_detail_model.dart';
import '../model/dodont_model.dart';

class InfoFaqController extends GetxController {
  var loading = false.obs;
  var isFirstLoading = false.obs;
  var guideList = <DocumentData>[].obs;
  var tipsList =TipsBody().obs;
  var configDetailBody = HomeConfigBody().obs;


  @override
  void onInit() {
    super.onInit();
    getHomeApi(isRefresh: false);
  }

  Future<void> getHomeApi({required bool isRefresh}) async {
    if (!isRefresh) {
      isFirstLoading(true);
    }
    isFirstLoading(true);
    HomePageModel? model = await apiService.getHomePageData();
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      configDetailBody(model.homeConfigBody);
      configDetailBody.refresh();
    }
  }

  Future<void> getUserGuide({required isRefresh}) async {
    if (!isRefresh) {
      isFirstLoading(true);
    }
    CommonDocumentModel? model =
        await apiService.getCommonDocument(CommonDocumentRequest(
            itemId: "", itemType: "guide"));
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      guideList.clear();
      guideList.addAll(model.body ?? []);
    }
  }

  Future<void> getTips({isRefresh}) async {
    var jsonRequest = {"page": "1"};
    if (!isRefresh) {
      isFirstLoading(true);
    }
    TipsDataModel? model = await apiService.getTipsData(jsonRequest);
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      tipsList(model.body);
      tipsList.refresh();
    }
  }

  Future<void> bookmarkToItem(int index) async {
    var jsonRequest = {"item_id": guideList[index].id, "item_type": "document"};
    loading(true);
    BookmarkCommonModel? model = await apiService.bookmarkPutRequest(
        jsonRequest, AppUrl.commonBookmarkApi);
    loading(false);
    if (model.status! && model.code == 200) {
      guideList[index].favourite = model.body?.id ?? "";
      guideList.refresh();
      UiHelper.showSuccessMsg(null, model.body?.message ?? "");
    }
  }
}
