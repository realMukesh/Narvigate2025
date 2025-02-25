/*
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/schedule/widget/session_status_widget.dart';
import 'package:dreamcast/view/skeletonView/speakerBodySkeleton.dart';
import 'package:dreamcast/widgets/add_calender_widget.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/schedule/view/watch_session_page.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../api_repository/app_url.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/foundational_track_widget.dart';
import '../../../widgets/home_widget/home_banner_widget.dart';
import '../../askQuestion/view/ask_question_page.dart';
import '../../polls/view/pollsPage.dart';
import '../../quiz/view/feedback_page.dart';
import '../../speakers/view/speakerListBody.dart';
import '../model/scheduleModel.dart';

class SessionDetailPage extends GetView<SessionController> {
  SessionsData sessions;
  SessionDetailPage({super.key, required this.sessions});
  static const routeName = "/SessionDetailPage";
  final AuthenticationManager _authenticationManager = Get.find();
  List<Color> trackColor = [
    const Color(0xffCF138A),
    const Color(0xffEA4E1B),
    const Color(0xff1B81C3),
    const Color(0xff1D2542),
    const Color(0xffCF138A),
    const Color(0xffEA4E1B),
  ];
  @override
  Widget build(BuildContext context) {
    ///used for header title*//*

    return Scaffold(
      backgroundColor: colorLightGray,
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
        title: ToolbarTitle(title: "session_detail".tr),
        backgroundColor: appBarColor,
        // dividerHeight: 1,
        actions: [
          GestureDetector(
            onTap: () {
              controller.shareTheSession();
            },
            child: SvgPicture.asset(
              ImageConstant.share_icon,
              width: 18,
              color: colorSecondary,
            ),
          ),
          const SizedBox(width: 20),
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    controller.mSessionDetailBody.value.isLoading(true);
                    await controller.bookmarkToSession(
                        id: controller.mSessionDetailBody.value.id);
                    controller.mSessionDetailBody.value.isLoading(false);
                    controller.update();
                  },
                  child: SvgPicture.asset(
                    controller.sessionDetailBody.bookmark != null &&
                            controller.sessionDetailBody.bookmark!.isNotEmpty
                        ? ImageConstant.bookmarkIcon
                        : ImageConstant.unBookmarkIcon,
                    width: 16,
                  ),
                ),
                controller.mSessionDetailBody.value.isLoading.value
                    ? const FavLoading()
                    : const SizedBox()
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: Container(
          width: context.width,
          color: bgColor,
          padding: const EdgeInsets.all(16),
          child: GetX<SessionController>(
            builder: (controller) {
              var statusColor = UiHelper.getColorByHexCode(
                  controller.mSessionDetailBody.value.status?.color ?? "");
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SessionStatusWidget(
                                  statusColor: statusColor,
                                  title: controller.mSessionDetailBody.value
                                          .status?.text ??
                                      ""),
                              headerWidget(),
                              descriptionView(),
                              bodyMenuView(context),
                              SessionBannerWidget(),
                              SizedBox(height: 100.v),
                              //buildRate(),
                              SizedBox(height: 20.v),
                              */
/*
                            SizedBox(height: 10.v),
                            buildSpeakerListview(context),*//*

                              ///temp is comment as per brief
                              // SizedBox(height: 10.v),
                              // _buildRate(),
                              // SizedBox(height: 20.v),
                              // _buildShare(),
                              ///temp is comment as per brief
                            ],
                          ),
                        ),
                      ),
                      controller.mSessionDetailBody.value.isOnlineStream == 1
                          ? CustomIconButton(
                              height: 50,
                              width: context.width,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomTextView(
                                      text: "watch_live".tr,
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.play_arrow,
                                      color: white,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                openScheduleDetail();
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                  controller.loading.value ? const Loading() : const SizedBox()
                ],
              );
            },
          )),
    );
  }

  openScheduleDetail() async {
    Get.to(() => WatchDetailPage(
          sessions: controller.sessionDetailBody,
        ));
  }

  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextView(
                  text: UiHelper.displayCommonDateTime(
                      date: controller.mSessionDetailBody.value.startDatetime
                          .toString(),
                      timezone: controller.authManager.getTimezone()),
                  // color: textGrayColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                AddCalenderWidget(
                  onTap: () {
                    Add2Calendar.addEvent2Cal(
                      controller.buildEventDetail(
                          sessions: controller.mSessionDetailBody.value),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  ImageConstant.ic_location_icon,
                  height: 17,
                ),
                const SizedBox(
                  width: 6,
                ),
                CustomTextView(
                  text: controller.mSessionDetailBody.value.auditorium?.text ??
                      "",
                  color: colorGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (controller.mSessionDetailBody.value.keywords.isNotEmpty)
          SizedBox(
            height: 29.v,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.mSessionDetailBody.value.keywords?.length,
              itemBuilder: (context, index) {
                var keywords =
                    controller.mSessionDetailBody.value.keywords![index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FoundationalTrackWidget(
                    color: trackColor[index % 6],
                    title: keywords.toString().capitalize,
                  ),
                );
              },
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        CustomTextView(
          text: controller.mSessionDetailBody.value.label ?? "",
          color: colorSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        SizedBox(
          height: 8.v,
        ),
      ],
    );
  }

  Widget descriptionView() {
    return CustomReadMoreText(
      text: controller.mSessionDetailBody.value.description ?? "",
      textAlign: TextAlign.start,
      fontSize: 14,
      color: colorSecondary,
      fontWeight: FontWeight.normal,
    );
  }

  Widget bodyMenuView(BuildContext context) {
    List<String> controlList =
        controller.sessionDetailBody.auditorium?.controls ?? [];

    return controlList.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 38),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.menuParentItemList.length,
                itemBuilder: (context, index) {
                  var data = controller.menuParentItemList[index];
                  return controlList.contains(data.id?.toLowerCase())
                      ? InkWell(
                          onTap: () async {
                            switch (index) {
                              case 0:
                                Get.toNamed(PollsPage.routeName, arguments: {
                                  "item_type": "webinar",
                                  "item_id":
                                      controller.mSessionDetailBody.value.id ??
                                          ""
                                });
                                break;
                              case 1:
                                Get.toNamed(AskQuestionPage.routeName,
                                    arguments: {
                                      "name": controller
                                              .mSessionDetailBody.value.label ??
                                          "",
                                      "image": controller.mSessionDetailBody
                                              .value.thumbnail ??
                                          "",
                                      "item_id": controller
                                              .mSessionDetailBody.value.id ??
                                          "",
                                      "item_type": "webinar",
                                    });
                                break;
                              case 3:
                                Get.toNamed(FeedbackPage.routeName, arguments: {
                                  "item_id":
                                      controller.mSessionDetailBody.value.id,
                                  "title": "Session Feedback",
                                  "type": "webinar"
                                });
                                break;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: white,
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(color: grayColorLight, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  controller
                                          .menuParentItemList[index].iconUrl ??
                                      "",
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                CustomTextView(
                                  text: controller
                                          .menuParentItemList[index].title ??
                                      "",
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
          )
        : const SizedBox();
  }

  Widget buildSpeakerListview(BuildContext context) {
    return controller.mSessionDetailBody.value.speakers != null &&
            controller.mSessionDetailBody.value.speakers!.isNotEmpty
        ? ListTile(
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CustomTextView(
                text: "speakers".tr,
                textAlign: TextAlign.start,
                color: grayColorLight,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            subtitle: Skeletonizer(
              enabled: controller.isFirstLoading.value,
              child: controller.isFirstLoading.value
                  ? const SpeakerListSkeleton()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller
                              .mSessionDetailBody.value.speakers?.length ??
                          0,
                      itemBuilder: (context, index) => buildListBody(
                          controller.mSessionDetailBody.value.speakers?[index]),
                    ),
            ),
          )
        : const SizedBox();
  }

  Widget buildListBody(dynamic representatives) {
    return InkWell(
      onTap: () async {
        controller.loading(true);
        final SpeakersController _speakerController = Get.find();
        await _speakerController.getSpeakerDetail(
            speakerId: representatives.id,
            role: representatives.role,
            isSessionSpeaker: true);
        controller.loading(false);
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SpeakerViewWidget(
          speakerData: representatives,
          isSpeakerType: true,
          isBookmark: false,
        ),
      ),
    );
  }

  Widget buildShare() {
    return InkWell(
      onTap: () {
        Share.share(
            "${controller.mSessionDetailBody.value.label}\n\n ${controller.mSessionDetailBody.value.description ?? ""}\n\n ${controller.mSessionDetailBody.value.embed ?? ""}");
      },
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: const BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: CustomTextView(
                text: "share_this_on".tr,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: colorGray,
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(ImageConstant.fbIcon),
                  const SizedBox(width: 10),
                  SvgPicture.asset(ImageConstant.twitterIcon),
                  const SizedBox(width: 10),
                  SvgPicture.asset(ImageConstant.linkedIcon)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRate() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: CustomTextView(
              text: "rate_this_session".tr,
              color: colorGray,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    onTap: () {
                      if (!controller.clapReaction.value) {
                        controller.clapReaction(!controller.clapReaction.value);
                        var requestBody = {
                          "auditorium_id": controller
                                  .mSessionDetailBody.value.auditorium?.value ??
                              "",
                          "auditorium_session_id":
                              controller.mSessionDetailBody.value.id ?? "",
                          "type": controller.clapReaction.value ? "clap" : "",
                        };
                        controller.sendEmoticonsRequest(
                            requestBody: requestBody);
                      } else {
                        controller.clapReaction(!controller.clapReaction.value);
                        var requestBody = {
                          "auditorium_id": controller
                                  .mSessionDetailBody.value.auditorium?.value ??
                              "",
                          "auditorium_session_id":
                              controller.mSessionDetailBody.value.id ?? "",
                          "type": controller.clapReaction.value ? "clap" : "",
                        };
                        controller.sendEmoticonsRequest(
                            requestBody: requestBody);
                      }
                    },
                    child: SvgPicture.asset(controller.clapReaction.value
                        ? ImageConstant.activeEmoji1
                        : ImageConstant.inactiveEmoji1),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    onTap: () {
                      if (!controller.hootReaction.value) {
                        controller.hootReaction(!controller.hootReaction.value);
                        var requestBody = {
                          "auditorium_id": controller
                                  .mSessionDetailBody.value.auditorium?.value ??
                              "",
                          "auditorium_session_id":
                              controller.mSessionDetailBody.value.id ?? "",
                          "type": controller.hootReaction.value ? "hoot" : "",
                        };
                        controller.sendEmoticonsRequest(
                            requestBody: requestBody);
                      }
                    },
                    child: SvgPicture.asset(controller.hootReaction.value
                        ? ImageConstant.activeEmoji2
                        : ImageConstant.inactiveEmoji2),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    onTap: () {
                      if (!controller.likeReaction.value) {
                        controller.likeReaction(!controller.likeReaction.value);
                        var requestBody = {
                          "auditorium_id": controller
                                  .mSessionDetailBody.value.auditorium?.value ??
                              "",
                          "auditorium_session_id":
                              controller.mSessionDetailBody.value.id ?? "",
                          "type": controller.likeReaction.value ? "like" : "",
                        };
                        controller.sendEmoticonsRequest(
                            requestBody: requestBody);
                      }
                    },
                    child: SvgPicture.asset(controller.likeReaction.value
                        ? ImageConstant.activeEmoji3
                        : ImageConstant.inactiveEmoji3),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildRateChild(int index) {
    return CustomIconButton(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(color: Colors.transparent),
      onTap: () {
        if (!controller.clapReaction.value) {
          controller.clapReaction(!controller.clapReaction.value);
          var requestBody = {
            "auditorium_id":
                controller.mSessionDetailBody.value.auditorium?.value ?? "",
            "auditorium_session_id":
                controller.mSessionDetailBody.value.id ?? "",
            "type": controller.clapReaction.value ? "clap" : "",
          };
          controller.sendEmoticonsRequest(requestBody: requestBody);
        }
      },
      child: SvgPicture.asset(controller.clapReaction.value
          ? ImageConstant.activeEmoji1
          : ImageConstant.inactiveEmoji1),
    );
  }
}
*/
