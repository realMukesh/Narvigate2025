import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/Notes/view/notes_dashboard.dart';
import 'package:dreamcast/view/account/controller/setting_controller.dart';
import 'package:dreamcast/view/account/model/profileModel.dart';
import 'package:dreamcast/view/account/view/settingPage.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/view/breifcase_page.dart';
import 'package:dreamcast/view/myFavourites/view/favourite_dashboard.dart';
import 'package:dreamcast/view/myFavourites/view/for_you_dashboard.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/skeletonView/profile_skeleton.dart';
import 'package:dreamcast/view/travelDesk/view/travelDeskPage.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/custom_profile_image.dart';
import 'package:dreamcast/widgets/profile_bio_widget.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/company_position_widget.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/loading.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../menu/controller/menuController.dart';
import '../../profileSetup/controller/profileSetupController.dart';
import '../../qrCode/view/qr_dashboard_page.dart';
import '../controller/account_controller.dart';

class AccountPage extends GetView<AccountController> {
  static const routeName = "/account_page";

  AccountPage({Key? key}) : super(key: key);

  AuthenticationManager authenticationManager = Get.find();
  final DashboardController dashboardController = Get.find();
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (_) {
      return Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(
          height: 72.v,
          leadingWidth: 45.h,
          /*leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(
              left: 7.h,
              top: 3,
              // bottom: 12.v,
            ),
            onTap: () {
              Get.back();
            },
          ),*/
          title: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: ToolbarTitle(title: "profile".tr),
          ),
          backgroundColor: colorLightGray,
          dividerHeight: 0,
          actions: [
            InkWell(
              onTap: () {
                if (Get.isRegistered<SettingController>()) {
                  Get.delete<SettingController>();
                }
                Get.toNamed(SettingPage.routeName);
              },
              child: Container(
                height: 31.v,
                width: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 6.h),
                decoration: AppDecoration.decorationActionButton,
                child: SvgPicture.asset(
                  ImageConstant.setting_icon,
                  width: 13,
                ),
              ),
            ),
            SizedBox(
              width: 11.h,
            ),
            InkWell(
              onTap: () async {
                var result = await Get.toNamed(ProfileEditPage.routeName);
                if (result != null) {
                  controller.callDefaultApi();
                }
              },
              child: Container(
                height: 31.v,
                width: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 6.h),
                decoration: AppDecoration.decorationActionButton,
                child: SvgPicture.asset(
                  ImageConstant.ic_edit_icon,
                  width: 13,
                ),
              ),
            ),
            SizedBox(
              width: 15.h,
            ),
          ],
        ),
        body: Container(
          width: context.width,
          decoration: BoxDecoration(
              color: colorLightGray, borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(top: 15),
          child: GetX<AccountController>(
            builder: (controller) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: white,
                      constraints:
                      BoxConstraints(maxHeight: context.height / 2),
                    ),
                  ),
                  RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: colorSecondary,
                      strokeWidth: 4.0,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                              () {
                            controller.callDefaultApi();
                          },
                        );
                      },
                      child: SizedBox(
                        width: context.width,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: controller.isLoading.value ||
                              controller.profileBody?.id == null
                              ? SizedBox(
                            child: Skeletonizer(
                                enabled: true, child: ProfileSkeleton()),
                          )
                              : Stack(
                            fit: StackFit.loose,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 53.v),
                                decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black.withOpacity(0.15),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(19),
                                    topRight: Radius.circular(19),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 70.v,
                                    ),
                                    profileNameWidget(),
                                    SizedBox(
                                      height: 10.v,
                                    ),
                                    //aiProfileWidget(context),
                                    SizedBox(
                                      height:
                                      controller.profileMenu.isEmpty
                                          ? 10.adaptSize
                                          : 20.adaptSize,
                                    ),
                                    controller.profileMenu.isEmpty
                                        ? SizedBox()
                                        : exploreMenuWidget(context),
                                    infoWidget(
                                        controller.profileBody?.info),

                                    aiGeneratedWidget(
                                        controller.profileBody),
                                    SizedBox(
                                      height: 24.v,
                                    ),
                                    aiMatchKeywordsWidget(
                                        controller.profileBody?.virtual
                                            ?.params ??
                                            [],
                                        controller.profileBody?.virtual
                                            ?.label
                                            ?.toUpperCase() ??
                                            ""),
                                    controller.profileBody?.virtual
                                        ?.params !=
                                        null &&
                                        controller
                                            .profileBody!
                                            .virtual!
                                            .params!
                                            .isNotEmpty
                                        ? SizedBox(
                                      height: 24.v,
                                    )
                                        : const SizedBox(),
                                    //notesWidget(),
                                    SizedBox(
                                      height: 30.v,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: appVersionWidget(),
                                    ),
                                    SizedBox(
                                      height: 20.v,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CustomProfileImage(
                                  profileUrl:
                                  controller.profilePicUrl.value,
                                  shortName:
                                  controller.profileBody?.shortName ??
                                      "",
                                  borderColor: colorLightGray,
                                  isAiProfile:
                                  controller.profileBody?.aiProfile ==
                                      1
                                      ? true
                                      : false,
                                  isAccountPage: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  controller.isHubLoading() ?? false
                      ? const Loading()
                      : const SizedBox()
                ],
              );
            },
          ),
        ),
      );
    });
  }

  exploreMenuWidget(BuildContext context) {
    return ConstrainedBox(
      constraints:
      BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.14),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: controller.profileMenu.length,
        itemBuilder: (context, index) {
          var data = controller.profileMenu[index];
          return GestureDetector(
            onTap: () {
              HubController hubController = Get.find();
              hubController.commonMenuRouting(menuData: data);
            },
            child: Container(
              margin: EdgeInsets.only(right: 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 68.v,
                    width: 68.h,
                    decoration: const BoxDecoration(
                      color: colorLightGray,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: SvgPicture.network(
                        data.icon ?? "",
                        height: 34.adaptSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.v,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    data.label ?? "",
                    style: GoogleFonts.getFont(MyConstant.currentFont,
                        color: colorSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.fSize),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///email,country code,mobile,website
  infoWidget(Info? info) {
    return Container(
      padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 12, bottom: 6),
      decoration: const BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonLabelField(label: info?.text ?? ""),
          ListView.separated(
            itemCount: info?.params?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var item = info?.params?[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 2.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: context.width * .15,
                      child: CustomTextView(
                        text: "${item?.label ?? ""}:",
                        maxLines: 2,
                        color: colorGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    CustomTextView(
                      text: item?.value ?? "",
                      maxLines: 2,
                      color: colorSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                color: indicatorColor,
              );
            },
          ),
        ],
      ),
    );
  }

  profileNameWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextView(
            maxLines: 1,
            fontSize: 22,
            color: colorSecondary,
            fontWeight: FontWeight.w600,
            text: controller.profileBody?.name ?? ""),
        CompanyPositionWidget(
          company: controller.profileBody?.position ?? "",
          position: controller.profileBody?.company ?? "",
        ),
      ],
    );
  }

  buildSocialMediaWidget(List<dynamic> params, String title) {
    return params.isNotEmpty
        ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          commonLabelField(label: title.capitalize ?? ""),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 10,
            children: <Widget>[
              for (var item in params ?? [])
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: InkWell(
                          onTap: () {
                            UiHelper.inAppWebView(
                                Uri.parse(item.value.toString()));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(1),
                              child: SvgPicture.asset(
                                UiHelper.getSocialIcon(
                                    item.label.toString().toLowerCase()),
                              ))),
                    )),
            ],
          )
        ])
        : const SizedBox();
  }

  ///bio,keywords.insight,social media
  aiGeneratedWidget(ProfileBody? profileBody) {
    final bioParams = profileBody?.bio?.params;
    final socialMediaParams = profileBody?.socialMedia?.params;
    return ((bioParams?.isNotEmpty ??
        false || socialMediaParams!.isNotEmpty ??
        false))
        ? Column(
      children: [
        SizedBox(
          height: 24.v,
        ),
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: colorSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [aiColor1, aiColor2],
                  )),
              child: Container(
                padding: EdgeInsets.only(
                    left: 12.h, right: 12.h, bottom: 12.h),
                decoration: const BoxDecoration(
                    color: colorLightGray,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    top: 25, left: 4, right: 4, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bioParams?.length,
                      itemBuilder: (context, index) {
                        var about = bioParams?[index];
                        return about?.value is List?
                            ? aiKeywordsBody(
                            about?.value ?? [], about?.label ?? "")
                            : ProfileBioWidget(
                          title: about?.label ?? "",
                          content: about?.value ?? "",
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    buildSocialMediaWidget(
                        socialMediaParams ?? [],
                        profileBody?.socialMedia?.text?.toUpperCase() ??
                            ""),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            profileBody?.aiProfile.toString() == "1"
                ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(ImageConstant.ai_star),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomTextView(
                      text: "ai_generated".tr,
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox()
          ],
        ),
      ],
    )
        : const SizedBox();
  }

  aiMatchKeywordsWidget(List<dynamic> params, String title) {
    return Container(
      decoration: BoxDecoration(
          color: colorLightGray,
          border: Border.all(color: indicatorColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: params.isNotEmpty
          ? ListView.separated(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 6);
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: params.length ?? 0,
        itemBuilder: (context, index) {
          var data = params[index];
          return aiKeywordsBody(data.value, data.label);
        },
      )
          : const SizedBox(),
    );
  }

  commonLabelField({required String label}) {
    return CustomTextView(
      text: label ?? "",
      textAlign: TextAlign.start,
      color: colorSecondary,
      fontSize: 19,
      fontWeight: FontWeight.w500,
    );
  }

  aiKeywordsBody(List<dynamic>? value, label) {
    return value != null && value.isNotEmpty
        ? ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: commonLabelField(label: label ?? ""),
      subtitle: Wrap(
        spacing: 6,
        children: <Widget>[
          for (var item in value)
            MyFlowWidget(item ?? "", isBgColor: true),
        ],
      ),
    )
        : const SizedBox();
  }

  notesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(
          text: "my_notes".tr,
          maxLines: 100,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorSecondary,
        ),
        SizedBox(
          height: 8.v,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.speaker != null &&
                      controller.notesData.value.speaker! > 0) {
                    if (Get.isRegistered<MyNotesController>()) {
                      Get.delete<MyNotesController>();
                    }
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.speakers});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: colorLightGray,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                            "${controller.notesData.value.speaker ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "speakers".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.user != null &&
                      controller.notesData.value.user! > 0) {
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.attendee});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: colorLightGray,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                            "${controller.notesData.value.user ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "attendee".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.v,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (controller.notesData.value.exhibitor != null &&
                      controller.notesData.value.exhibitor! > 0) {
                    Get.toNamed(NotesDashboard.routeName,
                        arguments: {"role": MyConstant.exhibitor});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: colorLightGray,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextView(
                            text:
                            "${controller.notesData.value.exhibitor ?? ""} Notes",
                            maxLines: 100,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorSecondary,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextView(
                        text: "exhibitors".tr,
                        maxLines: 100,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            )
          ],
        )
      ],
    );
  }

  aiProfileWidget(BuildContext context) {
    return CustomIconButton(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.profile_through_ai),
        ),
      ),
      height: 54.v,
      width: context.width,
      onTap: () {
        if (Get.isRegistered<EditProfileController>()) {
          final EditProfileController controller = Get.find();
          controller.showLinkedinDialog(
              title: "disclaimer".tr,
              content: "disclaimer".tr,
              linkedinUrl: authenticationManager.getLinkedUrl() ?? "");
        } else {
          final controller = Get.put(EditProfileController(), permanent: false);
          controller.showLinkedinDialog(
              title: "disclaimer".tr,
              content: "disclaimer".tr,
              linkedinUrl: authenticationManager.getLinkedUrl() ?? "");
        }
      },
    );
  }

  appVersionWidget() {
    return Column(
      children: [
        const CustomTextView(
          text: "Version 1.2.4",
          //text: "Version ${controller.appVersionName}",
          fontWeight: FontWeight.normal,
          color: colorPrimary,
          textAlign: TextAlign.start,
        ),
        CustomTextView(
          text: AppUrl.topicName == "STAGING_EVENTAPP_IMC2024"
              ? "staging_mode".tr
              : "",
          fontWeight: FontWeight.normal,
          color: colorPrimary,
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}
