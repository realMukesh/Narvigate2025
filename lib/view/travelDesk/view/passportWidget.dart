
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PassportWidget extends GetView<TravelDeskController>{
  PassportWidget({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text: "Name" ?? "",
                    fontSize: 16.h,
                    maxLines: 10,
                    color: colorGray,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomTextView(
                    text: "Mr. Jaideep Singh" ?? "",
                    fontSize: 18.h,
                    maxLines: 10,
                    color: colorSecondary,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ],
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
                        text: "Passport Number" ?? "",
                        fontSize: 14.h,
                        maxLines: 10,
                        color: colorGray,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextView(
                        text: "A12345678" ?? "",
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
                          text: "Valid From" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "15th Dec, 2024" ?? "",
                          fontSize: 18.h,
                          maxLines: 10,
                          color: colorSecondary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: "Valid Till" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "14th Dec, 2025" ?? "",
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
            ],
          ),
        ),
      ],
    );
  }
}