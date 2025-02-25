
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/travelDesk/controller/travelDeskController.dart';
import 'package:dreamcast/view/travelDesk/view/cabDetailsWidget.dart';
import 'package:dreamcast/view/travelDesk/view/flightDetailsWidget.dart';
import 'package:dreamcast/view/travelDesk/view/hotelDetailsWidget.dart';
import 'package:dreamcast/view/travelDesk/view/passportWidget.dart';
import 'package:dreamcast/view/travelDesk/view/visaDetailsWidget.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelDeskPage extends GetView<TravelDeskController>{
  TravelDeskPage({super.key});

  static const routeName = "/TravelDeskPage";
  final travelDeskController = Get.put(TravelDeskController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

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
        title: ToolbarTitle(title: Get.arguments ?? "travelDesk".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: DefaultTabController(
          initialIndex: 0,
          length: controller.tabList.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              labelColor: colorPrimary,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              unselectedLabelStyle: TextStyle(
                  fontSize: 22.fSize,
                  fontWeight: FontWeight.w600,
                  color: colorGray),
              labelStyle: TextStyle(
                  fontSize: 22.fSize,
                  fontWeight: FontWeight.w600,
                  color: colorSecondary),
              onTap: (index) {
                controller.tabIndex(index);
              },
              tabs: <Widget>[
                ...List.generate(
                  controller.tabList.length,
                      (index) => Tab(
                    text: controller.tabList[index],
                  ),
                ),
              ],
            ),
            body:  TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ...List.generate(
                  controller.tabList.length,
                      (index) => controller.tabList[index] == "Flight Details"
                          ? FlightDetailsWidget()
                       : controller.tabList[index] == "Cab Details"
                          ? CabDetailsWidget()
                          : controller.tabList[index] == "Hotel Details"
                          ? HotelDetailsWidget()
                      : controller.tabList[index] == "Visa Details"
                ? VisaDetailsWidget()
                : controller.tabList[index] == "Passport"
                          ? PassportWidget()
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}