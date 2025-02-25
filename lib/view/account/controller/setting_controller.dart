import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/view/account/model/createProfileModel.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/exhibitors/model/bookmark_common_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dreamcast/api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../profileSetup/model/profile_update_model.dart';
import 'account_controller.dart';

class SettingController extends GetxController {
  var privacySettingList = <ProfileFieldData>[].obs;
  var isLoading = false.obs;
  final AuthenticationManager _authManager = Get.find();
  late AccountController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find();
    getPrivacyPreferenceField();
  }

  //create profile dynamic
  Future<void> getPrivacyPreferenceField() async {
    isLoading(true);
    CreateProfileModel? createProfileModel =
        await apiService.profileField(AppUrl.getPrivacyPreference);
    isLoading(false);
    if (createProfileModel!.status! && createProfileModel.code == 200) {
      privacySettingList.clear();
      privacySettingList.addAll(createProfileModel.body ?? []);
      _authManager.isMuteNotification(privacySettingList
              .firstWhere((e) => e.name == "is_notification_mute")
              .value ==
          "1");
      update();
    } else {
      print(createProfileModel.code.toString());
    }
  }

  Future<void> updateProfile(
      BuildContext context, List<ProfileFieldData> privacySettingList) async {
    var formData = <String, dynamic>{};
    for (int index = 0; index < privacySettingList.length; index++) {
      var data = privacySettingList[index];
      if (data.value != null) {
        formData["${data.name}"] = data.value.toString();
      }
    }
    isLoading(true);
    ProfileUpdateModel? responseModel = await apiService.updateProfile(
        formData, AppUrl.updatePrivacyPreference);
    isLoading(false);
    if (responseModel!.status!) {
      _authManager.savePrivacyData(
          isChat: responseModel.body?.isChat?.toString() == "1" ? true : false,
          isMeeting:
              responseModel.body?.isMeeting.toString() == "1" ? true : false,
          isProfile: false);
      if (responseModel.body?.isChat.toString() == "1" ||
          responseModel.body?.isMeeting.toString() == "1") {
        accountController.isSelectedSwitch(true);
      } else {
        accountController.isSelectedSwitch(false);
      }
      Get.back(result: "update");
      UiHelper.showSuccessMsg(context, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }

  Future<void> muteNotification(BuildContext context) async {
    isLoading(true);
    BookmarkCommonModel? responseModel = await apiService.bookmarkPostRequest({
      "is_notification_mute": _authManager.isMuteNotification.value ? "0" : "1"
    }, AppUrl.muteNotification);
    isLoading(false);
    if (responseModel.status!) {
      _authManager.isMuteNotification(
          responseModel.body?.muteNotification.toString() == "1" ? true : false);
      UiHelper.showSuccessMsg(context, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }
}
