import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/alert/controller/alert_controller.dart';
import 'package:dreamcast/view/chat/view/chatDashboard.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../meeting/view/meeting_details_page.dart';
import '../../polls/controller/pollsController.dart';
import '../../polls/view/pollsPage.dart';
import '../../skeletonView/ListDocumentSkeleton.dart';

class AlertPersonalPage extends GetView<AlertController> {
  AlertPersonalPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var showPopup = false.obs;
  // Set to keep track of items already displayed
  Set<String> displayedItems = {};

  @override
  Widget build(BuildContext context) {
    return GetX<AlertController>(builder: (controller) {
      return Stack(
        children: [
          RefreshIndicator(
              key: _refreshIndicatorKey,
              child: Skeletonizer(
                enabled: controller.isFirstLoading.value,
                child: controller.isFirstLoading.value
                    ? const ListDocumentSkeleton()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showPopup(!showPopup.value);
                                  },
                                  child: Container(
                                    width: 172.adaptSize,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colorGray, width: 1),
                                      color: showPopup.value
                                          ? bgColor
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/ic_sort.svg",
                                          width: 11,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Obx(() {
                                          return CustomTextView(
                                            text: controller
                                                .titleAllMessage.value,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                                if (controller.personalAlertList.isNotEmpty)
                                  InkWell(
                                    onTap: () async {
                                      controller.updateAllReadStatus(
                                        isPersonal: true,
                                      );
                                    },
                                    child: const CustomTextView(
                                      text: "Mark all as read",
                                      underline: true,
                                      color: Color.fromRGBO(70, 88, 167, 1),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: controller.personalAlertList.length,
                              itemBuilder: (context, index) {
                                return childListItem(index, context, true);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              onRefresh: () async {
                displayedItems.clear();
                controller.initNotificationRef();
              }),
          showPopup.value
              ? Positioned(
                  width: 172.adaptSize,
                  top: 50.adaptSize,
                  left: 10,
                  child: buildAlertPopup(context),
                )
              : const SizedBox(),
          _progressEmptyWidget()
        ],
      );
    });
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : controller.personalAlertList.isEmpty &&
                  !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox.shrink(),
    );
  }

  Widget buildAlertPopup(BuildContext context) {
    return SizedBox(
      width: 132.adaptSize,
      child: Card(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: colorGray, width: 1),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    controller.titleAllMessage.value = "All Messages";
                    showPopup(false);
                    controller.getAllMessages(isPersonal: true);
                  },
                  child: CustomTextView(
                    text: "All Messages",
                    fontWeight: FontWeight.w600,
                    color: controller.titleAllMessage.value == "All Messages"
                        ? colorPrimaryDark
                        : colorGray,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 5.v,
                ),
                InkWell(
                  onTap: () async {
                    controller.titleAllMessage.value = "Unread Messages";
                    showPopup(false);
                    controller.getUnreadMessages(isPersonal: true);
                  },
                  child: CustomTextView(
                    text: "Unread Messages",
                    fontWeight: FontWeight.w600,
                    color: controller.titleAllMessage.value == "Unread Messages"
                        ? colorPrimaryDark
                        : colorGray,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget childListItem(int index, BuildContext context, bool isPersonal) {
    final message = controller.personalAlertList[index];
    try {
      var displayDate = UiHelper.displayDateFormat(
          date: message.datetime ?? "",
          timezone: controller.authManager.getTimezone());
      if (!displayedItems.contains(displayDate)) {
        displayedItems.add(displayDate);
        message.showDate = true;
      }
    } catch (exception) {
      print(exception.toString());
    }
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.showDate == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  child: CustomTextView(
                    text: UiHelper.displayDateFormat2(
                        date: message.datetime ?? "",
                        timezone: controller.authManager.getTimezone()),
                    fontWeight: FontWeight.w600,
                    color: colorGray,
                    fontSize: 22,
                  ),
                )
              : const SizedBox(),
          InkWell(
            onTap: () async {
              onPageClick(context, index, isPersonal);
            },
            child: Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: indicatorColor, width: 0.7),
                  color: message.read == true
                      ? white
                      : black.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: UiHelper.displayCommonDateTime(
                        date: message.datetime ?? "",
                        timezone: controller.authManager.getTimezone(),
                      ),
                      textAlign: TextAlign.end,
                      // Align text to end
                      fontSize: 14,
                      maxLines: 3,
                      fontWeight: FontWeight.normal,
                      color: colorGray,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    CustomTextView(
                      text: message.title ?? "",
                      textAlign: TextAlign.start,
                      fontSize: 18,
                      maxLines: 10,
                      fontWeight: FontWeight.w500,
                      color: colorSecondary,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: message.body ?? "",
                      maxLines: 10,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 24,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () async {
                          onPageClick(context, index, isPersonal);
                        },
                        child: CustomTextView(
                          text: "know_more".tr,
                          color: colorPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14, // Adjust font size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onPageClick(BuildContext context, int index, bool isPersonal) async {
    final message = controller.personalAlertList[index];

    controller.updateReadStatus(
      notificationId: message.key,
      index: index,
      isPersonal: isPersonal,
    );
    if (message.data?.page == "chat") {
      if (message.body.toString().contains("has been accepted")) {
        controller.dashboardController.chatTabIndex(0);
      } else if (message.body.toString().contains("sent")) {
        controller.dashboardController.chatTabIndex(1);
      } else {
        controller.dashboardController.chatTabIndex(2);
      }
      Get.toNamed(ChatDashboardPage.routeName);
    } else if (message.data?.page == "aiprofile") {
      controller.dashboardController.chatTabIndex(0);
      Get.toNamed(ProfileEditPage.routeName, arguments: "is_ai_profile");
    } else if (message.data?.page == "b2b_meeting") {
      if (!Get.isRegistered<MeetingController>()) {
        final meetingController = Get.put(MeetingController());
        controller.loading(true);
        var result = await meetingController.getMeetingDetail(
          requestBody: {"id": message.data!.id},
        );
        controller.loading(false);
        if (result['status']) {
          Get.toNamed(MeetingDetailPage.routeName);
        } else {
          UiHelper.showFailureMsg(
            context,
            result['message'] ?? "meeting_details_not_found".tr,
          );
        }
      } else {
        MeetingController meetingController = Get.find();
        controller.loading(true);
        var result = await meetingController.getMeetingDetail(
          requestBody: {"id": message.data!.id},
        );
        controller.loading(false);

        if (result['status']) {
          Get.toNamed(MeetingDetailPage.routeName);
        } else {
          UiHelper.showFailureMsg(
            context,
            result['message'] ?? "meeting_details_not_found".tr,
          );
        }
      }
    } else if (message.data?.page == "poll") {
      if (Get.isRegistered<PollController>()) {
        Get.delete<PollController>();
      }
      Get.toNamed(PollsPage.routeName);
    }
  }
}
