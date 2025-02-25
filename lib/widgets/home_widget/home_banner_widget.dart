import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/model/BriefcaseModel.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_colors.dart';
import '../../theme/ui_helper.dart';
import '../../utils/image_constant.dart';
import 'package:flutter/material.dart';
import '../fullscreen_image.dart';

class HomeBannerWidget extends GetView<CommonDocumentController> {
  HomeBannerWidget({super.key});

  var currentPageNotifier = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CommonDocumentController>(
      builder: (controller) {
        return controller.bannerList.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 35),
                  Skeletonizer(
                      enabled: controller.isFirstLoadRunning.value,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: true,
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          aspectRatio: 16 / 9,
                          initialPage: 0,
                          reverse: false,
                          autoPlayInterval: const Duration(seconds: 6),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 900),
                          onPageChanged: (index, reason) {
                            currentPageNotifier.value = index;
                          },
                        ),
                        itemCount: controller.bannerList.length ?? 0,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          var banner = controller.bannerList[itemIndex];

                          return Container(
                            width: context.width,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: appBarColor),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final media = banner.media;
                                    if (media == null) return;

                                    final type = media.type;
                                    final url = media.url ?? "";
                                    if (type?.contains("image") == true) {
                                      Get.to(FullImageView(imgUrl: url));
                                    } else if (type?.contains("youtube") ==
                                            true ||
                                        type?.contains("vimeo") == true ||
                                        type?.contains("html5") == true) {
                                      UiHelper.inAppWebView(Uri.parse(url));
                                    } else {
                                      UiHelper.inAppBrowserView(Uri.parse(url));
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            banner.media?.type == "image"
                                                ? banner.media?.url ?? ""
                                                : banner.media?.thumbnail ??
                                                    ""),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                  _buildCircleIndicator(),
                ],
              )
            : const SizedBox();
      },
    );
  }

  ///not used currently
  Widget defaultBanner(BuildContext context) {
    return Container(
        height: 200,
        width: context.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(ImageConstant.banner_img),
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget _buildCircleIndicator() {
    return controller.bannerList.isNotEmpty
        ? Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Obx(() => AnimatedSmoothIndicator(
                    count: controller.bannerList.length ?? 0,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.h,
                      dotWidth: 10,
                      radius: 43,
                      activeDotColor: colorSecondary,
                      dotColor: colorLightGray,
                    ),
                    activeIndex: currentPageNotifier.value,
                  )),
            ),
          )
        : const SizedBox();
  }
}

///used for the session banner
class SessionBannerWidget extends GetView<CommonDocumentController> {
  SessionBannerWidget({super.key});

  var currentPageNotifier = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CommonDocumentController>(
      builder: (controller) {
        return controller.sessionBannerList.isNotEmpty
            ? Column(
                children: [
                  Skeletonizer(
                      enabled: controller.isFirstLoadRunning.value,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: true,
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          aspectRatio: 16 / 9,
                          initialPage: 0,
                          reverse: false,
                          autoPlayInterval: const Duration(seconds: 6),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 900),
                          onPageChanged: (index, reason) {
                            currentPageNotifier.value = index;
                          },
                        ),
                        itemCount: controller.sessionBannerList.length ?? 0,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          var banner = controller.sessionBannerList[itemIndex];
                          return bannerWidgetView(context, banner);
                        },
                      )),
                  _buildCircleIndicator(),
                ],
              )
            : const SizedBox();
      },
    );
  }

  bannerWidgetView(BuildContext context, DocumentData banner) {
    return Container(
      height: 200,
      width: context.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: appBarColor),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              final media = banner.media;
              if (media == null) return;

              final type = media.type;
              final url = media.url ?? "";
              if (type?.contains("image") == true) {
                Get.to(FullImageView(imgUrl: url));
              } else if (type?.contains("youtube") == true ||
                  type?.contains("vimeo") == true ||
                  type?.contains("html5") == true) {
                UiHelper.inAppWebView(Uri.parse(url));
              } else {
                UiHelper.inAppBrowserView(Uri.parse(url));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(banner.media?.type == "image"
                      ? banner.media?.url ?? ""
                      : banner.media?.thumbnail ?? ""),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIndicator() {
    return controller.sessionBannerList.isNotEmpty
        ? Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Obx(() => AnimatedSmoothIndicator(
                    count: controller.sessionBannerList.length ?? 0,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 5,
                      dotWidth: 10,
                      activeDotColor: colorSecondary,
                      dotColor: colorLightGray,
                    ),
                    activeIndex: currentPageNotifier.value,
                  )),
            ),
          )
        : const SizedBox();
  }
}
