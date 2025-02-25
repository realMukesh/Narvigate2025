import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/leaderboard/view/criteria_page.dart';
import 'package:dreamcast/view/leaderboard/view/leaderboard_page.dart';
import 'package:dreamcast/view/leaderboard/view/my_points_page.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/leaderboard_controller.dart';

class LeaderboardDashboardPage extends GetView<LeaderboardController> {
  static String routeName = '/LeaderboardPage';

  const LeaderboardDashboardPage({super.key});

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
        title: ToolbarTitle(title: "leaderboard".tr),
      ),
      body: DefaultTabController(
        length: controller.tabList.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelColor: colorSecondary,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.center,
            unselectedLabelStyle: TextStyle(
                fontSize: 22.fSize,
                fontWeight: FontWeight.w600,
                color: colorGray),
            labelStyle: TextStyle(
                fontSize: 22.fSize,
                fontWeight: FontWeight.w600,
                color: colorSecondary),
            onTap: (index) {
              controller.selectedTabIndex(index);
              // switch (index) {
              //   case 1:
              //     _faqController.getUserGuide(isRefresh: false);
              //     break;
              //   case 2:
              //     _faqController.getTips(isRefresh: false);
              //     break;
              // }
            },
            tabs: <Widget>[
              ...List.generate(
                controller.tabList.length,
                (index) => Obx(() => Tab(
                      child: Text(
                        controller.tabList[index],
                        style: TextStyle(
                            color: controller.selectedTabIndex.value == index
                                ? colorPrimary
                                : colorGray),
                      ),
                      // All Sessions
                    )),
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                LeaderboardPage(),
                CriteriaPage(),
                MyPointsPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
