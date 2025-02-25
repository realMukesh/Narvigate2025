import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/my_constant.dart';
import '../../theme/app_colors.dart';
import '../../view/quiz/view/feedback_page.dart';
import '../../view/support/view/helpdeskDashboard.dart';
import '../button/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class HomeFeedbackWidget extends StatelessWidget {
  const HomeFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Center(
        child: SizedBox(
          width: 184.adaptSize,
          child: CustomOutlinedButton(
            buttonStyle: OutlinedButton.styleFrom(
              backgroundColor: white,
              side: const BorderSide(color: colorPrimary, width: 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            buttonTextStyle: GoogleFonts.getFont(MyConstant.currentFont,
                color: colorPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 16.fSize),
            onPressed: () {
              Get.toNamed(FeedbackPage.routeName);
            },
            text: "feedback".tr,
          ),
        ),
      ) /*Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomOutlinedButton(
              buttonStyle: OutlinedButton.styleFrom(
                backgroundColor: white,
                side: const BorderSide(color: colorPrimary, width: 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              buttonTextStyle: GoogleFonts.getFont(MyConstant.currentFont,
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.fSize),
              onPressed: () {
                Get.toNamed(FeedbackPage.routeName);
              },
              text: "feedback".tr,
            ),
            //flex: 6,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            //flex: 4,
            child: CustomOutlinedButton(
              buttonStyle: OutlinedButton.styleFrom(
                backgroundColor: white,
                side: const BorderSide(color: colorPrimary, width: 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              buttonTextStyle:GoogleFonts.getFont(MyConstant.currentFont,
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.fSize),
              onPressed: () {
                Get.toNamed(HelpDeskDashboard.routeName);
              },
              text: "helpDesk".tr,
            ),
          )
        ],
      )*/
      ,
    );
  }
}
