import 'package:dreamcast/view/contact/controller/contact_controller.dart';
import 'package:dreamcast/view/qrCode/model/qrScannedUserDetails_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/badge_model.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../model/unique_code_model.dart';
import '../model/user_detail_model.dart';

class QrPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = false.obs;
  var userFound = false.obs;
  final AuthenticationManager controller = Get.find();
  var vCard = ContactCard.create("", "", "", "", "", "", "").obs;
  var badgeMessage = "".obs;
  var qrBadge = "".obs;
  late TabController _tabController;
  TabController get tabController => _tabController;
  var isCameraPermissionDenied = false.obs;


  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(vsync: this, length: 3);
    if (Get.arguments != null && Get.arguments["tab_index"] != null) {
      _tabController.index = Get.arguments["tab_index"];
    }
    getUniqueCode();
  }

  clearQr(){
    qrBadge = "".obs;
    loading(true);
    controller.update();
  }



  ///get badge detail
  Future<void> getUniqueCode() async {
    loading(true);
    BadgeModel? model = await apiService.getBadge();
    loading(false);
    if (model.status ?? false) {
      // print("MBadge url: $qrBadge");
      qrBadge(model.body?.mbadge ?? "");
      badgeMessage(model.body?.message?.body ?? "");
      controller.update();
    }
  }

  ///get the user detail by unique code.
  Future<QrScannedUserDetailsModel> getUserDetail(BuildContext context, uniqueCode) async {
    loading(true);
    QrScannedUserDetailsModel? model = await apiService.getUserDetailByCode(uniqueCode);
    loading(false);
    if (model.status ?? false) {
      uniqueCode=uniqueCode;
      // await Get.to(SaveContactPage(
      //   userModel: model,
      //   code: uniqueCode,
      // ));
      _tabController.index = 2;
      return model;
    } else {
      // Reset QR scanner
      UiHelper.showFailureMsg(context, "data_not_found".tr);
      return model;
    }
  }

  ///save the context to app contact list
  Future<UniqueCodeModel?> saveUserToContact(BuildContext context, dynamic data) async {
    loading(true);
    UniqueCodeModel? model =
        await apiService.saveUserToContact(jsonRequest: data);
    if (model?.status ?? false) {
      if (Get.isRegistered<ContactController>()) {
        ContactController controller = Get.find();
        controller.getContactList(requestBody: {
          "page": "1",
          "filters": {"search": "", "sort": "ASC",}
        });
      }
      _tabController.index = 2;
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.icSuccessAnimated,
            description: model.message ?? "",
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              //Get.back();
            },
          ));
      return model;
    } else {
      UiHelper.showFailureMsg(context, model?.message ?? "");
    }
    loading(false);
    return null;
  }

  refreshTheContact() async {
    if (Get.isRegistered<ContactController>()) {
      ContactController controller = Get.find();
      await controller.getContactList(requestBody: {
        "page": "1",
        "filters": {
          "search": "",
          "sort": "ASC",
          "type": ""
        }
      });
      Get.back(result: true);
    } else {
      Get.back(result: true);
    }
  }


  String textSelect(String str) {
    str = str.replaceAll(';', '');
    str = str.replaceAll('type', '');
    str = str.replaceAll('tel', '');
    str = str.replaceAll('adr', '');
    str = str.replaceAll('pref', '');
    str = str.replaceAll('=', '');
    str = str.replaceAll(',', '');
    str = str.replaceAll('work', '');
    str = str.replaceAll('TELTYPE', '');
    return str;
  }
}

class ContactCard {
  String? name;
  String? mobile;
  String? email;
  String? company;
  String? uniqueCode;
  String? avtar;
  String shortName;
  ContactCard.create(this.name, this.email, this.company, this.uniqueCode,
      this.avtar, this.shortName, this.mobile);
}
