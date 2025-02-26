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
import '../controller/leaderboard_controller.dart';
import '../model/leaderboard_model.dart';

class MyPointsPage extends GetView<LeaderboardController> {
  MyPointsPage({Key? key}) : super(key: key);

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
              alignment: Alignment.center,
              children: [
                controller.isFirstLoadRunning.value
                    ? const Center(child: Loading())
                    : Column(
                        children: [
                          Expanded(
                              child: RefreshIndicator(
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
                          )),
                        ],
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
                  controller.leaderBoardData.value.my?.points != null &&
                  controller.leaderBoardData.value.my!.points!.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    var pointsList = controller.leaderBoardData.value.my?.points ?? [];
    print(pointsList.length);
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 0,
              child: Container(
                color: indicatorColor,
              ),
            );
          },
          itemCount: pointsList.length,
          itemBuilder: (context, index) {
            Points points = pointsList[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: CustomTextView(
                          text:
                              "${points.name ?? ""} (${points.multiplier ?? ""})",
                          maxLines: 3,
                          color: colorPrimaryDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        )),
                        SizedBox(
                          width: 2.adaptSize,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: colorLightGray),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
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
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        height: 4,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
