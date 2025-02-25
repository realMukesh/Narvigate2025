import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/skeletonView/userBodySkeleton.dart';
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

class SearchUserPage extends GetView<GlobalSearchController> {
  SearchUserPage({super.key});

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final userController = Get.put(UserDetailController());

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
    controller.getSearchUserApi(isRefresh: true);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value ||
              userController.isLoading.value ||
              (controller.isFirstLoadRunning.value &&
                  controller.userList.isEmpty)
          ? const Loading()
          : controller.userList.isEmpty && !controller.isFirstLoadRunning.value
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
                itemCount: controller.userList.length,
                itemBuilder: (context, index) =>
                    buildChildMenuBody(controller.userList[index]),
              ));
  }

  Widget buildChildMenuBody(dynamic representatives) {
    return UserListWidget(
      representatives: representatives,
      isFromBookmark: false,
      isFromSearch: true,
      press: () async {
        controller.isLoading(true);
        await userController.getUserDetailApi(
            representatives.id, representatives.role);
        controller.isLoading(false);
      },
    );
  }
}
