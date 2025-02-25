import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/ui_helper.dart';
import '../../utils/dialog_constant.dart';
import '../../widgets/customImageWidget.dart';
import '../../widgets/customTextView.dart';
import '../beforeLogin/globalController/authentication_manager.dart';

class FeatureExhibitorChild extends GetView<BootController> {
  FeatureExhibitorChild({super.key});
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<BootController>(
      builder: (controller) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 122),
          child: Skeletonizer(
            enabled: controller.isFirstLoadRunning.value,
            child: controller.isFirstLoadRunning.value
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: context.width * 0.8,
                        height: context.height,
                        decoration: BoxDecoration(
                            color: colorLightGray,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: indicatorColor, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Flexible(
                                        child: CustomTextView(
                                          text: "exhibitor.fasciaName",
                                          color: colorSecondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.v,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: CustomTextView(
                                          text: "Booth No.",
                                          color: colorGray,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: CustomTextView(
                                          text: "Hall No.",
                                          color: colorGray,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.exhibitorsFeatureList.length,
                    itemBuilder: (context, index) {
                      var exhibitor = controller.exhibitorsFeatureList[index];
                      return InkWell(
                        onTap: () {
                          if (!authenticationManager.isLogin()) {
                            DialogConstant.showLoginDialog(
                                context, authenticationManager);
                            return;
                          }
                          controller.getExhibitorsDetail(exhibitor.id);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: context.width * 0.8,
                          decoration: BoxDecoration(
                              color: colorLightGray,
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(color: indicatorColor, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: white,borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      height: 102.adaptSize,width: 102.adaptSize,
                                      child: UiHelper.getExhibitorImage(
                                          imageUrl: exhibitor.avatar ?? ""),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: CustomTextView(
                                            text: exhibitor.fasciaName ?? "",
                                            color: colorSecondary,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 9.v,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: CustomTextView(
                                            text:
                                                "Booth No. ${exhibitor.boothNumber ?? ""}",
                                            color: colorGray,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: CustomTextView(
                                            text:
                                                "Hall No. ${exhibitor.hallNumber ?? ""}",
                                            color: colorGray,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        );
      },
    );
  }
}
