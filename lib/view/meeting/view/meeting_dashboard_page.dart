import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/meeting/view/confirm_meeting_page.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/toolbarTitle.dart';
import 'invites_meeting_page.dart';

class MyMeetingList extends GetView<MeetingController> {
  MyMeetingList({super.key});
  static const routeName = "/MyMeetingList";

  /*@override
  var controller = Get.put(MeetingController());*/

  var tabList = ["Confirmed", "Invites"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: ToolbarTitle(title: "myMeetings".tr),
      ),
      body: GetX<MeetingController>(
        builder: (controller) {
          return DefaultTabController(
            initialIndex: controller.selectedTabIndex.value,
            length: tabList.length,
            child: Scaffold(
              backgroundColor: white,
              appBar: TabBar(
                dividerColor: indicatorColor,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: colorPrimary,
                unselectedLabelStyle: GoogleFonts.getFont(
                    MyConstant.currentFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorGray),
                labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colorPrimary),
                onTap: (index) {
                  controller.countBadge(0);
                  controller.selectedTabIndex.value = index;
                  controller.getMeetingList(requestBody: {
                    "page": "1",
                    "filters": {
                      "status": index == 0
                          ? controller.confirmStatus.value
                          : controller.invitesStatus.value
                    },
                  }, isRefresh: false);
                },
                tabs: <Widget>[
                  ...List.generate(
                      tabList.length,
                      (index) => Tab(
                          height: 52,
                          text: tabList[index])),
                ],
              ),
              body: TabBarView(
                //controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [ConfirmMeetingPage(), InvitesMeetingPage()],
              ),
            ),
          );
        },
      ),
    );
  }
}
