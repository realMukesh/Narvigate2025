import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:get/get.dart';

import 'faq_controller.dart';

class HelpdeskDashboardController extends GetxController{

  @override
  void onInit() {
    super.onInit();
   // initController();
  }
  Future<void> initController() async {
    Get.lazyPut(() => SupportController(), fenix: true);
    //Get.lazyPut(() => SOSFaqController(), fenix: true);
    Get.put<SOSFaqController>(SOSFaqController());


  }
}