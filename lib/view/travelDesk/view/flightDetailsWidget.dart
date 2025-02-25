
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/button/rounded_button.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class FlightDetailsWidget extends GetView<TravelDeskController>{
  FlightDetailsWidget({super.key});


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      separatorBuilder: (context, index){
        return const SizedBox(height: 20);
      },
      itemCount: 2,
      itemBuilder: (context, index){
        return Container(
          decoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text: "Arrival Details" ?? "",
                    fontSize: 18.h,
                    maxLines: 10,
                    color: colorPrimary,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: indicatorColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: "From" ?? "",
                                fontSize: 16.h,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: "JAI" ?? "",
                                fontSize: 22.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w700,
                              ),
                              CustomTextView(
                                text: "Jaipur" ?? "",
                                fontSize: 14.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SvgPicture.asset(ImageConstant.arrows),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextView(
                                text: "To" ?? "",
                                fontSize: 16.h,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: "BOM" ?? "",
                                fontSize: 22.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w700,
                              ),
                              CustomTextView(
                                text: "Mumbai" ?? "",
                                fontSize: 14.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: indicatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "Date of Travel" ?? "",
                              fontSize: 14.h,
                              maxLines: 10,
                              color: colorGray,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomTextView(
                              text: "15th July, 2024" ?? "",
                              fontSize: 18.h,
                              maxLines: 10,
                              color: colorSecondary,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: indicatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: "PNR Number" ?? "",
                                fontSize: 14.h,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: "FPUS2T" ?? "",
                                fontSize: 18.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextView(
                                text: "Airline" ?? "",
                                fontSize: 14.h,
                                maxLines: 10,
                                color: colorGray,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomTextView(
                                text: "Indigo (6E-23FD)" ?? "",
                                fontSize: 18.h,
                                maxLines: 10,
                                color: colorSecondary,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: indicatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "Terminal" ?? "",
                              fontSize: 14.h,
                              maxLines: 10,
                              color: colorGray,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomTextView(
                              text: "2" ?? "",
                              fontSize: 18.h,
                              maxLines: 10,
                              color: colorSecondary,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CommonMaterialButton(
                      color: colorPrimary,
                      text: "download_air_ticket".tr,
                      textSize: 16,
                      iconHeight: 19,
                      svgIcon: ImageConstant.download_icon,
                      onPressed: () {
                        // Add your functionality here
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}