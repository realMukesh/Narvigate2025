
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/button/rounded_button.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class HotelDetailsWidget extends GetView<TravelDeskController>{
  HotelDetailsWidget({super.key});


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      separatorBuilder: (context, index){
        return const SizedBox(height: 20);
      },
      itemCount: 1,
      itemBuilder: (context, index){
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.circular(10),
          ),
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
                          text: "Hotel Name" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "The Taj Hotel, Mumbai" ?? "",
                          fontSize: 18.h,
                          maxLines: 10,
                          color: colorSecondary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "(Booking ID - AF244)" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SvgPicture.asset(ImageConstant.ic_location_pointer),
                  ],
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
                          text: "Check-in" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "10th Jan, 2025" ?? "",
                          fontSize: 18.h,
                          maxLines: 10,
                          color: colorSecondary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "11:00 AM" ?? "",
                          fontSize: 14.h,
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
                          text: "Check-out" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "12th Jan, 2025" ?? "",
                          fontSize: 18.h,
                          maxLines: 10,
                          color: colorSecondary,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "10:00 AM" ?? "",
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
                        text: "Accompanied By" ?? "",
                        fontSize: 14.h,
                        maxLines: 10,
                        color: colorGray,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextView(
                        text: "Rohan Singh, Aman Mehra" ?? "",
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
                          text: "Room No." ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "201" ?? "",
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
                          text: "No. of Person" ?? "",
                          fontSize: 14.h,
                          maxLines: 10,
                          color: colorGray,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomTextView(
                          text: "3" ?? "",
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
                        text: "Address" ?? "",
                        fontSize: 14.h,
                        maxLines: 10,
                        color: colorGray,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextView(
                        text: "Apollo Bandar, Colaba, Mumbai, Maharashtra 400001" ?? "",
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
                text: "download_hotel_details".tr,
                textSize: 16,
                iconHeight: 19,
                svgIcon: ImageConstant.download_icon,
                onPressed: () {
                  // Add your functionality here
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}