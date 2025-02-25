
import 'package:dreamcast/utils/pref_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../api_repository/api_service.dart';
import '../network/network_info.dart';
import '../view/beforeLogin/globalController/authentication_manager.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefUtils());
    Get.put<AuthenticationManager>(AuthenticationManager());
    Get.putAsync<ApiService>(() => ApiService().init());
    //Connectivity connectivity = Connectivity();
    //Get.put(NetworkInfo(connectivity));
  }
}
