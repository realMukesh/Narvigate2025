
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/button/rounded_button.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VisaDetailsWidget extends GetView<TravelDeskController>{
  VisaDetailsWidget({super.key});


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CustomTextView(
                text: "Your Visa is ready so you can download your copy by clicking below button" ?? "",
                fontSize: 16.h,
                maxLines: 10,
                color: colorSecondary,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20,),
              CommonMaterialButton(
                color: colorPrimary,
                text: "download_visa".tr,
                textSize: 16,
                iconHeight: 19,
                svgIcon: ImageConstant.download_icon,
                onPressed: () {
                  // Add your functionality here
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}