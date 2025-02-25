import 'dart:io';

import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/account/view/privacy_preference.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/more/widget/timezone_page.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/rounded_button.dart';

class SettingPage extends GetView<SettingController> {
  static const routeName = "/setting_page";
  SettingPage({Key? key}) : super(key: key);
  AuthenticationManager authenticationManager = Get.find();
  DashboardController dashboardController = Get.find();

  var settingItemList = [
    MenuItem.createItem(
        title: "privacy_preference".tr,
        isTrailing: true,
        color: colorSecondary,
        leading: ImageConstant.privacy_prefrence),
    MenuItem.createItem(
        title: "time_zone".tr,
        isTrailing: true,
        color: colorSecondary,
        leading: ImageConstant.timezone),
    /*MenuItem.createItem(
        title: "My Availability", iconUrl: "assets/svg/my_availability.svg"),*/
    MenuItem.createItem(
        title: "mute_notification".tr,
        isTrailing: true,
        color: colorSecondary,
        leading: ImageConstant.mute_notification),
    MenuItem.createItem(
        title: "logout".tr,
        isTrailing: false,
        color: const Color(0xffDE3C34),
        leading: ImageConstant.logoutSvg)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(title: "profile_settings".tr),
      ),
      body: GetX<SettingController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 0),
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: settingItemList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        switch (index) {
                          case 0:
                            Get.toNamed(PrivacyPreference.routeName);
                            break;
                          case 1:
                            Get.to(() => TimezonePage());
                            break;
                          /*case 2:
                            UiHelper.showFailureMsg(
                                context, "This functionality has been removed");
                            //Get.to(() => MyAvailabilityPage());
                            break;*/
                          case 2:
                            controller.muteNotification(context);
                            break;
                          case 3:
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogWidget(
                                  title: "Logout?",
                                  logo: ImageConstant.logout,
                                  description: "Are you sure you want to logout?",
                                  buttonAction: "Yes, Logout",
                                  buttonCancel: "Cancel",
                                  onCancelTap: () {},
                                  onActionTap: () async {
                                    authenticationManager.logoutTheUserAPi();
                                  },
                                );
                              },
                            );
                            break;
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              settingItemList[index].leading ?? "",
                              width: 36,
                            ),
                            title: CustomTextView(
                              text: settingItemList[index].title ?? "",
                              color: settingItemList[index].color!,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                              fontSize: 20,
                              maxLines: 2,
                            ),
                            trailing: settingItemList[index].isTrailing
                                ? index != 2
                                    ? SvgPicture.asset(
                                        ImageConstant.common_arrow,
                                        width: 9,
                                      )
                                    : Obx(
                                        () => SvgPicture.asset(
                                            authenticationManager
                                                    .isMuteNotification.value
                                                ? ImageConstant.toggleOn
                                                : ImageConstant.toggleOff),
                                      )
                                : null,
                          ),
                        ],
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 6,
                      color: indicatorColor,
                    );
                },
                ),
                authenticationManager.showForceUpdateDialog.value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: updateAppWidget(),
                      )
                    : const SizedBox(),
                controller.accountController.isLoading.value ||
                        controller.isLoading.value
                    ? const Loading()
                    : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }

  Widget updateAppWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 21),
              child: SvgPicture.asset(ImageConstant.icUpdateApp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextView(
                  text: "batter_then_ever".tr,
                  color: colorSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 6,
                ),
                CustomTextView(
                  text: "version_alert".tr,
                  color: colorSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 131,
                  child: CommonMaterialButton(
                    text: "update_app".tr,
                    height: 40, textSize: 16,
                    color: colorPrimary,
                    onPressed: () async {
                      var url = Platform.isAndroid
                          ? authenticationManager
                                  .configModel.body?.flutter?.playStoreUrl ??
                              ""
                          : authenticationManager
                                  .configModel.body?.flutter?.appStoreUrl ??
                              "";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    weight: FontWeight.w500, // Medium font weight
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  String? title;
  String? leading;
  bool isTrailing;
  Color? color;
  MenuItem.createItem(
      {required this.title,
      required this.leading,
      required this.isTrailing,
      required this.color});
}
