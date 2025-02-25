import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/globalSearch/controller/globleSearchController.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:get/get.dart';
import '../speakers/controller/speakersController.dart';

class GlobalSearchBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => GlobalSearchController(),fenix: true);
    Get.lazyPut(() => SpeakersDetailController(),fenix: true);
    Get.lazyPut(() => BootController(),fenix: true);
    Get.lazyPut(() => NetworkingController(),fenix: true);

  }
}