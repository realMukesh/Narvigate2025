import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/support/model/faq_model.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../breifcase/model/BriefcaseModel.dart';
import '../../breifcase/model/common_document_request.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../model/sos_model.dart';

class SOSFaqController extends GetxController {
  var loading = false.obs;
  var isFirstLoading = false.obs;
  var guideList = <DocumentData>[].obs;
  var faqList = <dynamic>[].obs;

  var sosList = <SosData>[].obs;


  @override
  void onInit() {
    super.onInit();
    getFaqList(isRefresh: false);
  }

  Future<void> getUserGuide({required isRefresh}) async {
    if (!isRefresh) {
      isFirstLoading(true);
    }
    CommonDocumentModel? model = await apiService.getCommonDocument(
        CommonDocumentRequest(itemId: "", itemType: "guide"));
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      guideList.clear();
      guideList.addAll(model.body ?? []);
    }
  }

  Future<void> getFaqList({isRefresh}) async {
    var jsonRequest = {"page": "1"};
    if (!isRefresh) {
      isFirstLoading(true);
    }
    FaqModel? model = await apiService.getFaqList(jsonRequest);
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      faqList.clear();
      faqList.addAll(model.body ?? []);
    }
  }

  Future<void> getSOSList({isRefresh}) async {
    var jsonRequest = {"page": "1"};
    if (!isRefresh) {
      isFirstLoading(true);
    }
    SOSDataModel? model = await apiService.getSOSData(jsonRequest);
    isFirstLoading(false);
    if (model.status! && model.code == 200) {
      sosList.clear();
      sosList.addAll(model.body ?? []);
      sosList.refresh();
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
