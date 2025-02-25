
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CabDetailsWidget extends GetView<TravelDeskController>{
  CabDetailsWidget({super.key});


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
                    text: "Pickup Details" ?? "",
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
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "Contact Person" ?? "",
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
                              text: "Cab Number" ?? "",
                              fontSize: 14.h,
                              maxLines: 10,
                              color: colorGray,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomTextView(
                              text: "RJ-45 CK 3543" ?? "",
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
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "Contact Number" ?? "",
                              fontSize: 14.h,
                              maxLines: 10,
                              color: colorGray,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomTextView(
                              text: "+91 98280 98280" ?? "",
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