import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/button/custom_icon_button.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/photobooth/controller/photobooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/fullscreen_image.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/photobooth_list_skeleton.dart';
import '../model/photoListModel.dart';

class AIPhotoSeachPage extends GetView<PhotoBoothController> {
  AIPhotoSeachPage({Key? key}) : super(key: key);
  static const routeName = "/photoBoothPage";
  PhotoBoothController photoboothController = Get.put(PhotoBoothController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshVideoIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: bgColor,
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
          title: ToolbarTitle(title: "ai_gallery".tr),
        ),
        body: Column(
          children: [
            // TabBar(
            //   indicatorColor: Colors.black,
            //   indicatorSize: TabBarIndicatorSize.tab,
            //   labelColor: Colors.black,
            //   unselectedLabelColor: Colors.grey,
            //   labelStyle: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   unselectedLabelStyle: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   onTap: (index) {
            //     // Call the controller method to update the content based on the selected tab
            //     controller.onTabChanged(index);
            //   },
            //   tabs: const [
            //     Tab(text: 'Images'),
            //     Tab(text: 'Videos'),
            //   ],
            // ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Images Tab
                  buildImage(context),
                  // Videos Tab
                  // buildVideo(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return GetX<PhotoBoothController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              children: [
                Skeletonizer(
                  enabled: controller.isFirstLoadRunning.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView(
                          text:
                              "Total ${controller.totalPhotos.value.toString()} Photos",
                          color: colorGray,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (controller.isMyPhotos.value) {
                              await controller.getAllPhotos(
                                  body: {"page": 1},
                                  isRefresh: false);
                            } else {
                              controller.showPicker(context, false);
                            }
                          },
                          child: CustomTextView(
                            text: controller.isMyPhotos.value
                                ? "All Photos"
                                : "upload_photo".tr,
                            color: aiColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Expanded(
                    child: RefreshIndicator(
                  color: colorLightGray,
                  backgroundColor: colorPrimary,
                  strokeWidth: 1.0,
                  key: _refreshIndicatorKey,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () async {
                        await controller.getAllPhotos(
                          body: {"page": 1},
                          isRefresh: true,
                        );
                      },
                    );
                  },
                  child: loadListView(),
                )),
                // when the _loadMore function is running
                controller.isLoadMoreRunning.value
                    ? const LoadMoreLoading()
                    : const SizedBox(),
                SizedBox(
                  height: controller.isLoadMoreRunning.value ?  0 :12,
                ),
              ],
            ),
            _progressEmptyWidget(),
            !controller.isLoadMoreRunning.value && controller.isAiSearchVisible.value &&
                    controller.photoList.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: CustomIconButton(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage(ImageConstant.ai_photo_search))),
                        height: 50,
                        width: context.width,
                        onTap: () {
                          controller.searchFromCamera();
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value && controller.photoList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  ///main list view
  loadListView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 44),
      child: Skeletonizer(
          enabled: controller.isFirstLoadRunning.value,
          child: controller.isFirstLoadRunning.value
              ? const PhotoListSkeleton()
              : GridView.builder(
                  //reverse: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController,
                  itemCount: controller.photoList.length,
                  itemBuilder: (context, index) {
                    String data = controller.photoList[index] ?? "";
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(FullImageView(
                                imgUrl: data ?? "",
                                showNotification: true,
                                showDownload: true,
                              ));
                            },
                            child: SizedBox(
                              height: context.height,
                              width: context.width,
                              child: UiHelper.getPhotoBoothImage(
                                  imageUrl: data ?? ""),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16),
                )),
    );
  }

  // Widget buildVideo(BuildContext context) {
  //   return GetX<PhotoBoothController>(builder: (controller) {
  //     return Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Stack(
  //         children: [
  //           Column(
  //             children: [
  //               Skeletonizer(
  //                 enabled: controller.isFirstLoadVideoRunning.value,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     CustomTextView(
  //                         text:
  //                         "Total ${controller.totalPhotos.value.toString()} videos",
  //                         color: colorGray,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 22),
  //                     // TextButton(
  //                     //     onPressed: () async {
  //                     //       if (controller.isMyVideo.value) {
  //                     //         await controller.getAllPhotos(
  //                     //             body: {"page": 1, "type": "video"},
  //                     //             isRefresh: false);
  //                     //       } else {
  //                     //         controller.showPicker(context, false);
  //                     //       }
  //                     //     },
  //                     //     child: CustomTextView(
  //                     //       text: controller.isMyVideo.value
  //                     //           ? "All Photos"
  //                     //           : "upload_photo".tr,
  //                     //       color: aiColor,
  //                     //       fontSize: 18,
  //                     //       fontWeight: FontWeight.normal,
  //                     //     ))
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 6,
  //               ),
  //               Expanded(
  //                 child: RefreshIndicator(
  //                   key: _refreshVideoIndicatorKey,
  //                   onRefresh: () async {
  //                     return Future.delayed(
  //                       const Duration(seconds: 1),
  //                           () async {
  //                         await controller.getAllVideo(
  //                           body: {"page": 1, "type": "video"},
  //                           isRefresh: true,
  //                         );
  //                       },
  //                     );
  //                   },
  //                   child: loadVideoListView(),
  //                 ),
  //               ),
  //               controller.isLoadMoreVideoRunning.value
  //                   ? const LoadMoreLoading()
  //                   : const SizedBox(),
  //               const SizedBox(
  //                 height: 12,
  //               )
  //             ],
  //           ),
  //           _progressEmptyVideoWidget()
  //         ],
  //       ),
  //     );
  //   });
  // }

  ///main video list view
  // loadVideoListView() {
  //   return Container(
  //     // margin: const EdgeInsets.only(bottom: 40),
  //     child: Skeletonizer(
  //         enabled: controller.isFirstLoadVideoRunning.value,
  //         child: controller.isFirstLoadVideoRunning.value
  //             ? const PhotoListSkeleton()
  //             : GridView.builder(
  //                 //reverse: false,
  //                 physics: const AlwaysScrollableScrollPhysics(),
  //                 controller: controller.scrollVideoController,
  //                 itemCount: controller.videoList.length,
  //                 itemBuilder: (context, index) {
  //                   Gallery data = controller.videoList[index];
  //                   return GestureDetector(
  //                     onTap: () {
  //                       String type = data.mediaType ?? "";
  //                       String url = data.mediaLink ?? "";
  //
  //                       if (type.contains("youtube") == true ||
  //                           type.contains("vimeo") == true ||
  //                           type.contains("html5") == true) {
  //                         UiHelper.inAppWebView(Uri.parse(url));
  //                       } else {
  //                         UiHelper.inAppBrowserView(Uri.parse(url));
  //                       }
  //                     },
  //                     child: Stack(
  //                       alignment: Alignment.center,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: SizedBox(
  //                             height: context.height,
  //                             width: context.width,
  //                             child: UiHelper.getPhotoBoothImage(
  //                                 imageUrl: data.mediaFile ?? ""),
  //                           ),
  //                         ),
  //                         const Icon(
  //                           Icons.play_circle_filled,
  //                           color: Colors.white,
  //                           size: 40,
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     childAspectRatio: 1 / 1,
  //                     mainAxisSpacing: 16,
  //                     crossAxisSpacing: 16),
  //               )),
  //   );
  // }

  Widget _progressEmptyVideoWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadVideoRunning.value &&
          controller.videoList.isEmpty
          ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
          : const SizedBox(),
    );
  }

  _buildVideoPlayer({url}) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onEnterFullscreen: (controller) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      onExitFullscreen: (controller) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          mediaPlaybackRequiresUserGesture: false,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      androidOnPermissionRequest: (InAppWebViewController controller,
          String origin, List<String> resources) async {
        await Permission.camera.request();
        await Permission.microphone.request();
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }
}
