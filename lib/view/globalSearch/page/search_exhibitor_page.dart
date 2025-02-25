import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:dreamcast/view/globalSearch/controller/globleSearchController.dart';
import 'package:dreamcast/view/skeletonView/gridViewSkeleton.dart';
import 'package:dreamcast/widgets/loadMoreItem.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/exhibitors/view/bootListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../dashboard/showLoadingPage.dart';


class SearchExhibitorPage extends GetView<GlobalSearchController> {
  SearchExhibitorPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final bootController = Get.put(BootController());
  final textController = TextEditingController().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        color: Colors.transparent,
        width: context.width,
        padding: AppDecoration.userParentPadding(),
        child: GetX<GlobalSearchController>(builder: (controller) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: RefreshIndicator(
                          backgroundColor: colorSecondary,
                          key: _refreshIndicatorKey,
                          child: buildChildList(context),
                          onRefresh: () {
                            return Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                refreshListAPi(search: "");
                              },
                            );
                          })),
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
                  // when the _loadMore function is running
                ],
              ),
              // when the first load function is running
              _progressEmptyWidget()
            ],
          );
        }),
      ),
    );
  }

  refreshListAPi({required String search}) {
    controller.getSearchExhibitorsApi();
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value || controller.isLoading.value
          ? const Loading()
          : controller.exhibitorsMatchesList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: _refreshIndicatorKey,
                )
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const BootViewSkeleton()
            : GridView.builder(
                controller: controller.exhibitorScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.exhibitorsMatchesList.length,
                itemBuilder: (context, index) =>
                    buildChildMenuBody(controller.exhibitorsMatchesList[index]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 10,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15)));
  }

  Widget buildChildMenuBody(Exhibitors exhibitors) {
    return GestureDetector(
      onTap: () async {
        controller.isLoading(true);
        await bootController.getExhibitorsDetail(exhibitors.id);
        controller.isLoading(false);
      },
      child: BootListBody(
        isFromSearch: true,
        exhibitor: exhibitors,
        isBookmark: true,
      ),
    );
  }
}
