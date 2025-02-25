import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/my_constant.dart';
import '../../theme/app_colors.dart';
import '../../view/meeting/model/meeting_model.dart';
import '../customImageWidget.dart';
import '../customTextView.dart';
import '../button/rounded_button.dart';

class MarkMeetingDialog extends StatelessWidget {
  final String title, buttonCancel, buttonAction;
  final Meetings meeting;
  final VoidCallback? onCancelTap, onActionTap;

  final MeetingController controller = Get.find();

  MarkMeetingDialog(
      {super.key,
      required this.title,
      required this.meeting,
      required this.buttonCancel,
      required this.buttonAction,
      this.onCancelTap,
      this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 15),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: const Color(0xffDCE2E6)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: grayColorLight,
                            ),
                          )),
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CustomTextView(
                          text: "Mark Meeting Status",
                          textAlign: TextAlign.center,
                          fontSize: 22.0,
                          color: colorSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16.0),
                      const CustomTextView(
                        text: "Meeting with :",
                        color: colorGray,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.start,
                      ),
                      ListTile(
                        minTileHeight: 0.0,
                        contentPadding: EdgeInsets.zero,
                        leading: CustomImageWidget(
                            imageUrl: meeting.user?.avatar ?? "",
                            shortName: meeting.user?.shortName,size: 40,fontSize: 12,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextView(
                              text: meeting.user?.name ?? "",
                              textAlign: TextAlign.start,
                              color: colorSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text:
                                  "${meeting.user?.position ?? ""} ${meeting.user?.company ?? ""}",
                              textAlign: TextAlign.start,
                              color: colorGray,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedIndex(1);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: colorLightGray,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          controller.selectedIndex.value == 1
                                              ? ImageConstant.icRadioActive
                                              : ImageConstant.icRadioInactive,
                                          height: 15.adaptSize,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const CustomTextView(
                                          text: "Attended",
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedIndex(-1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorLightGray,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        controller.selectedIndex.value == -1
                                            ? ImageConstant.icRadioActive
                                            : ImageConstant.icRadioInactive,
                                        height: 15.adaptSize,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const CustomTextView(
                                        text: "Not Attended",
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          style: GoogleFonts.getFont(
                              MyConstant.currentFont,
                              fontSize: 18.fSize,
                              color: colorSecondary,
                              fontWeight: FontWeight.normal),
                          textInputAction: TextInputAction.done,
                          controller: controller.textAreaController,
                          validator: (String? value) {
                            if (value != null && value.trim().isEmpty) {
                              return "Please enter description";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            hintText: "Type here",
                            fillColor: Colors.transparent,
                            filled: true,
                            hintStyle: GoogleFonts.getFont(
                                MyConstant.currentFont,
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            labelStyle: GoogleFonts.getFont(
                                MyConstant.currentFont,
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 60),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: borderEditColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: borderEditColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: borderEditColor),
                            ),
                          ),
                          minLines: 6,
                          maxLines: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonMaterialButton(
                        color: colorPrimary,
                        height: 50,
                        onPressed: () {
                          onActionTap?.call();
                          Navigator.of(context).pop();
                        },
                        text: 'Submit',
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
