import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_session_controller.dart';
import 'package:dreamcast/view/skeletonView/sessionSkeletonList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../schedule/controller/session_controller.dart';
import '../../schedule/view/session_list_body.dart';
import '../../skeletonView/agendaSkeletonList.dart';

class FavouriteSessionPage extends GetView<FavSessionController> {
  bool isFromBookmarkSection = false;

  FavouriteSessionPage({super.key, required this.isFromBookmarkSection});

  static const routeName = "/MySessionList";
  final SessionController sessionController = Get.find();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 0,
        title: ToolbarTitle(
          title: "myBookmark".tr,
        ),
        backgroundColor: appBarColor,
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        elevation: 0,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: GetX<FavSessionController>(
        builder: (controller) {
          return Container(
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 18.adaptSize),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          key: refreshIndicatorKey,
                          color: colorLightGray,
                          backgroundColor: colorPrimary,
                          strokeWidth: 1.0,
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          onRefresh: () async {
                            return Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                controller.getBookmarkSession(isRefresh: true);
                              },
                            );
                          },
                          child: buildListView(context),
                        ),
                      )
                    ],
                  ),
                  _progressEmptyWidget(),
                ],
              ));
        },
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isFirstLoading.value,
      child: controller.isFirstLoading.value
          ? const SessionListSkeleton()
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 0,
                );
              },
              itemCount: controller.favouriteSessionList.length,
              itemBuilder: (context, index) {
                return SessionListBody(
                  isFromBookmark: true,
                  session: controller.favouriteSessionList[index],
                  index: index,
                  size: controller.favouriteSessionList.length,
                );
              },
            ),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value || sessionController.loading.value
          ? const Loading()
          : controller.favouriteSessionList.isEmpty &&
                  !controller.isFirstLoading.value
              ? ShowLoadingPage(refreshIndicatorKey: refreshIndicatorKey)
              : const SizedBox(),
    );
  }
}
