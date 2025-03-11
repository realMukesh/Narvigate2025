import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/schedule/view/watch_session_page.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/view/startNetworking/view/pitchStage/pitchStage_controller.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/dash_widget.dart';
import '../../../widgets/foundational_track_widget.dart';
import '../../../widgets/loading.dart';
import '../model/scheduleModel.dart';
import '../widget/session_status_widget.dart';

class SessionListBody extends GetView<SessionController> {
  SessionsData session;
  bool isFromBookmark = false;
  bool? isFromGlobalSearch;
  int index;
  int size;

  SessionListBody(
      {super.key,
      required this.session,
      required this.isFromBookmark,
      this.isFromGlobalSearch,
      required this.index,
      required this.size});

  var isViewExpend = false.obs;

  @override
  Widget build(BuildContext context) {
    final startDate = session.startDatetime.toString();
    final endDate = session.endDatetime.toString();
    final timezone = controller.authManager.getTimezone();
    return SizedBox(
      width: context.width,
      child: GestureDetector(
        onTap: () => watchSessionPage(false),
        child: Container(
          padding: EdgeInsets.all(14.v),
          margin: EdgeInsets.only(bottom: 16.v),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: UiHelper.getColorByHexCode(session.status?.color ?? ""),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  session.keywords != null
                      ? buildTracksListview(context)
                      : const SizedBox(),
                  Row(
                    children: [
                      SessionStatusWidget(
                          statusColor: UiHelper.getColorByHexCode(
                              session.status?.color ?? ""),
                          title: session.status?.text ?? ""),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Stack(
                          alignment: Alignment.center,
                          children: [
                            if (!(isFromGlobalSearch ?? false))
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  session.isLoading(true);
                                  await controller.bookmarkToSession(
                                    id: session.id,
                                  );
                                  session.isLoading(false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5.0),
                                  child: SvgPicture.asset(
                                    height: 18.adaptSize,
                                    width: 14.adaptSize,
                                    isFromBookmark
                                        ? ImageConstant.bookmarkIcon
                                        : controller.bookMarkIdsList
                                                .contains(session.id)
                                            ? ImageConstant.bookmarkIcon
                                            : ImageConstant.unBookmarkIcon,
                                  ),
                                ),
                              ),
                            session.isLoading.value
                                ? const FavLoading()
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextView(
                text: UiHelper.displayDatetimeSuffix(
                    startDate: startDate, endDate: endDate, timezone: timezone),
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorGray,
              ),
              SizedBox(
                height: 8.v,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextView(
                      text: session.label ?? "",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    ImageConstant.ic_arrow,
                    height: 14.h,
                    width: 8.v,
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 0.5,
                color: dividerColor,
              ),
              if (session.auditorium?.text != null &&
                  session.auditorium!.text!.isNotEmpty)
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.icLocationSession,
                      height: 20.h,
                      width: 16.v,
                    ),
                    SizedBox(
                      width: 14.v,
                    ),
                    Flexible(
                      child: CustomTextView(
                        maxLines: 2,
                        color: colorGray,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.start,
                        text: session.auditorium!.text ?? "",
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 5,
              ),
              buildSpeakerListview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget circularImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorGray, width: 1),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: grayColorLight),
          ),
          child: Center(
            child: CustomTextView(
              text: shortName ?? "",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget circularDottedImage(
      {url, shortName, required double size, required double fontSize}) {
    return SizedBox(
      height: size.adaptSize,
      width: size.adaptSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(ImageConstant.circular_dot_img),
          CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }

  Widget buildSpeakerListview(BuildContext context) {
    var length = session.speakers!.length > 3 ? 3 : session.speakers!.length;
    bool hasSpeakers = length > 0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The speaker list or empty container based on presence of speakers
          hasSpeakers
              ? Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 34.adaptSize),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (var i = 0; i < length; i++)
                            Positioned(
                              left: (i * (1 - .4) * 34).toDouble(),
                              child: i != 2
                                  ? GestureDetector(
                                      onTap: () async {
                                        if (Get.isRegistered<
                                            SpeakersDetailController>()) {
                                          SpeakersDetailController
                                              speakerController = Get.find();
                                          controller.loading(true);
                                          await speakerController
                                              .getSpeakerDetail(
                                            speakerId: session.speakers![i].id,
                                            role: MyConstant.speakers,
                                            isSessionSpeaker: true,
                                          );
                                          controller.loading(false);
                                        }
                                      },
                                      child: CustomImageWidget(
                                        imageUrl:
                                            session.speakers![i].avatar ?? "",
                                        shortName:
                                            session.speakers![i].shortName ??
                                                "",
                                        size: 34.adaptSize,
                                        borderWidth: 0,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        watchSessionPage(false);
                                      },
                                      child: Container(
                                        child: circularDottedImage(
                                          url: "",
                                          shortName:
                                              "+${session.speakers!.length - 2}",
                                          size: 34.adaptSize,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : SvgPicture.asset(
                  ImageConstant.noSpeakerIcon,
                  height: 34.adaptSize,
                  width: 34.adaptSize,
                ),
          // Optionally, you can add more widgets here
          arrowWidget(context),
        ],
      ),
    );
  }

  Widget buildTracksListview(BuildContext context) {
    return session.keywords is List && session.keywords!.isNotEmpty
        ? Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 15.0,
                ),
                child: FoundationalTrackWidget(
                  title: session.keywords![0].toString().capitalize,
                  color: const Color(0xffCF138A),
                ),
              ),
              session.keywords!.length == 1
                  ? const SizedBox()
                  : Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(left: 0.h),
                        child: circularDottedImage(
                          url: "",
                          shortName: "+${session.keywords!.length - 1}",
                          size: 30.adaptSize,
                          fontSize: 12,
                        ),
                      ),
                    ),
            ],
          )
        : const SizedBox();
  }

  Widget arrowWidget(BuildContext context) {
    return Row(
      children: [
        session.isOnlineStream != null && session.isOnlineStream == 1
            ? GestureDetector(
                onTap: () => watchSessionPage(true),
                child: Container(
                  height: 34.adaptSize,
                  // width: 34.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.adaptSize,
                    vertical: 6.adaptSize,
                  ),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius:
                        BorderRadius.all(Radius.circular(5.adaptSize)),
                  ),
                  // child: SvgPicture.asset("assets/svg/ic_play_icon.svg"),
                  child: Center(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.ic_play_icon,
                          height: 20.adaptSize,
                          width: 19.adaptSize,
                        ),
                        const SizedBox(width: 6),
                        const CustomTextView(
                          text: "Watch",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        SizedBox(
          width: session.isOnlineStream != null && session.isOnlineStream == 1
              ? 8
              : 0,
        ),
        // add to calender
        session.status?.value == 0
            ? GestureDetector(
                onTap: () {
                  Add2Calendar.addEvent2Cal(
                    controller.buildEvent(sessions: session),
                  );
                },
                child: Container(
                  height: 34.adaptSize,
                  // width: 34.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.adaptSize,
                    vertical: 6.adaptSize,
                  ),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius:
                        BorderRadius.all(Radius.circular(5.adaptSize)),
                  ),
                  // child: SvgPicture.asset("assets/svg/ic_add_event.svg"),
                  child: Center(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.ic_add_event,
                          height: 20.adaptSize,
                          width: 19.adaptSize,
                        ),
                        const SizedBox(width: 5),
                        const CustomTextView(
                          text: "Add",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),

        // book seat for session
        if (session.isTicketBooking ?? false)
          session.bookingMeeting?.userStatus ?? false
              ? Container(
                  height: 34.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.adaptSize,
                    vertical: 6.adaptSize,
                  ),
                  margin: EdgeInsets.only(
                    left: 12.v,
                  ),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.adaptSize)),
                      border: Border.all(
                        color: colorPrimary,
                      )),
                  // child: SvgPicture.asset("assets/svg/ic_play_icon.svg"),
                  child: Center(
                    child: CustomTextView(
                      text: session.bookingMeeting?.seatBooked ?? "Booked",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorPrimary,
                    ),
                  ),
                )
              : (session.bookingMeeting?.slotsAvailable ?? false)
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogWidget(
                              title: "Confirmation",
                              logo: '',
                              description: session
                                      .bookingMeeting?.confirmationMessage ??
                                  "Are you sure you want to book this seat?",
                              buttonAction: "Yes",
                              buttonCancel: "No",
                              onCancelTap: () {},
                              onActionTap: () async {
                                controller.seatBooking(
                                  bookingMeeting: session.bookingMeeting ??
                                      BookingMeeting(),
                                  requestBody: {
                                    "webinar_id": session.id,
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 34.adaptSize,
                        // width: 34.adaptSize,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.adaptSize,
                          vertical: 6.adaptSize,
                        ),
                        margin: EdgeInsets.only(
                          left: 12.v,
                        ),
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.adaptSize)),
                        ),
                        // child: SvgPicture.asset("assets/svg/ic_play_icon.svg"),
                        child: Center(
                          child: CustomTextView(
                            text: session.bookingMeeting?.bookASeat ??
                                "Book A Seat",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 34.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.adaptSize,
                        vertical: 6.adaptSize,
                      ),
                      margin: EdgeInsets.only(
                        left: 12.v,
                      ),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.adaptSize)),
                          border: Border.all(
                            color: colorPrimary,
                          )),
                      // child: SvgPicture.asset("assets/svg/ic_play_icon.svg"),
                      child: Center(
                        child: CustomTextView(
                          text: session.bookingMeeting?.slotsMessage ??
                              "Not Available",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorPrimary,
                        ),
                      ),
                    ),
      ],
    );
  }

  watchSessionPage(bool streaming) async {
    var result =
        await controller.getSessionDetail(requestBody: {"id": session.id});
    controller.isStreaming(streaming);
    if (result["status"]) {
      controller.sessionDetailBody.speakers = session.speakers;
      if (controller.bookMarkIdsList
          .contains(controller.sessionDetailBody.id)) {
        controller.sessionDetailBody.bookmark = controller.sessionDetailBody.id;
      }
      if (Get.isRegistered<SpeakersDetailController>()) {
        print("hell000000");
        SpeakersDetailController speakerController = Get.find();
        if (controller.sessionDetailBody.speakers != null &&
            controller.sessionDetailBody.speakers!.isNotEmpty) {
          speakerController.userIdsList = controller.sessionDetailBody.speakers!
              .map((obj) => obj.id)
              .toList();
          await speakerController.getBookmarkAndRecommendedByIds();
        }
      } else {
        print("hell000");
        final speakerController = Get.put(SpeakersDetailController());
        if (controller.sessionDetailBody.speakers != null &&
            controller.sessionDetailBody.speakers!.isNotEmpty) {
          speakerController.userIdsList = controller.sessionDetailBody.speakers!
              .map((obj) => obj.id)
              .toList();
          await speakerController.getBookmarkAndRecommendedByIds();
        }
      }
      Get.to(() => WatchDetailPage(
            sessions: controller.sessionDetailBody,
          ));
    }
  }
}

///used for pitch stage list
class PitchStageBody extends GetView<PitchStageController> {
  dynamic session;
  bool isFromBookmark = false;
  int index;
  int size;

  PitchStageBody(
      {super.key,
      required this.session,
      required this.isFromBookmark,
      required this.index,
      required this.size});

  var isViewExpend = false.obs;
  var statusColor = [yellow, red, red, red];

  @override
  Widget build(BuildContext context) {
    if (session?.status?.value == -1) {
      session?.status?.value = 3;
    }
    return SizedBox(
      width: context.width,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  index != 0
                      ? DashWidget(
                          length: 60.v,
                          dashLength: 3,
                          dashColor: colorGray,
                          direction: Axis.vertical,
                        )
                      : SizedBox(
                          height: 60.v,
                        ),
                  CustomTextView(
                    text: UiHelper.displayDateFormat(
                        date: session.startDatetime.toString(),
                        timezone: controller.authManager.getTimezone()),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.h,
                    color: colorSecondary,
                  ),
                  CustomTextView(
                    text: UiHelper.displayTimeFormat(
                        date: session.startDatetime.toString(),
                        timezone: controller.authManager.getTimezone()),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.h,
                    color: colorGray,
                  ),
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: indicatorColor,
                  ),
                  index != size - 1
                      ? DashWidget(
                          dashLength: 3,
                          length: 60.v,
                          dashColor: colorGray,
                          direction: Axis.vertical,
                        )
                      : SizedBox(
                          height: 60.v,
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 6.v,
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: EdgeInsets.all(14.v),
              margin: EdgeInsets.only(bottom: 16.v),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: statusColor[session?.status?.value ?? 0],
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      session?.keywords != null
                          ? buildTracksListview(context)
                          : const SizedBox(),
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  color:
                                      statusColor[session.status?.value ?? 0],
                                  size: 10),
                              const SizedBox(
                                width: 6,
                              ),
                              CustomTextView(
                                text: session.status?.text ?? "",
                                color: statusColor[session.status?.value ?? 0],
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          isFromBookmark
                              ? const SizedBox()
                              : const SizedBox(
                                  width: 12,
                                ),
                          isFromBookmark
                              ? const SizedBox()
                              : Obx(() => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          session.isLoading(true);
                                          await controller.bookmarkToSession(
                                              requestBody: {
                                                "item_id": session.id,
                                                "item_type": "webinar"
                                              });
                                          session.isLoading(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: SvgPicture.asset(
                                            height: 18.adaptSize,
                                            width: 14.adaptSize,
                                            controller.bookMarkIdsList
                                                    .contains(session.id)
                                                ? ImageConstant.bookmarkIcon
                                                : ImageConstant.unBookmarkIcon,
                                          ),
                                        ),
                                      ),
                                      session.isLoading.value
                                          ? const FavLoading()
                                          : const SizedBox()
                                    ],
                                  )),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12.v,
                  ),
                  CustomTextView(
                      text: session?.label ?? "",
                      textAlign: TextAlign.start,
                      color: colorSecondary,
                      maxLines: 1,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  SizedBox(
                    height: 6.v,
                  ),
                  if (session?.auditorium != null &&
                      session?.auditorium?.text.isNotEmpty)
                    CustomTextView(
                      maxLines: 2,
                      color: colorGray,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      text: session?.auditorium.text ?? "",
                    ),
                  buildSpeakerListview(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget circularImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorGray, width: 1),
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: grayColorLight)),
          child: Center(
              child: CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }

  Widget circularDottedImage({url, shortName, size}) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(ImageConstant.circular_dot_img),
          CustomTextView(
            text: shortName ?? "",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget buildSpeakerListview(BuildContext context) {
    var length = session.speakers!.length > 3 ? 3 : session.speakers!.length;
    bool hasSpeakers = length > 0;

    return Container(
      margin: hasSpeakers ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: hasSpeakers
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          // Conditionally place the arrow widget at the start or end based on the presence of speakers
          if (!hasSpeakers) SvgPicture.asset(ImageConstant.noSpeakerIcon),

          // The speaker list or empty container based on presence of speakers
          if (hasSpeakers)
            Expanded(
              child: Container(
                color: Colors.transparent,
                height: 50.v,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 0; i < length; i++)
                        Positioned(
                          left: (i * (1 - .4) * 34).toDouble(),
                          child: i != 2
                              ? GestureDetector(
                                  onTap: () async {
                                    if (Get.isRegistered<
                                        SpeakersDetailController>()) {
                                      SpeakersDetailController
                                          speakerController = Get.find();
                                      controller.loading(true);
                                      await speakerController.getSpeakerDetail(
                                          speakerId: session.speakers![i].id,
                                          role: MyConstant.speakers,
                                          isSessionSpeaker: true);
                                      controller.loading(false);
                                    }
                                  },
                                  child: circularImage(
                                      url: session.speakers![i].avatar ?? "",
                                      shortName:
                                          session.speakers![i].shortName ?? "",
                                      size: 34.adaptSize),
                                )
                              : InkWell(
                                  onTap: () {
                                    controller.openSessionDetail(
                                        sessionId: session.id);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 0.h),
                                    child: circularDottedImage(
                                        url: "",
                                        shortName:
                                            "+${session.speakers!.length - 2}",
                                        size: 32.adaptSize),
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // Optionally, you can add more widgets here
          if (hasSpeakers) arrowWidget(),
        ],
      ),
    );
  }

  Widget buildTracksListview(BuildContext context) {
    return session.keywords is List && session.keywords!.isNotEmpty
        ? Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 10.0,
                ),
                child: FoundationalTrackWidget(
                  title: session.keywords![0].toString().capitalize,
                  color: const Color(0xffCF138A),
                ),
              ),
              session.keywords!.length == 1
                  ? const SizedBox()
                  : Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(left: 10.h),
                          child: circularDottedImage(
                              url: "",
                              shortName: "+${session.keywords!.length - 1}",
                              size: 21.adaptSize),
                        ),
                      ),
                    ),
            ],
          )
        : const SizedBox();
  }

  Widget arrowWidget() {
    return Row(
      children: [
        session.isOnlineStream != null && session.isOnlineStream == 1
            ? GestureDetector(
                onTap: () => controller.watchSessionPage(sessionId: session.id),
                child: Container(
                  height: 34.adaptSize,
                  width: 34.adaptSize,
                  padding: EdgeInsets.all(6.adaptSize),
                  decoration: BoxDecoration(
                      color: colorLightGray,
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.adaptSize))),
                  // child: SvgPicture.asset("assets/svg/ic_play_icon.svg"),
                  child: Center(
                    child: SvgPicture.asset(
                      ImageConstant.ic_play_icon,
                      height: 22.adaptSize,
                      width: 22.adaptSize,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () {
            Add2Calendar.addEvent2Cal(
              controller.buildEvent(sessions: session),
            );
          },
          child: Container(
            height: 34.adaptSize,
            width: 34.adaptSize,
            padding: EdgeInsets.all(6.adaptSize),
            decoration: BoxDecoration(
                color: colorLightGray,
                borderRadius: BorderRadius.all(Radius.circular(5.adaptSize))),
            // child: SvgPicture.asset("assets/svg/ic_add_event.svg"),
            child: Center(
              child: SvgPicture.asset(
                ImageConstant.ic_add_event,
                height: 22.adaptSize,
                width: 22.adaptSize,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () {
            controller.openSessionDetail(sessionId: session.id);
          },
          child: Container(
            height: 34.adaptSize,
            width: 34.adaptSize,
            padding: EdgeInsets.all(6.adaptSize),
            decoration: BoxDecoration(
              color: colorLightGray,
              borderRadius: BorderRadius.all(Radius.circular(5.adaptSize)),
            ),
            // child: SvgPicture.asset("assets/svg/ic_arrow.svg"),
            child: Center(
              child: SvgPicture.asset(
                ImageConstant.ic_arrow,
                height: 16.adaptSize,
                width: 16.adaptSize,
              ),
            ),
          ),
        )
      ],
    );
  }
}
