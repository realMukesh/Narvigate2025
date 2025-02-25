import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/skeletonView/gridViewSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/feature_exhibitor_child.dart';
import '../controller/exhibitorsController.dart';
import 'bootListBody.dart';
import 'boot_filter_dialog_page.dart';

class BootListPage extends GetView<BootController> {
  static const routeName = "/ExhibitorsListPage";
  bool showAppbar = true;
  BootListPage({Key? key, required this.showAppbar}) : super(key: key);

  final DashboardController dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

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
        title: ToolbarTitle(
            title: controller.isStartup ? "Startups" : "exhibitors".tr),
      ),
      body: Container(
        color: bgColor,
        width: context.width,
        padding: AppDecoration.exhibitorParentPadding(),
        child: GetX<BootController>(
          builder: (controller) {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (controller.hasNextPage) {
                  print(" @@@  load more calling ....");
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      controller.hasNextPage == true &&
                      controller.isFirstLoadRunning.value == false &&
                      controller.isLoadMoreRunning.value == false) {
                    controller.loadMoreExhibitor();
                  }
                }
                return true;
              },
              child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: controller.exhibitorsFeatureList.isNotEmpty
                          ? Container(
                              color: bgColor,
                              child: bootHeaderWidget(),
                            )
                          : const SizedBox(),
                    ),
                  ];
                },
                body: silverBodyWidget(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bootHeaderWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.isFirstLoadRunning.value == false &&
                controller.exhibitorsFeatureList.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 0, right: 17, bottom: 17),
                child: CustomTextView(
                  text: "featured_exhibitors".tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: colorGray,
                ),
              ),
        controller.isFirstLoadRunning.value == false &&
                controller.exhibitorsFeatureList.isEmpty
            ? const SizedBox()
            : FeatureExhibitorChild(),
        const SizedBox(
          height: 17,
        ),
      ],
    );
  }

  Widget silverBodyWidget(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          enabled: controller.isFirstLoadRunning.value,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: controller.exhibitorsFeatureList.isNotEmpty ? 0 : 6,
              ),
              CustomSearchView(
                isShowFilter: controller.isStartup ? false : true,
                isFilterApply: controller.isFilterApply.value,
                hintText: "search_here".tr,
                controller: controller.textController.value,
                press: () async {
                  if ((controller.exhibitorFilterData.value.filters?.isEmpty ??
                          true) &&
                      controller.exhibitorFilterData.value.sort == null) {
                    await controller.getAndResetFilter(isRefresh: true);
                  }
                  controller.clearFilterIfNotApply();
                  var result =
                      await Get.to(() => const ExhibitorFilterDialogPage());
                  if (result != null) {
                    refreshApiData(isRefresh: false);
                  }
                },
                onSubmit: (result) async {
                  if (result.isNotEmpty) {
                    refreshApiData(isRefresh: false);
                  }
                },
                onClear: (result) {
                  controller.refreshTab1Key.currentState?.show();
                },
              ),
              userCountWidget(),
              Expanded(
                  child: RefreshIndicator(
                      color: colorLightGray,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      key: controller.refreshTab1Key,
                      child: buildChildList(context),
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            refreshApiData(isRefresh: true);
                          },
                        );
                      })),
              // when the _loadMore function is running
              controller.isLoadMoreRunning.value
                  ? const LoadMoreLoading()
                  : const SizedBox()
            ],
          ),
        ),
        // when the first load function is running
        _progressEmptyWidget()
      ],
    );
  }

  refreshApiData({required isRefresh}) async {
    controller.bootRequestModel.filters?.text =
        controller.textController.value.text.trim() ?? "";
    controller.bootRequestModel.featured = false;
    controller.getUserCount(isRefresh: false);
    await controller.getExhibitorsList(isRefresh: isRefresh);
    controller.getFeatureExhibitorsList(isRefresh: isRefresh);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.exhibitorsList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: controller.refreshTab1Key)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const BootViewSkeleton()
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.exhibitorsList.length,
                itemBuilder: (context, index) => buildChildMenuBody(
                    controller.exhibitorsList[index], context),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 10,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15)));
  }

  Widget buildChildMenuBody(Exhibitors exhibitors, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!authenticationManager.isLogin()) {
          DialogConstant.showLoginDialog(context, authenticationManager);
          return;
        }
        controller.getExhibitorsDetail(exhibitors.id);
      },
      child: BootListBody(exhibitor: exhibitors, isBookmark: false),
    );
  }

  ///show total user count and ai match button
  Widget userCountWidget() {
    /*Skeletonizer(
      enabled: controller.isNotesLoading.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: CustomTextView(
          text:
          "${"exhibitor_listing".tr} (${controller.totalUserCount.value})",
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: colorGray,
        ),
      ),
    ),*/
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomTextView(
                text: controller.totalUserCount.value.isNotEmpty
                    ? "${"Listings"} (${controller.totalUserCount.value})"
                    : "Listings",
                fontWeight: FontWeight.w600,
                color: colorGray,
                fontSize: 22,
              ),
            ),
            GestureDetector(
                onTap: () {
                  final DashboardController dashboardController = Get.find();
                  dashboardController.selectedAiMatchIndex(1);
                  Get.toNamed(AiMatchDashboardPage.routeName);
                },
                child: SvgPicture.asset(ImageConstant.aiMatchesBtn))

            ///add the feature attendee
          ],
        ),
      ),
    );
  }
}
