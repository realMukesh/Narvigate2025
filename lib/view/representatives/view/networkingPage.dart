import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:dreamcast/view/representatives/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/az_listview/src/az_listview.dart';
import '../../../widgets/az_listview/src/index_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/profile_header_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../../widgets/userListBody.dart';
import '../../skeletonView/userBodySkeleton.dart';
import 'netowking_filter_dialog_page.dart';

class NetworkingPage extends GetView<NetworkingController> {
  NetworkingPage({super.key});

  final controller = Get.put(NetworkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(left: 7.h, top: 3),
          onTap: () => Get.back(),
        ),
        title: ToolbarTitle(title: "Entertainment"),
      ),
      backgroundColor: bgColor,
      body: silverBodyWidget(context),

      /*NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                    top: 20.adaptSize, left: 14.adaptSize, right: 14.adaptSize),
                color: bgColor,
                child: ProfileHeaderWidget(),
              ),
            ),
          ];
        },
        body: silverBodyWidget(context),
      ),*/
    );
  }

  Widget silverBodyWidget(BuildContext context) {
    return GetX<NetworkingController>(
      builder: (controller) {
        return Container(
          width: context.width,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 18,
              ),
              _buildSearchSection(),
              const SizedBox(height: 18),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
              //   child: userCountWidget(),
              // ),
              // const SizedBox(height: 22),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      color: colorLightGray,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      key: controller.refreshIndicatorKey,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            refreshApiData(isRefresh: false);
                          },
                        );
                      },
                      child: azListViewWidget(context),
                    ),
                    _progressEmptyWidget()
                  ],
                ),
              ),
              // when the _loadMore function is running
              controller.isLoadMoreRunning.value
                  ? const LoadMoreLoading()
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  refreshApiData({required isRefresh}) async {
    controller.networkRequestModel.filters?.text =
        controller.textController.value.text.trim() ?? "";
    await controller.attendeeAPiCall(isRefresh: isRefresh);
  }

  Widget _progressEmptyWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: controller.isLoading.value
          ? const Loading()
          : controller.attendeeList.isEmpty && !controller.isFirstLoading.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  ///this is indexing az listview
  Widget azListViewWidget(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const UserListSkeleton()
          : AzListView(
              padding: EdgeInsets.zero,
              itemScrollController: controller.itemScrollController,
              data: controller.attendeeList,
              itemCount: controller.attendeeList.length,
              itemBuilder: (BuildContext context, int index) {
                var model = controller.attendeeList[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: buildChildMenuBody(model),
                );
              },
              physics: const BouncingScrollPhysics(),
              itemPositionsListener: controller.itemPositionsListener,
              indexBarData: const [...kIndexBarData],
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                ignoreDragCancel: true,
                textStyle: const TextStyle(color: Colors.blue, fontSize: 12),
                downTextStyle:
                    const TextStyle(fontSize: 12, color: Colors.white),
                downItemDecoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
                indexHintWidth: 120 / 2,
                indexHintHeight: 100 / 2,
                indexHintDecoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.ic_index_bar_bubble_gray),
                    fit: BoxFit.contain,
                  ),
                ),
                indexHintAlignment: Alignment.centerRight,
                indexHintChildAlignment: const Alignment(-0.25, 0.0),
                indexHintOffset: const Offset(-20, 0),
              ),
              onIndexTap: (result) {
                int itemIndex = controller.attendeeList.indexWhere((item) =>
                    item.name!
                        .toString()
                        .substring(0, 1)
                        .toUpperCase()
                        .contains(result));

                if (itemIndex > -1) {
                  controller.itemScrollController.scrollTo(
                      index: itemIndex, duration: const Duration(seconds: 1));
                } else {
                  return;
                  //controller.attendeeAPiCall(isRefresh: true);
                }
              },
            ),
    );
  }

  Widget buildChildMenuBody(Representatives representatives) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: UserListWidget(
        representatives: representatives,
        press: () async {
          controller.isLoading(true);
          await controller.userDetailController
              .getUserDetailApi(representatives.id, representatives.role);
          controller.isLoading(false);
        },
        isFromBookmark: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      width: double.maxFinite,
      margin: EdgeInsets.zero,
      child: CustomSearchView(
        isShowFilter: true,
        controller: controller.textController.value,
        hintText: "search_here".tr,
        hintStyle: const TextStyle(fontSize: 16),
        isFilterApply: controller.isFilterApply.value,
        onSubmit: (result) {
          if (result.isNotEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            refreshApiData(isRefresh: false);
          }
        },
        onChanged: (result) {
          if (result.isEmpty) {
            Future.delayed(const Duration(seconds: 1), () {
              refreshApiData(isRefresh: false);
            });
          }
        },
        onClear: (result) {
          controller.refreshIndicatorKey.currentState?.show();
        },
        press: () async {
          if ((controller.userFilterBody.value.filters?.isEmpty ?? true) &&
              controller.userFilterBody.value.sort == null &&
              controller.userFilterBody.value.isBlocked == null) {
            await controller.getAndResetFilter(isRefresh: true);
          }
          controller.clearFilterIfNotApply();
          var result = await Get.to(NetworkingFilterDialog(
            role: controller.role,
          ));
          if (result != null) {
            refreshApiData(isRefresh: false);
          }
        },
      ),
    );
  }

  ///networkHeaderPage
  Widget userCountWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: CustomTextView(
              text: controller.totalUserCount.value.isNotEmpty
                  ? "${"attendee".tr} (${controller.totalUserCount.value})"
                  : "attendee".tr,
              fontWeight: FontWeight.w600,
              color: colorGray,
              fontSize: 22,
            ),
          ),
          // GestureDetector(
          //     onTap: () {
          //       final DashboardController dashboardController = Get.find();
          //       dashboardController.selectedAiMatchIndex(1);
          //       Get.toNamed(AiMatchDashboardPage.routeName);
          //     },
          //     child: SvgPicture.asset(ImageConstant.aiMatchesBtn))

          ///add the feature attendee
        ],
      ),
    );
  }
}
