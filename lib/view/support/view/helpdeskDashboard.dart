import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/support/controller/faq_controller.dart';
import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/support/view/sos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../guide/controller/info_guide_controller.dart';
import '../controller/helpdesk_dashboard_controller.dart';
import 'faq_list_page.dart';
import 'techSupportPage.dart';

class HelpDeskDashboard extends GetView<HelpdeskDashboardController> {
  static const routeName = "/HelpDeskDashboard";
  var showToolbar = false;

  HelpDeskDashboard({Key? key, required this.showToolbar}) : super(key: key);
  final selectedTabIndex = 0.obs;
  var tabList = [
    "FAQs",
    "SOS",
    "Support Chat",
  ];
  SOSFaqController _faqController = Get.find();

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
        title:ToolbarTitle(title: "helpDesk".tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: DefaultTabController(
          length: tabList.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
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
                selectedTabIndex(index);
                switch (index) {
                  case 0:
                    _faqController.getFaqList(isRefresh: false);
                    break;
                  case 1:
                    _faqController.getSOSList(isRefresh: false);
                    break;
                }
              },
              tabs: <Widget>[
                ...List.generate(
                  tabList.length,
                  (index) => Tab(
                    text: tabList[index],
                  ),
                ),
              ],
            ),

            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FaqListPage(),
                SOSInfoPag(),
                TechSupportPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
