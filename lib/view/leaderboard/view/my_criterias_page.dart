import 'dart:ui';

import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/skeleton_event_feed.dart';
import '../controller/leaderboard_controller.dart';
import '../model/leaderboard_model.dart';

class CriteriasPage extends GetView<LeaderboardController> {
  CriteriasPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final LeaderboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
          padding: const EdgeInsets.all(12),
          child: GetX<LeaderboardController>(builder: (controller) {
            return Stack(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: colorPrimary,
                  strokeWidth: 2.0,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getLeaderboard(isRefresh: true);
                      },
                    );
                  },
                  child: buildListView(context),
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          })),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.leaderBoardData.value.criteria != null &&
                  controller.leaderBoardData.value.criteria!.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    var pointsList = controller.leaderBoardData.value.criteria ?? [];
    return Skeletonizer(
      enabled: controller.isFirstLoadRunning.value,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 0),
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 4,
            ),
          );
        },
        itemCount: controller.isFirstLoadRunning.value ? 5 : pointsList.length,
        itemBuilder: (context, index) {
          if (controller.isFirstLoadRunning.value) {
            return listChildWidget(
                Criteria(name: "Hello this is dummy text \n Hello "));
          }
          Criteria points = pointsList[index];
          return listChildWidget(points);
        },
      ),
    );
  }

  listChildWidget(Criteria points) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomTextView(
        text: points.name ?? "",
        color: colorPrimaryDark,
        maxLines: 3,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.start,
      ),
      trailing: Container(
        width: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: colorLightGray),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                text: points.point.toString() ?? "",
                color: colorPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              const CustomTextView(
                text: "Points",
                color: colorGray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
