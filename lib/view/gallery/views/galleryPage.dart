// import 'package:dreamcast/utils/size_utils.dart';
// import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
// import 'package:dreamcast/widgets/fullscreen_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../theme/app_colors.dart';
// import '../../../widgets/app_bar/customAppBar2.dart';
// import '../../../widgets/loadMoreItem.dart';
// import '../../../widgets/loading.dart';
// import '../../../widgets/toolbarTitle.dart';
// import '../../beforeLogin/globalController/authentication_manager.dart';
// import '../../dashboard/dashboard_controller.dart';
// import '../../dashboard/showLoadingPage.dart';
// import '../../home/screen/inAppWebview.dart';
// import '../controller/galleryController.dart';
//
// class GalleryPage extends StatelessWidget {
//   final GalleryController controller = Get.put(GalleryController());
//   final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
//       GlobalKey<RefreshIndicatorState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           height: 0.v,
//           leadingWidth: 15.h,
//           leading: const SizedBox(),
//           title: const ToolbarTitle(title: "Gallery"),
//           bottom: TabBar(
//             indicatorColor: Colors.black,
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             labelStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//             unselectedLabelStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             ),
//             onTap: (index) {
//               // Call the controller method to update the content based on the selected tab
//               controller.onTabChanged(index);
//             },
//             tabs: const [
//               Tab(text: 'Images'),
//               Tab(text: 'Videos'),
//             ],
//           ),
//         ),
//         body: Obx(() {
//           return controller.isLoading.value
//               ? Center(
//                   child: buildShimmerLoader(context)) // Show loading indicator
//               : TabBarView(
//             physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     // Images Tab
//                     buildImage(),
//                     // Videos Tab
//                     buildVideo(),
//                   ],
//                 );
//         }),
//       ),
//     );
//   }
//
//   Widget buildImage() {
//     return GetX<GalleryController>(builder: (controller) {
//       return Stack(
//         children: [
//           RefreshIndicator(
//             key: _refreshTab1Key,
//             onRefresh: () async {
//               // Call the method to refresh the image list
//               await controller.getImageList();
//             },
//             child: Column(
//               children: [
//                 Expanded(
//                   child: GridView.builder(
//                     controller: controller.imageScrollController,
//                     padding: const EdgeInsets.all(10.0),
//                     physics: const AlwaysScrollableScrollPhysics(), // Enable bouncing
//                     itemCount: controller.imageList.length,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 8.0,
//                       mainAxisSpacing: 8.0,
//                     ),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: (){
//                           Get.to(() => FullImageView(
//                             imgUrl:  controller.imageList[index].media ?? "",
//                           ));
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.network(
//                             controller.imageList[index].media ?? "",
//                             height: context.height,
//                             width: context.width,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 controller.isLoadMoreRunning.value
//                     ? const LoadMoreLoading()
//                     : const SizedBox()
//               ],
//             ),
//           ),
//
//           _progressEmptyImageWidget(),
//         ],
//       );
//     });
//   }
//
//   Widget buildVideo() {
//     return GetX<GalleryController>(builder: (controller) {
//       return Stack(
//         children: [
//           RefreshIndicator(
//             key: _refreshTab1Key,
//           onRefresh: () async {
//         // Call the method to refresh the image list
//         await controller.getVideoList(type: "youtube");
//       }, child:
//           GridView.builder(
//             controller: controller.videoScrollController,
//             padding: const EdgeInsets.all(8.0),
//             itemCount: controller.videoList.length,
//             physics: const AlwaysScrollableScrollPhysics(), // Enable bouncing
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8.0,
//               mainAxisSpacing: 8.0,
//             ),
//             itemBuilder: (context, index) {
//               var video = controller.videoList[index];
//               return GestureDetector(
//                 onTap: () {
//                   // Get.to(() => InAppWebviewPage(
//                   //   title: video.name ?? "",
//                   //   htmlPath: video.videoPath ?? "",
//                   // ));
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         video.media ?? "",
//                         height: context.height,
//                         width: context.width,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const Icon(
//                       Icons.play_circle_filled,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           )),
//           _progressEmptyVideoWidget()
//         ],
//       );
//     });
//   }
//
//   Widget _progressEmptyImageWidget() {
//     return Center(
//       child: controller.isLoading.value
//           ? const Loading()
//           : !controller.isLoading.value && controller.imageList.isEmpty
//               ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
//               :  const SizedBox(),
//     );
//   }
//
//   Widget _progressEmptyVideoWidget() {
//     return Center(
//       child: controller.isLoading.value
//           ? const Loading()
//           : !controller.isLoading.value && controller.videoList.isEmpty
//               ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
//               : const SizedBox(),
//     );
//   }
// }
//
// Widget buildShimmerLoader(BuildContext context) {
//   return Shimmer.fromColors(
//     baseColor: Colors.grey[300]!,
//     highlightColor: Colors.grey[100]!,
//     child: GridView.builder(
//       padding: const EdgeInsets.all(10.0),
//       itemCount: 6, // Number of shimmer placeholders
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemBuilder: (context, index) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Container(
//             color: Colors.white,
//             height: context.height,
//             width: context.width,
//           ),
//         );
//       },
//     ),
//   );
// }
