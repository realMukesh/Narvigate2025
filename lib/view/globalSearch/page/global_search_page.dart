import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/globalSearch/controller/globleSearchController.dart';
import 'package:dreamcast/view/globalSearch/page/search_exhibitor_page.dart';
import 'package:dreamcast/view/globalSearch/page/search_session_page.dart';
import 'package:dreamcast/view/globalSearch/page/search_speakers_page.dart';
import 'package:dreamcast/view/globalSearch/page/search_user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/custom_search_view.dart';

class GlobalSearchPage extends GetView<GlobalSearchController> {
  GlobalSearchPage({super.key});
  var searchTagList = ["Sessions", "Speakers"];
  static const routeName = "/globalSearchPage";

  final globalController = Get.put(GlobalSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(toolbarHeight: 0,),
      body: GetX<GlobalSearchController>(
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
                child: Row(
                  children: [
                    AppbarLeadingImage(
                      imagePath: ImageConstant.imgArrowLeft,
                      margin: EdgeInsets.only(
                        left: 0.h,
                        top: 3,
                        // bottom: 12.v,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    Expanded(child: _buildSearchSection(),)
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              Expanded(child: DefaultTabController(
                initialIndex: 0,
                length: searchTagList.length,
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
                      controller.selectedSearchIndex(index);
                      controller.selectedSearchTag(searchTagList[index]);
                      tabIndexAndSearch(false);
                    },
                    tabs: <Widget>[
                      ...List.generate(
                        searchTagList.length,
                            (index) => Tab(
                          text: searchTagList[index],
                        ),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // controller.selectedSearchIndex.value == 0
                      //     ? SearchExhibitorPage()
                      //     : const SizedBox(),
                      // controller.selectedSearchIndex.value == 1
                      //     ? SearchUserPage()
                      //     : const SizedBox(),
                      controller.selectedSearchIndex.value == 0
                          ? SearchSessionPage()
                          : const SizedBox(),
                      controller.selectedSearchIndex.value == 1
                          ? SearchSpeakerPage()
                          : const SizedBox(),
                    ],
                  ),
                ),
              ))
            ],
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchSection() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 0.h,
        right: 0.h,
      ),
      child: NewCustomSearchView(
        isShowFilter: false,
        hintText: "search_here".tr,
        controller: controller.textController.value,
        onSubmit: (result) {
          controller.textController.refresh();
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            tabIndexAndSearch(false);
          }
        },
        onClear: (result) {
          controller.textController.refresh();
          FocusManager.instance.primaryFocus?.unfocus();
          tabIndexAndSearch(true);
        },
        press: () async {},
      ),
    );
  }

  tabIndexAndSearch(bool isRefresh) {
    switch (controller.selectedSearchTag.value) {
      // case "Exhibitors":
      //   controller.getSearchExhibitorsApi(isRefresh: isRefresh);
      //   controller.selectedSearchIndex(0);
      //   break;
      // case "Networking":
      //   controller.networkRequestModel.filters?.text =
      //       controller.textController.value.text.trim() ?? "";
      //   controller.getSearchUserApi(isRefresh: isRefresh);
      //   controller.selectedSearchIndex(1);
      //   break;
      case "Sessions":
        controller.selectedSearchIndex(0);
        controller.getSearchSessionApi(isRefresh: isRefresh);

        break;
      case "Speakers":
        controller.selectedSearchIndex(1);
        controller.networkRequestModel.filters?.text =
            controller.textController.value.text.trim() ?? "";
        controller.getSearchSpeakerApi(isRefresh: isRefresh);
        break;
    }
  }
}
