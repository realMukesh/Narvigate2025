import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/bestForYou/controller/aiMatchController.dart';
import 'package:dreamcast/view/schedule/view/session_list_page.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../bestForYou/view/aiMatch_session_page.dart';
import '../../myFavourites/view/favourite_session_page.dart';
import '../controller/session_controller.dart';

class SessionDashboardPage extends GetView<SessionController> {
  SessionDashboardPage({super.key});

  static const routeName = "/SessionList";
  final AuthenticationManager authenticationManager = Get.find();
  var tabList = ["All Sessions", "", "My Sessions"];

  @override
  final controller = Get.put(SessionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: AppDecoration.commonTabPadding(),
        child: buildSessionTab(),
      ),
    );
  }

  buildSessionTab() {
    return Obx(
      () => DefaultTabController(
        length: tabList.length,
        initialIndex: controller.selectedTabIndex.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: TabBar(
            controller: controller.tabController,
            dividerColor: Colors.transparent,
            isScrollable: true,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            unselectedLabelStyle: GoogleFonts.getFont(MyConstant.currentFont,
                fontSize: 24.fSize,
                fontWeight: FontWeight.w600,
                color: colorGray),
            labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
                fontSize: 24.fSize,
                fontWeight: FontWeight.w600,
                color: colorPrimary),
            onTap: (index) {
              controller.selectedTabIndex(index);
              if (index == 0) {
                controller.getApiData();
              } /*else if (index == 1) {
                controller.dashboardController.selectedAiMatchIndex(1);
                if (Get.isRegistered<AiMatchController>()) {
                  AiMatchController controller = Get.find();
                  controller.getDataByIndexPage(3);
                } else {
                  final controller = Get.put(AiMatchController());
                  controller.getDataByIndexPage(3);
                }
              }*/ else if (index == 1) {
                controller.getFavSessionData();
              }
            },
            tabs: <Widget>[
              Tab(
                text: tabList[0],
              ),
              // Tab(
              //   child: GetBuilder<SessionController>(
              //     builder: (controller) {
              //       return RichText(
              //         text: TextSpan(
              //           children: [
              //             TextSpan(
              //               text: "AI ",
              //               style: GoogleFonts.figtree(
              //                 fontSize: 24.fSize,
              //                 fontWeight: FontWeight.w600,
              //                 foreground: Paint()
              //                   ..shader = const LinearGradient(
              //                     colors: [aiColor1, aiColor2],
              //                     begin: Alignment.bottomRight,
              //                     end: Alignment.topRight,
              //                   ).createShader(const Rect.fromLTWH(
              //                       0, 0, 100, 40)), // Ensure consistent size
              //               ),
              //             ),
              //             TextSpan(
              //               text: "recommended".tr,
              //               style: TextStyle(
              //                 fontFamily: GoogleFonts.figtree().fontFamily,
              //                 fontSize: 24.fSize,
              //                 fontWeight: FontWeight.w600,
              //                 color: controller.selectedTabIndex.value == 1
              //                     ? colorPrimary // Default color when tab is selected
              //                     : colorGray, // Default color when tab is not selected
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Tab(text: tabList[2]
                  // All Sessions
                  ),
            ],
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: [
              SessionListPage(),
              // AiMatchSessionPage(),
              FavouriteSessionPage(
                isFromBookmarkSection: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
