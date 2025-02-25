import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TravelDeskController extends GetxController {

  final tabIndex = 0.obs;
  var tabList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    createTab();
  }


  Future<void> createTab() async {
    tabList.clear();
    tabList.add("Flight Details");
    tabList.add("Cab Details");
    tabList.add("Hotel Details");
    tabList.add("Visa Details");
    tabList.add("Passport");
  }


}