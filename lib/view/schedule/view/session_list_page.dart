import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/skeletonView/sessionSkeletonList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/anim_search_widget.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/agendaSkeletonList.dart';
import '../controller/session_controller.dart';
import '../filter/session_filter_dialog.dart';
import 'session_list_body.dart';

class SessionListPage extends GetView<SessionController> {
  double? toolbarHeight = 60;

  SessionListPage({Key? key, this.toolbarHeight}) : super(key: key);

  static const routeName = "/SessionList";
  final SessionController sessionController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 0,
        centerTitle: false,
        title: ToolbarTitle(
          title: "allSession".tr,
        ),
        backgroundColor: appBarColor,
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        elevation: 0,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: silverBodyWidget(context),
    );
  }

  ///used in case of collpesing layout
  profileHeaderWidget(BuildContext context) {
    return _buildDateTab(context);
  }

  silverBodyWidget(BuildContext context) {
    return GetX<SessionController>(
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15.adaptSize),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateTab(context),
                  _buildToolbar(context),
                  Expanded(
                    child: RefreshIndicator(
                      key: controller.refreshIndicatorKey,
                      color: colorLightGray,
                      backgroundColor: colorPrimary,
                      strokeWidth: 1.0,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            //isActiveHappening(false);
                            refreshApiData(isRefresh: true);
                          },
                        );
                      },
                      child: buildListView(context),
                    ),
                  )
                ],
              ),
              _progressEmptyWidget(),
            ],
          ),
        );
      },
    );
  }

  Future<void> refreshApiData({required isRefresh}) async {
    controller.sessionRequestModel.filters?.text =
        controller.textController.text.trim() ?? "";
    controller.sessionRequestModel.filters?.params?.date =
        controller.defaultDate;
    controller.getSessionList(isRefresh: isRefresh);
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const SessionListSkeleton()
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 0,
                );
              },
              itemCount: controller.sessionList.length,
              itemBuilder: (context, index) {
                return SessionListBody(
                  isFromBookmark: false,
                  session: controller.sessionList[index],
                  index: index,
                  size: controller.sessionList.length,
                );
              },
            ),
    );
  }

  Widget _progressEmptyWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoading.value && controller.sessionList.isEmpty
              ? ShowLoadingPage(
                  refreshIndicatorKey: controller.refreshIndicatorKey,
                  message: "no_data_found_description".tr,
                )
              : const SizedBox(),
    );
  }

  Widget _buildDateTab(BuildContext context) {
    if (controller.dateObject.options != null &&
        controller.dateObject.options!.isNotEmpty) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 55.adaptSize),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          controller: controller.tabScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: controller.dateObject.options?.length,
          itemBuilder: (context, index) {
            var optionData = controller.dateObject.options![index];
            return Obx(() => GestureDetector(
                  onTap: () {
                    controller.isActiveHappening(
                        false); // Reset `Happening Now` when changing tabs
                    controller.dateObject.value = optionData.value ?? "";
                    controller.selectedDayIndex(index);
                    controller.defaultDate = optionData.value ?? "";
                    controller.sessionRequestModel.filters?.params?.status = 0;
                    refreshApiData(isRefresh: false);
                    // Scroll to the selected item
                    double itemWidth = 140.h + 12; // Width + margin
                    controller.tabScrollController.animateTo(
                      index * itemWidth,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 140.h,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                        color: index == controller.selectedDayIndex.value
                            ? colorPrimary
                            : white,
                        border: Border.all(color: indicatorColor, width: 0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextView(
                            text: optionData.text.toString() ?? "",
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                            color: index == controller.selectedDayIndex.value
                                ? white
                                : colorSecondary,
                          ),
                          CustomTextView(
                            text: "Day ${index + 1}",
                            fontSize: 14,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.normal,
                            color: index == controller.selectedDayIndex.value
                                ? white
                                : colorSecondary,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
        height: 46,
        margin: EdgeInsets.only(
            top: 26.adaptSize, bottom: 26.adaptSize, right: 0.h),
        child: Stack(
          children: [
            controller.sessionRequestModel.filters?.params?.status != 1 &&
                    controller.sessionList.isEmpty &&
                    controller.isFirstLoading.value == false
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () async {
                          controller.isActiveHappening.value = !controller
                              .isActiveHappening
                              .value; // button `Happening Now`

                          if (controller.isActiveHappening.value) {
                            controller.sessionRequestModel.filters?.params
                                ?.status = 1;
                            refreshApiData(isRefresh: false);
                          } else {
                            controller.sessionRequestModel.filters?.params
                                ?.status = 0;
                            refreshApiData(isRefresh: false);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 8.h, bottom: 8.h, left: 9, right: 13),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: controller.isActiveHappening.value
                                    ? colorLive // Icon color toggle
                                    : hintColor),
                            borderRadius: AppBorderRadius.circular(),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  // border: Border.all(color: grayColorLight),
                                  border: Border.all(
                                    color: hintColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.circle, // Icon toggle
                                  color: controller.isActiveHappening.value
                                      ? colorLive // Icon color toggle
                                      : grayColorLight, // Icon color toggle
                                  size: 14.0,
                                ),
                              ),
                              const SizedBox(width: 6),
                              CustomTextView(
                                text: 'live_session'.tr, fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: colorSecondary, // Text color toggle
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            Stack(
              children: [
                Positioned(
                  right: 41.h,
                  top: 0,
                  bottom: 0,
                  child: AnimSearchBar(
                    rtl: true,
                    //searchIconColor: const Color.fromRGBO(112, 112, 112, 1),
                    helpText: "search_here".tr,
                    style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16),
                    color: colorLightGray,
                    textFieldColor: colorLightGray,
                    textController: controller.textController,
                    closeSearchOnSuffixTap: true,
                    onSuffixTap: () {
                      if (controller.textController.text.trim().isNotEmpty) {
                        refreshApiData(isRefresh: false);
                        controller.textController.clear();
                        refreshApiData(isRefresh: false);
                      }
                    },
                    onSearchTap: () {},
                    onSubmitted: (data) {
                      refreshApiData(isRefresh: false);
                    },
                    // width: context.width * .83,
                    width: context.width - 70.h,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: controller.sessionFilterBody.value.params != null &&
                          controller.sessionFilterBody.value.params!.isNotEmpty
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: InkWell(
                            onTap: () async {
                              controller.clearFilterIfNotApply();
                              var result = await Get.to(
                                  () => const SessionFilterDialogPage());
                              if (result != null) {
                                refreshApiData(isRefresh: false);
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.filterIcon,
                                  width: 20.h,
                                  height: 20.h,
                                ),
                                Positioned(
                                    top: -1,
                                    right: -1,
                                    child: Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: controller.isFilterApply.value
                                          ? colorFilterDot
                                          : Colors.transparent,
                                    ))
                              ],
                            ),
                          ),
                        )
                      : controller.isFirstLoading.value
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            )
                          : const SizedBox(),
                )
              ],
            ),
          ],
        ));
  }
}
