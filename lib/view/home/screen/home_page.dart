
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/guide/view/info_faq_dashboard.dart';
import 'package:dreamcast/view/home/model/config_detail_model.dart';
import 'package:dreamcast/view/menu/controller/menuController.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/photobooth/view/photoBooth.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/event_feed_widget.dart';
import '../../../widgets/home_menu_item.dart';
import '../../../widgets/home_widget/event_info_header.dart';
import '../../../widgets/home_widget/event_live_header.dart';
import '../../../widgets/home_widget/home_banner_widget.dart';
import '../../../widgets/home_widget/home_explore_more.dart';
import '../../../widgets/home_widget/home_feedback_widget.dart';
import '../../../widgets/home_widget/home_location_widget.dart';
import '../../../widgets/home_widget/home_partner_list.dart';
import '../../../widgets/home_widget/home_welcome_banner.dart';
import '../../../widgets/lunchpad_ai_widget.dart';
import '../../../widgets/customTextView.dart';
import '../../../widgets/button/custom_outlined_button.dart';
import '../../../widgets/lunchpad_menu_label.dart';
import '../../../widgets/resource_center_widget.dart';
import '../../../widgets/social_wall_widget.dart';
import '../../account/controller/account_controller.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../breifcase/controller/common_document_controller.dart';
import '../../breifcase/view/resourceCenter.dart';
import '../../chat/view/chatDashboard.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../exhibitors/controller/exhibitorsController.dart';
import '../../exhibitors/view/bootListPage.dart';
import '../../globalSearch/page/global_search_page.dart';
import '../../leaderboard/view/leaderboard__dashboard_page.dart';
import '../../polls/view/pollsPage.dart';
import '../../quiz/view/feedback_page.dart';
import '../../speakers/view/speaker_list_page.dart';
import '../../partners/controller/partnersController.dart';
import '../../partners/model/partnersModel.dart';
import '../../partners/view/partnersDetailPage.dart';
import '../../schedule/view/today_session_page.dart';
import '../controller/for_you_controller.dart';
import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final DashboardController _dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  final partnerController = Get.put(SponsorPartnersController());

  late Size size;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  bool _isButtonDisabled = false;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  CommonDocumentController resourceCenterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GetX<HomeController>(builder: (controller) {
              return Stack(
                children: [
                  RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: colorLightGray,
                    backgroundColor: colorPrimary,
                    strokeWidth: 1.0,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      return Future.delayed(
                        const Duration(seconds: 1),
                            () {
                          controller.getHomeApi(isRefresh: true);
                          if (Get.isRegistered<ForYouController>()) {
                            ForYouController controller = Get.find();
                            controller.initApiCall();
                          }
                        },
                      );
                    },
                    child: SizedBox(
                      height: context.height,
                      width: context.width,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: HomeWelcomeBanner(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0, bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 140,
                                  ),
                                  controller.eventStatus.value == 1
                                      ? LiveEventWidget(
                                      eventStatus:
                                      controller.eventStatus.value)
                                      : PreEventWidget(
                                      eventStatus:
                                      controller.eventStatus.value),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  userInfoWidget(),
                                  HomeHeaderMenuWidget(),
                                  HomeBannerWidget(),
                                  (controller.isFirstLoading.value == true || controller.loading.value == true) ||
                                      controller.menuFeatureHome.isEmpty
                                      ? const SizedBox()
                                      : homeFeaturesMenu(
                                      context, controller.menuFeatureHome),

                                  controller.recommendedForYouList.isNotEmpty
                                      ? Padding(
                                    padding:
                                    const EdgeInsets.only(top: 35.0),
                                    child: LaunchpadMenuLabel(
                                      title: "recommended_for_you".tr,
                                      trailing: "view_all".tr,
                                      index: 1,
                                      trailingIcon: "",
                                    ),
                                  )
                                      : const SizedBox(),
                                  LaunchpadAIWidget(),
                                  const HomePartnerList(),
                                  if (resourceCenterController
                                      .resourceCenterList.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: LaunchpadMenuLabel(
                                        title: "resource_center".tr,
                                        trailing: resourceCenterController
                                            .isMoreData.value ==
                                            true
                                            ? "view_all".tr
                                            : "",
                                        index: 3,
                                        trailingIcon: "",
                                      ),
                                    ),
                                  const ResourceCenterWidget(isFromHome: true),
                                  EventFeedWidget(),
                                  if (controller.configDetailBody.value
                                      .socialWall?.url !=
                                      null &&
                                      controller.configDetailBody.value
                                          .socialWall!.url!.isNotEmpty)
                                    buildSocialWall(context),
                                  const HomeLocationWidget(),
                                  buildSocialLink(context),
                                  const HomeFeedbackWidget(),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: controller.loading.value || controller.isHubLoading()
                        ? const Loading()
                        : const SizedBox(),
                  )
                ],
              );
            })
          ],
        ));
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[aiColor1, aiColor2],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Widget userInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextView(
          text: "Hi, ${authenticationManager.getName() ?? ""}",
          textAlign: TextAlign.start,
          maxLines: 1,
          softWrap: true,
          color: colorSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }

  Widget toolbarWidget(iconUrl, index) {
    return SizedBox(
      child: InkWell(
          onTap: () {
            switch (index) {
              case 0:
                Get.toNamed(ChatDashboardPage.routeName);
                break;
              case 1:
                _dashboardController.openAlertPage();
                break;
              case 2:
                Get.toNamed(InfoFaqDashboard.routeName);
                break;
              case 3:
                Get.toNamed(GlobalSearchPage.routeName);
                break;
            }
          },
          child: SvgPicture.asset(iconUrl)),
    );
  }

  Widget eventInfoHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder15,
          ),
          child: Padding(
            padding: EdgeInsets.all(14.adaptSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.eventRemainingTime.toLowerCase() == "ended"
                    ? const SizedBox()
                    : Container(
                  //padding: EdgeInsets.all(14.adaptSize),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.h,
                    vertical: 3.v,
                  ),
                  decoration: AppDecoration.fillGray.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  width: context.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextView(
                            text: "event_begins_in".tr,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            color: colorGray,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CustomTextView(
                            text:
                            controller.eventRemainingTime.value ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            color: colorSecondary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            var url = controller.configDetailBody.value
                                .location?.url ??
                                "";
                            UiHelper.inAppBrowserView(
                                Uri.parse(url.toString()));
                          },
                          child: SvgPicture.asset(
                            ImageConstant.ic_location,
                            height: 60,
                            width: 60,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: controller.eventRemainingTime.toLowerCase() == "ended"
                      ? 0
                      : 14.v,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          height: context.height,
                          padding: EdgeInsets.all(16.h),
                          decoration: AppDecoration.fillGray.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder10,
                          ),
                          width: context.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                ImageConstant.ic_schedule,
                                color: Colors.black,
                                height: 32,
                              ),
                              const SizedBox(height: 3),
                              Expanded(
                                child: AutoCustomTextView(
                                  text: controller.configDetailBody.value
                                      .datetime?.text ??
                                      "",
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  fontSize: 22,
                                  color: colorSecondary,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      controller.configDetailBody.value.location
                                          ?.shortText ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: colorGray,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.clip,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await Add2Calendar.addEvent2Cal(
                                        controller.buildEvent(
                                            controller.configDetailBody.value
                                                .name ??
                                                "",
                                            controller.configDetailBody.value
                                                .location?.shortText ??
                                                ""),
                                      ).then((success) {
                                        if (success) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            UiHelper.showSuccessMsg(context,
                                                "event_added_success".tr);
                                          });
                                        } else {
                                          print('event_added_failed'.tr);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                          ImageConstant.add_event,
                                          height: 22),
                                      // child: const Icon(
                                      //   Icons.add,
                                      //   color: Colors.black,
                                      // ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.h,
                    ),
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          height: context.height,
                          decoration: AppDecoration.fillGray.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder10,
                          ),
                          width: context.width,
                          child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      toolbarWidget(ImageConstant.svg_chat, 0),
                                      SizedBox(
                                        width: 14.v,
                                      ),
                                      toolbarWidget(
                                          _dashboardController.personalCount.value >
                                              0 ||
                                              authenticationManager
                                                  .showBadge.value
                                              ? ImageConstant.alert_badge
                                              : ImageConstant.svg_alert,
                                          1)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.v,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      toolbarWidget(ImageConstant.ic_info, 2),
                                      SizedBox(
                                        width: 14.v,
                                      ),
                                      //ic_badge
                                      toolbarWidget(ImageConstant.ic_search, 3)
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 19.v,
                ),
                CustomOutlinedButton(
                  height: 65.h,
                  buttonStyle: OutlinedButton.styleFrom(
                    backgroundColor: white,
                    side: const BorderSide(color: colorPrimary, width: 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(43)),
                    ),
                  ),
                  buttonTextStyle: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.fSize,
                  ),
                  onPressed: () {
                    if (_isButtonDisabled) return; // Prevent further clicks
                    _isButtonDisabled = true;
                    Future.delayed(const Duration(seconds: 4), () {
                      _isButtonDisabled =
                      false; // Re-enable the button after the screen is closed
                    });
                    controller.getHtmlPage("myAgenda".tr, "agenda", false);
                  },
                  text: "discover_program".tr,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget homeFeaturesMenu(
      BuildContext context,
      List<MenuData> itemList,
      ) {
    return Skeletonizer(
        enabled: controller.loading.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 35),
            LaunchpadMenuLabel(
              title: "features".tr,
              trailing: " ",
              index: 6,
              trailingIcon: "",
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: itemList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                MenuData data = itemList[index];
                return GestureDetector(
                  child: CommonMenuButton(
                    color: colorLightGray,
                    borderRadius: 10,
                    onTap: () {
                      HubController hubController = Get.find();
                      hubController.commonMenuRouting(menuData: data);
                    },
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0.adaptSize),
                          child: SvgPicture.network(
                            data.icon ?? "",
                            height: 45.adaptSize,
                            placeholderBuilder: (content) {
                              return const CircularProgressIndicator(
                                strokeWidth: 1,
                              );
                            },
                          ),
                        ),
                        CustomTextView(
                            text: data.label ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: true,
                            color: colorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.8,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _dashboardController.changeTabIndex(2);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextView(
                    text: "explore_more".tr,
                    fontSize: 18,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SvgPicture.asset(
                      ImageConstant.icExploreMore,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget buildSocialWall(BuildContext context) {
    return Column(
      children: [
        if ((controller.configDetailBody.value.socialWall?.hashtag ?? "")
            .isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: LaunchpadMenuLabel(
              title:
              controller.configDetailBody.value.socialWall?.hashtag ?? "",
              trailing: "",
              index: 4,
              trailingIcon: ImageConstant.icFullscreen,
            ),
          ),
        Container(
          // padding: EdgeInsets.symmetric(),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: indicatorColor, width: 1),
            ),
            child: SizedBox(
              height: 369.h,
              child: SocialWallWidget(),
            )),
      ],
    );
  }

  Widget buildEventFeed(BuildContext context) {
    return controller.feedDataList.isNotEmpty
        ? EventFeedWidget()
        : const SizedBox();
  }

  Widget buildSocialLink(BuildContext context) {
    var socialItem = controller.configDetailBody.value.socialLinks ?? [];
    return socialItem.isNotEmpty
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 35),
        LaunchpadMenuLabel(
          title: "social_media".tr,
          trailing: " ",
          index: 8,
          trailingIcon: "",
        ),
        Container(
          decoration: BoxDecoration(
              color: colorLightGray,
              borderRadius: BorderRadius.circular(15.adaptSize)),
          padding: EdgeInsets.symmetric(
              vertical: 18.adaptSize, horizontal: 20.adaptSize),
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 10,
              children: <Widget>[
                for (var item in socialItem)
                  Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: InkWell(
                            onTap: () {
                              print("Link: ${item.url}");
                              UiHelper.inAppBrowserView(
                                  Uri.parse(item.url.toString()));
                            },
                            child: SvgPicture.asset(
                              UiHelper.getSocialIcon(
                                  item.type.toString().toLowerCase()),
                            )),
                      )),
              ],
            ),
          ),
        ),
      ],
    )
        : const SizedBox();
  }
}