import 'dart:io';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import '../widgets/button/rounded_button.dart';
import '../widgets/dialog/custom_dialog_widget.dart';
import 'pref_utils.dart';

class DialogConstant {
  ///common used   show dialog in case of not login
  static showLoginDialog(
      BuildContext context, AuthenticationManager authManager) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogWidget(
            title: "Login?",
            logo: ImageConstant.logout,
            description: "To access these features, you need to log in",
            buttonAction: "Yes, Login",
            buttonCancel: "Cancel",
            onCancelTap: () {},
            onActionTap: () async {
              PrefUtils().setToken("");
              Get.back();
              Get.toNamed(Routes.LOGIN);
            },
          );
        },
      );
  }

  static showPermissionDialog({String? message}) {
    Get.dialog(AlertDialog(
      content:  Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0),
          child: CustomTextView(
              text: message??"camera_permission_content".tr,
              color: Colors.black, // Adjust text color if needed
              fontSize: 18,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: colorSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: CustomTextView(
                    text: "cancel".tr,
                    color: colorSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium font weight
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CommonMaterialButton(
                  text: "Settings".tr,
                  height: 46,
                  color: colorPrimary,
                  onPressed: () async {
                    Get.back();
                    await openAppSettings();

                  },
                  weight: FontWeight.w500, // Medium font weight
                ),
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12), // Adjust border radius for dialog
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
    ));
  }

}
