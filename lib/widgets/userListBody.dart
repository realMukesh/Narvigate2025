import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/Notes/controller/featureNetworkingController.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_controller.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../theme/app_colors.dart';
import '../theme/ui_helper.dart';
import '../utils/dialog_constant.dart';
import '../utils/image_constant.dart';
import '../view/myFavourites/controller/favourite_user_controller.dart';
import 'recommended_widget.dart';
import 'customImageWidget.dart';
import 'loading.dart';
import '../view/representatives/controller/user_detail_controller.dart';

class UserListWidget extends StatelessWidget {
  dynamic representatives;
  bool isFromBookmark;
  bool? isFromSearch = false;
  final Function press;

  UserListWidget({
    super.key,
    required this.representatives,
    required this.press,
    required this.isFromBookmark,
    this.isFromSearch,
  });

  final UserDetailController controller = Get.find();
  final AuthenticationManager authenticationManager = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () async {
          press();
        });
      },
      child: Container(
        width: context.width,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.only(left: 14, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.transparent,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 2.v),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomImageWidget(
                          imageUrl: representatives.avatar ?? "",
                          shortName: representatives.shortName ?? "",
                          size: 70.adaptSize,
                          borderWidth: 0,
                        ),
                        SizedBox(width: 18.v),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextView(
                                  text:
                                      representatives.name?.toString().trim() ??
                                          "",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                  // color: colorPrimaryDark,
                                ),
                                SizedBox(height: 4.v),
                                representatives?.position?.isNotEmpty ?? false
                                    ? CustomTextView(
                                        text:
                                            "${representatives.position ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: colorGray,
                                        fontWeight: FontWeight.normal,
                                        textAlign: TextAlign.start,
                                      )
                                    : const SizedBox(),
                                representatives?.company?.isNotEmpty ?? false
                                    ? CustomTextView(
                                        text:
                                            "${representatives.company ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: colorGray,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Obx(() => controller.recommendedIdsList
                                            .contains(representatives.id)
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, right: 8),
                                            child: RecommendedWidget(),
                                          )
                                        : const SizedBox()),
                                    representatives.isNotes == "1"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: SvgPicture.asset(
                                                ImageConstant.notesIcon),
                                          )
                                        : const SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20.h),
                        (isFromSearch != null || representatives.isBlocked=="1")
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topRight,
                                child: Obx(() => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (!authenticationManager
                                                .isLogin()) {
                                              DialogConstant.showLoginDialog(
                                                  context,
                                                  authenticationManager);
                                              return;
                                            }
                                            representatives.isLoading(true);
                                            await controller.bookmarkToUser(
                                                representatives.id,
                                                representatives.role,
                                                context);
                                            representatives.isLoading(false);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: SvgPicture.asset(
                                              isFromBookmark
                                                  ? ImageConstant.bookmarkIcon
                                                  : controller.bookMarkIdsList
                                                          .contains(
                                                              representatives
                                                                  .id)
                                                      ? ImageConstant
                                                          .bookmarkIcon
                                                      : ImageConstant
                                                          .unBookmarkIcon,
                                              width: 14,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                        representatives.isLoading.value
                                            ? const FavLoading()
                                            : const SizedBox()
                                      ],
                                    ))),
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
          ],
        ),
      ),
    );
  }
}

///temp its out of scope
class UserFeatureWidget extends GetView<FeatureNetworkingController> {
  dynamic representatives;
  bool isFromBookmark;
  bool? isFromSearch = false;
  final Function press;

  UserFeatureWidget({
    super.key,
    required this.representatives,
    required this.press,
    required this.isFromBookmark,
    this.isFromSearch,
  });

  final AuthenticationManager authenticationManager = Get.find();
  final UserDetailController userDetailController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration.zero, () async {
          press();
        });
      },
      child: Container(
        width: context.width,
        margin: EdgeInsets.only(left: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomImageWidget(
                            imageUrl: representatives.avatar ?? "",
                            shortName: representatives.shortName ?? ""),
                        SizedBox(width: 20.h),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextView(
                                  text:
                                      representatives.name?.toString().trim() ??
                                          "",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                  color: colorSecondary,
                                ),
                                SizedBox(height: 6.v),
                                representatives.position.toString().isEmpty
                                    ? const SizedBox()
                                    : CustomTextView(
                                        text:
                                            "${representatives.position ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: gray,
                                        fontWeight: FontWeight.normal,
                                        textAlign: TextAlign.start,
                                      ),
                                representatives.company.toString().isEmpty
                                    ? const SizedBox()
                                    : CustomTextView(
                                        text:
                                            "${representatives.company ?? ""}",
                                        fontSize: 14,
                                        maxLines: 1,
                                        color: gray,
                                        fontWeight: FontWeight.normal,
                                        textAlign: TextAlign.start,
                                      ),
                                SizedBox(height: 6.v),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20.h),
                        isFromSearch != null
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topRight,
                                child: isFromBookmark
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: SvgPicture.asset(
                                            ImageConstant.bookmarkIcon),
                                      )
                                    : Obx(
                                        () => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (!authenticationManager
                                                    .isLogin()) {
                                                  DialogConstant.showLoginDialog(
                                                      context,
                                                      authenticationManager);
                                                  return;
                                                }
                                                representatives.isLoading(true);
                                                await userDetailController
                                                    .bookmarkToUser(
                                                        representatives.id,
                                                        representatives.role,
                                                        context);
                                                representatives
                                                    .isLoading(false);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: SvgPicture.asset(
                                                  controller.bookMarkIdsList
                                                          .contains(
                                                              representatives
                                                                  .id)
                                                      ? ImageConstant
                                                          .bookmarkIcon
                                                      : ImageConstant
                                                          .unBookmarkIcon,
                                                ),
                                              ),
                                            ),
                                            representatives.isLoading.value
                                                ? const FavLoading()
                                                : const SizedBox()
                                          ],
                                        ),
                                      )),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                    child: Divider(
                      color: indicatorColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.h),
          ],
        ),
      ),
    );
  }
}
