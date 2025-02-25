import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/view/menu/view/shiftingPdfPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../model/shiftingModel.dart';

class ShiftingController extends GetxController with  GetSingleTickerProviderStateMixin {
  var loading = false.obs;
  var contentLoading = false.obs;
  var downloadPath="";
  var downloadFileName="";

  late TabController _tabController;
  TabController get tabController => _tabController;
  var shiftingList=[].obs;
  var tabIndex=0.obs;
  var pdfUrl="".obs;


  //get shifting Page detail
  Future<void> getShiftingPageDetail(String? title) async {
    loading(true);
    ShiftingDetailModel? model = await apiService.getShiftingDetail();
    if (model?.head?.status ?? false) {
      shiftingList.clear();
      shiftingList.addAll(model.body??[]);
      Get.to(ShifingPdfPage());
    }
    loading(false);
  }

  //gt
  Future<void> saveShftingData(dynamic requestBody) async {
    loading(true);
    CommonModel? model = await apiService.commonPostRequest(requestBody,AppUrl.saveShiftingDetail);
    if (model?.status ?? false) {
      UiHelper.showSuccessMsg(null, model?.message??"");
    }else{
      UiHelper.showFailureMsg(null, model?.message??"");
    }
    loading(false);
  }

}

