import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/guide/controller/info_guide_controller.dart';
import 'package:dreamcast/view/support/view/faq_list_page.dart';
import 'package:dreamcast/view/guide/view/user_guide_page.dart';
import 'package:dreamcast/view/guide/view/info_about_page.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import 'doDont_page.dart';

class InfoFaqDashboard extends GetView<HomeController> {
  InfoFaqDashboard({super.key});

  static const routeName = "/infoFaqDashboard";
  var tabList = ["About", "User Guide", "Do’s & Don’ts"];
  InfoFaqController _faqController = Get.find();

  final selectedTabIndex = 0.obs;

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
        title: ToolbarTitle(title: "info&faq".tr),
      ),
      body: Container(
        padding:AppDecoration.commonTabPadding(),
        child: DefaultTabController(
          length: tabList.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            // appBar: TabBar(
            //   dividerColor: Colors.transparent,
            //   isScrollable: true,
            //   indicatorColor: Colors.transparent,
            //   tabAlignment: TabAlignment.start,
            //   unselectedLabelColor: colorGray,
            //   unselectedLabelStyle: GoogleFonts.getFont(MyConstant.currentFont,
            //       fontSize: 24.fSize,
            //       fontWeight: FontWeight.w600,
            //       color: colorGray),
            //   labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
            //       fontSize: 24.fSize,
            //       fontWeight: FontWeight.w600,
            //       color: colorPrimary),
            //   onTap: (index) {
            //     selectedTabIndex(index);
            //     switch (index) {
            //       case 0:
            //         _faqController.getHomeApi(isRefresh: false);
            //         break;
            //       case 1:
            //         _faqController.getUserGuide(isRefresh: false);
            //         break;
            //       case 2:
            //         _faqController.getTips(isRefresh: false);
            //         break;
            //     }
            //   },
            //   tabs: <Widget>[
            //     ...List.generate(
            //       tabList.length,
            //       (index) => Tab(text: tabList[index]),
            //     ),
            //   ],
            // ),
            // body: TabBarView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: [
            //     InfoAboutPage(),
            //     UserGuideList(),
            //     DoDontScreen()
            //   ],
            // ),
            body: InfoAboutPage(),
          ),
        ),
      ),
    );
  }
}
