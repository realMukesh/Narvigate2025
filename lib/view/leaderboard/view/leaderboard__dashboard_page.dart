import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../controller/leaderboard_controller.dart';
import 'my_criterias_page.dart';
import 'my_points_page.dart';
import 'my_rankings_page.dart';

class LeaderboardDashboardPage extends StatefulWidget {
  const LeaderboardDashboardPage({Key? key}) : super(key: key);
  static const routeName = "/LeaderBoardPage";

  @override
  State<LeaderboardDashboardPage> createState() => _LeaderboardDashboardPage();
}

class _LeaderboardDashboardPage extends State<LeaderboardDashboardPage>
    with SingleTickerProviderStateMixin {
  var tabList = ["Leaderboard", "Criteria", "My Points"];
  final leaderboardController = Get.put(LeaderboardController());
  int tabIndex = 0;

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
        title: const ToolbarTitle(title: "Leaderboard"),
      ),
      body: DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          backgroundColor: white,
          appBar: TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelColor: colorSecondary,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.tab,
            //labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.h),
            //labelColor: colorSecondary,
            unselectedLabelStyle: TextStyle(
                fontSize: 22.fSize,
                fontWeight: FontWeight.w500,
                color: colorGray),
            labelStyle: TextStyle(
                fontSize: 22.fSize,
                fontWeight: FontWeight.w500,
                color: colorSecondary),
            //indicatorColor: colorSecondary,
            onTap: (index) {
              leaderboardController.tabController.index = index;
              leaderboardController.selectedTabIndex(index);
              leaderboardController.getLeaderboard();
            },
            tabs: <Widget>[
              ...List.generate(
                tabList.length,
                    (index) =>
                    Obx(() =>
                        Tab(
                          child: Text(
                            tabList[index],
                            style: TextStyle(
                                color: leaderboardController.selectedTabIndex

                                    .value == index
                                    ? colorPrimary
                                    : colorGray),
                          ),
                        ),),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //const Divider(height: 1,color: indicatorColor,),
              Expanded(child: TabBarView(
                controller: leaderboardController.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const MyRankingPage(), //MyRankingPage(),
                  CriteriasPage(),
                  MyPointsPage(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

}