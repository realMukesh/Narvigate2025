import 'package:dreamcast/utils/image_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class TicketController extends GetxController {
  var loading = false.obs;
  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  ScrollController scrollController = ScrollController();
  var dashboardList=[].obs;
  var expendType="".obs;
  Map<String,String> iconList={
    "air": ImageConstant.air_ticket,
    "hotel": ImageConstant.hotel_info,
    "visa": ImageConstant.visa,
  };

  Map<String,String> downloadBtnList={
    "air": "download_air_ticket".tr,
    "hotel": "download_hotel_ticket".tr,
    "visa": "download_visa_ticket".tr,
  };


  @override
  void onInit() {
    super.onInit();
    getInfoDashboard(requestBody: {"page":"1"});
  }

  Future<void> getInfoDashboard({required Map requestBody}) async {
    /*loading(true);
    InfoDashboardModel? model = await apiService.getInfoDashboard(body: requestBody);
    if (model!.head!.status! && model!.head!.code == 200) {
      dashboardList.clear();
      dashboardList.addAll(model.body ?? []);
      loading(false);
    } else {
      loading(false);
      print(model.head?.code.toString());
    }*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loading(false);
  }
}