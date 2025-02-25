import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/exhibitors/model/exibitorsModel.dart';
import 'package:dreamcast/view/skeletonView/gridViewSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/exhibitorsController.dart';
import 'bootListBody.dart';

class BootNoteListPage extends GetView<BootController> {
  static const routeName = "/ExhibitorsNoteListPage";
  bool showAppbar = true;
  BootNoteListPage({Key? key, required this.showAppbar}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  final DashboardController dashboardController = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: ToolbarTitle(title: "exhibitors".tr),
      ),
      body: Container(
        color: bgColor,
        width: context.width,
        padding: AppDecoration.exhibitorParentPadding(),
        child: GetX<BootController>(builder: (controller) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: RefreshIndicator(
                          key: _refreshTab1Key,
                          child: buildChildList(context),
                          onRefresh: () {
                            return Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                callBootAPi(search: "", isRefresh: true);
                                controller.getAndResetFilter(isRefresh: false);
                              },
                            );
                          })),
                  // when the _loadMore function is running
                  controller.isLoadMoreRunning.value
                      ? const LoadMoreLoading()
                      : const SizedBox()
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

  callBootAPi({required String search, required isRefresh}) async {
    var body = {
      "page": "1",
      "filters": {"sort": "ASC", "text": search, "params": {},"notes": controller.isEditNotes.value},
    };
    await controller.getExhibitorsList(isRefresh: isRefresh);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.exhibitorsList.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const BootViewSkeleton()
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: controller.exhibitorsList.length,
                itemBuilder: (context, index) => buildChildMenuBody(
                    controller.exhibitorsList[index], context),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 10,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15)));
  }

  Widget buildChildMenuBody(Exhibitors exhibitors, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!authenticationManager.isLogin()) {
          DialogConstant.showLoginDialog(context, authenticationManager);
          return;
        }
        controller.getExhibitorsDetail(exhibitors.id);
      },
      child: BootListBody(exhibitor: exhibitors, isBookmark: false),
    );
  }
}
