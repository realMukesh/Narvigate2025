import 'package:dreamcast/api_repository/app_url.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/pages_model.dart';

class PagesController extends GetxController {
  var loading = false.obs;
  var pagesBody = PagesBody().obs;

  Future<bool> getPagesData({slug}) async {
    loading(true);
    PagesModel model = await apiService.getPagesContent(AppUrl.webview);
    loading(false);
    if (model.head!.status! && model.head!.code == 200) {
      pagesBody(model.body!);
      return true;
    } else {
      return false;
    }
  }
}
