import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_speaker_controller.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/view/speakers/model/speakersModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/recommended_widget.dart';
import '../../../widgets/customImageWidget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/loading.dart';

class SpeakerViewWidget extends StatelessWidget {
  dynamic speakerData;
  bool isSpeakerType = false;
  bool? isBookmark = false;
  SpeakerViewWidget(
      {super.key,
      required this.speakerData,
      required this.isSpeakerType,
      this.isBookmark});

  final SpeakersDetailController controller = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {

    return Container(
      width: context.width,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomImageWidget(
                        imageUrl: speakerData.avatar ?? "",
                        shortName: speakerData.shortName ?? "",
                        size: 70.adaptSize,
                        borderWidth: 0,
                      ),
                      SizedBox(width: 20.h),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: speakerData.name?.toString().trim() ?? "",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                                color: colorSecondary,
                              ),
                              SizedBox(height: 4.v),
                              speakerData.position.toString().isEmpty
                                  ? const SizedBox()
                                  : CustomTextView(
                                      text: speakerData.position ?? "",
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: colorGray,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.start,
                                    ),
                              if((speakerData.company ?? "").isNotEmpty)
                                CustomTextView(
                                      text: speakerData.company ?? "",
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: colorGray,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                              if((speakerData.association ?? "").isNotEmpty)
                                CustomTextView(
                                      text: speakerData.association ?? "",
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: colorGray,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                              speakerData.isNotes == "1"
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SvgPicture.asset(
                                          ImageConstant.notesIcon),
                                    )
                                  : const SizedBox(),
                              isSpeakerType &&
                                      speakerData.type != null &&
                                      speakerData.type != ""
                                  ? SpeakerTypeWidget(
                                      type: speakerData.type.toString(),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.h),
                      Align(
                          alignment: Alignment.topRight,
                          child: Obx(
                            () => Container(
                              color: Colors.transparent,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (!authenticationManager.isLogin()) {
                                        DialogConstant.showLoginDialog(
                                            context, authenticationManager);
                                        return;
                                      }
                                      speakerData.isLoading(true);
                                      await controller.bookmarkToUser(
                                        speakerData.id,
                                        speakerData.role ?? MyConstant.speakers,
                                      );
                                      speakerData.isLoading(false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: SvgPicture.asset(
                                        isBookmark == true
                                            ? ImageConstant.bookmarkIcon
                                            : controller.bookMarkIdsList
                                                    .contains(speakerData.id)
                                                ? ImageConstant.bookmarkIcon
                                                : ImageConstant.unBookmarkIcon,
                                        width: 14,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                  speakerData.isLoading.value
                                      ? const FavLoading()
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Divider(
                    color: indicatorColor,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(width: 12.h),
        ],
      ),
    );
  }
}

