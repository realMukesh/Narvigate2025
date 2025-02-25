import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:dreamcast/view/menu/controller/menuController.dart';
import 'package:get/get.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import '../account/controller/account_controller.dart';
import '../breifcase/controller/common_document_controller.dart';
import 'dashboard_controller.dart';
import 'deep_linking_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    Get.put<HomeController>(HomeController());
    Get.put<CommonDocumentController>(CommonDocumentController());
    Get.put<HubController>(HubController());
    Get.put<EventFeedController>(EventFeedController());
    Get.put<DeepLinkingController>(DeepLinkingController());
    Get.put<AccountController>(AccountController());



  }
}