import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/breifcase/model/BriefcaseModel.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';
import '../../theme/ui_helper.dart';
import '../../utils/image_constant.dart';
import '../../view/home/screen/inAppWebview.dart';
import '../../view/home/screen/pdfViewer.dart';
import '../customTextView.dart';
import '../fullscreen_image.dart';

class CommonDocumentWidget extends GetView<CommonDocumentController> {
  DocumentData data;
  bool isBriefcase;
  bool showBookmark;
  final VoidCallback? onBookmarkTap;
  CommonDocumentWidget(
      {super.key,
      required this.data,
      this.onBookmarkTap,
      required this.isBriefcase,
      required this.showBookmark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final media = data.media;
        if (media == null) return;

        final type = media.type;
        final url = media.url ?? "";
        final name = data.name ?? "";

        switch (type) {
          case "pdf":
            Get.to(PdfViewPage(htmlPath: url, title: name));
            break;
          case "in_app_link":
            if(url.isNotEmpty && url !="null"){
              Get.toNamed(CustomWebViewPage.routeName, arguments: {
                "page_url": url,
                "title": name,
              });
            }else{
              UiHelper.showFailureMsg(context, "Invalid url.");
            }
            break;
          default:
            if (type?.contains("image") == true) {
              Get.to(FullImageView(imgUrl: url));
            } else if (type?.contains("youtube") == true ||
                type?.contains("vimeo") == true ||
                type?.contains("html5") == true) {
              UiHelper.inAppWebView(Uri.parse(url));
            } else {
              UiHelper.inAppBrowserView(Uri.parse(url));
            }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.v, horizontal: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    {
                           "pdf": ImageConstant.ic_exe_pdf_icon,
                          "image": ImageConstant.image_icon,
                          "in_app_link": ImageConstant.ic_link_icon,
                          "external_link": ImageConstant.ic_link_icon,
                        }[data?.media?.type] ??
                        ImageConstant.ic_video_link,
                  ),
                  SizedBox(
                    width: 12.h,
                  ),
                  Expanded(
                    child: CustomTextView(
                      text: data.name ?? "",
                      maxLines: 50,
                      color: colorSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            showBookmark
                ? Obx(() => Skeletonizer(
                      enabled: controller.isBookmarkLoading.value,
                      child: controller.isBookmarkLoading.value
                          ? Container(
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            )
                          : GestureDetector(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  isBriefcase
                                      ? SvgPicture.asset(
                                          ImageConstant.add_to_briefcase_sel,
                                        )
                                      : SvgPicture.asset(
                                          controller.bookMarkIdsList
                                                  .contains(data.id)
                                              ? ImageConstant
                                                  .add_to_briefcase_sel
                                              : ImageConstant.add_to_briefcase,
                                        ),
                                  data.isFavLoading.value
                                      ? const FavLoading()
                                      : const SizedBox()
                                ],
                              ),
                              onTap: () async {
                                onBookmarkTap?.call();
                              },
                            ),
                    ))
                : SvgPicture.asset(ImageConstant.temp_arrow_details)
          ],
        ),
      ),
    );
  }
}


class CommonDocumentWidgetBoot extends GetView<BootController> {
  DocumentData data;
  bool isBriefcase;
  bool showBookmark;
  final VoidCallback? onBookmarkTap;
  CommonDocumentWidgetBoot(
      {super.key,
        required this.data,
        this.onBookmarkTap,
        required this.isBriefcase,
        required this.showBookmark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final media = data.media;
        if (media == null) return;

        final type = media.type;
        final url = media.url ?? "";
        final name = data.name ?? "";

        switch (type) {
          case "pdf":
            Get.to(PdfViewPage(htmlPath: url, title: name));
            break;
          case "in_app_link":
            if(url.isNotEmpty && url !="null"){
              Get.toNamed(CustomWebViewPage.routeName, arguments: {
                "page_url": url,
                "title": name,
              });
            }else{
              UiHelper.showFailureMsg(context, "Invalid url.");
            }
            break;
          default:
            if (type?.contains("image") == true) {
              Get.to(FullImageView(imgUrl: url));
            } else if (type?.contains("youtube") == true ||
                type?.contains("vimeo") == true ||
                type?.contains("html5") == true) {
              UiHelper.inAppWebView(Uri.parse(url));
            } else {
              UiHelper.inAppBrowserView(Uri.parse(url));
            }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.v, horizontal: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    {
                      "pdf": ImageConstant.ic_exe_pdf_icon,
                      "image": ImageConstant.image_icon,
                      "in_app_link": ImageConstant.ic_link_icon,
                      "external_link": ImageConstant.ic_link_icon,
                    }[data?.media?.type] ??
                        ImageConstant.ic_video_link,
                  ),
                  SizedBox(
                    width: 12.h,
                  ),
                  Expanded(
                    child: CustomTextView(
                      text: data.name ?? "",
                      maxLines: 50,
                      color: colorSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            showBookmark
                ? Obx(() => Skeletonizer(
              enabled: controller.isLoading.value,
              child: controller.isLoading.value
                  ? Container(
                height: 30,
                width: 30,
                color: Colors.white,
              )
                  : GestureDetector(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    isBriefcase
                        ? SvgPicture.asset(
                      ImageConstant.add_to_briefcase_sel,
                    )
                        : SvgPicture.asset(
                      controller.bookmarkDocumentIdsList
                          .contains(data.id)
                          ? ImageConstant
                          .add_to_briefcase_sel
                          : ImageConstant.add_to_briefcase,
                    ),
                    data.isFavLoading.value
                        ? const FavLoading()
                        : const SizedBox()
                  ],
                ),
                onTap: () async {
                  onBookmarkTap?.call();
                },
              ),
            ))
                : SvgPicture.asset(ImageConstant.temp_arrow_details)
          ],
        ),
      ),
    );
  }
}
