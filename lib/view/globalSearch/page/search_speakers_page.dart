import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/skeletonView/userBodySkeleton.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/representatives/controller/user_detail_controller.dart';
import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/globleSearchController.dart';

class SearchSpeakerPage extends GetView<GlobalSearchController> {
  SearchSpeakerPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final userController = Get.put(SpeakersDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: GetX<GlobalSearchController>(builder: (controller) {
        return Container(
          color: Colors.transparent,
          width: context.width,

          padding: AppDecoration.commonVerticalPadding(),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: colorSecondary,
                      key: _refreshIndicatorKey,
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(seconds: 1),
                              () {
                            refreshListApi();
                          },
                        );
                      },
                      child: buildChildList(context),
                    ),
                  ),
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
                  // when the _loadMore function is running
                ],
              ),
              _progressEmptyWidget()
            ],
          ),
        );
      }),
    );
  }

  refreshListApi() {
    controller.getSearchSpeakerApi(isRefresh: true);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value ||
          userController.isLoading.value ||
          (controller.isFirstLoadRunning.value &&
              controller.speakerList.isEmpty)
          ? const Loading()
          : controller.speakerList.isEmpty && !controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
          : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const UserListSkeleton()
            : ListView.builder(
          controller: controller.userScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.speakerList.length,
          itemBuilder: (context, index) =>
              buildChildMenuBody(controller.speakerList[index]),
        ));
  }

  Widget buildChildMenuBody(dynamic representatives) {
    return UserListWidget(
      representatives: representatives,
      isFromBookmark: false,
      isFromSearch: true,
      press: () async {
        controller.isLoading(true);
        await userController.getSpeakerDetail(
            speakerId: representatives.id,
            role: representatives.role,
            isSessionSpeaker: true);
        controller.isLoading(false);
        },
    );
  }
}

/*
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/globalSearch/controller/globleSearchController.dart';
import 'package:dreamcast/view/skeletonView/userBodySkeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_decoration.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/gradient_text_view.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../skeletonView/speakerBodySkeleton.dart';
import '../../speakers/controller/speakersController.dart';
import '../../speakers/model/speakersModel.dart';
import '../../speakers/view/speakerListBody.dart';

class SearchSpeakerPage extends GetView<GlobalSearchController> {
  SearchSpeakerPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final DashboardController dashboardController = Get.find();
  var speakersController = Get.put(SpeakersController());
  String role = MyConstant.speakers;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      role = Get.arguments["role"];
    }
    return Scaffold(
      backgroundColor: bgColor,
      body: speakerTabView(context),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.speakerList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget speakerTabView(BuildContext context) {
    return GetX<GlobalSearchController>(builder: (controller) {
      return Container(
        color: Colors.transparent,
        width: context.width,
        height: context.height,
        padding: AppDecoration.commonVerticalPadding(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: RefreshIndicator(
                  backgroundColor: colorPrimary,
                  key: _refreshIndicatorKey,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        controller.getSearchSpeakerApi(isRefresh: true);
                      },
                    );
                  },
                  child: buildListview(context),
                )),
                controller.isLoadMoreRunning.value
                    ? const LoadMoreLoading()
                    : const SizedBox()
                // when the _loadMore function is running
              ],
            ),
            _progressEmptyWidget()
          ],
        ),
      );
    });
  }

  Widget buildListview(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const SpeakerListSkeleton()
            : ListView.builder(
                controller: controller.speakerScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.speakerList.length,
                itemBuilder: (context, index) =>
                    buildListBody(controller.speakerList[index]),
              ));
  }

  Widget buildListBody(SpeakersData representatives) {
    return InkWell(
      onTap: () async {
        controller.isLoading(true);
        await speakersController.getSpeakerDetail(
            speakerId: representatives.id ?? "",
            role: representatives.role,
            isSessionSpeaker: false);
        controller.isLoading(false);
      },
      child:
          SpeakerViewWidget(speakerData: representatives, isSpeakerType: false),
    );
  }
}
*/
