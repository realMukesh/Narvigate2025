import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/userListBody.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/loadMoreItem.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/showLoadingPage.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../../skeletonView/userBodySkeleton.dart';
import '../controller/exhibitorsController.dart';

class BootUserListPage extends GetView<BootController> {
  static const routeName = "/BootUserListPage";
  dynamic showAppbar = true;
  BootUserListPage({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  final DashboardController dashboardController = Get.find();

  //@override
  //final controller = Get.put(BootController(), permanent: false);
  String role = MyConstant.attendee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 60,
        title: ToolbarTitle(
          title: "team".tr.capitalize ?? "",
          color: Colors.black,
        ),
        shape: Border(
            bottom:
                BorderSide(color: indicatorColor, width: showAppbar ? 0.3 : 0)),
        elevation: 0,
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: buildTabFirst(context),
    );
  }

  Widget buildTabFirst(BuildContext context) {
    return GetX<BootController>(builder: (controller) {
      return Container(
        color: Colors.transparent,
        width: context.width,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /*CustomSearchView(
                  hideFilter: true,
                  title: MyStrings.attendee,
                  textController: controller.textController,
                  press: () async {},
                  onSubmit: (result) async {
                    if (result.isNotEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      callUserListAPi(search: result, isRefresh: false);
                    }
                  },
                  onClear: (result) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _refreshTab1Key.currentState?.show();
                  },
                ),*/
                Expanded(
                    child: RefreshIndicator(
                  key: _refreshTab1Key,
                  onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () async {
                        callUserListAPi(search: "", isRefresh: true);
                        //controller.getFilter();
                      },
                    );
                  },
                  child: buildChildList(context),
                )),
                // when the _loadMore function is running
                controller.isLoadMoreRunning.value
                    ? const LoadMoreLoading()
                    : const SizedBox()
              ],
            ),
            _progressEmptyWidget()
          ],
        ),
      );
    });
  }

  callUserListAPi({required String search, required isRefresh}) async {
    var body = {"id": controller.exhibitorsBody.value.id};
    await controller.getExhibitorsRepresentatives(requestBody: body);
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.representativesList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
              : const SizedBox(),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: controller.isFirstLoadRunning.value
            ? const UserListSkeleton()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.userScrollController,
                itemCount: controller.representativesList.length,
                itemBuilder: (context, index) => buildListViewBody(
                    controller.representativesList[index], context),
              ));
  }

  _openUserDetail({userId, role}) async {
    final reController = Get.put(UserDetailController(), permanent: false);
    controller.isLoading(true);
    await reController.getUserDetailApi(userId, role);
    controller.isLoading(false);
    //Get.toNamed(UserDetailPage.routeName);
  }

  Widget buildListViewBody(dynamic representatives, BuildContext context) {
    return UserListWidget(
      representatives: representatives,
      isFromBookmark: false,
      press: () {
        _openUserDetail(userId: representatives.id, role: representatives.role);
      },
    );
  }

  Widget circularImage({url, shortName}) {
    return url.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(left: 15),
            child: FittedBox(
              fit: BoxFit
                  .fill, // the picture will acquire all of the parent space.
              child: CircleAvatar(backgroundImage: NetworkImage(url)),
            ),
          )
        : Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(color: colorSecondary, width: 1),
              shape: BoxShape.circle,
              color: white,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName,
              fontSize: 28,
              textAlign: TextAlign.center,
            )),
          );
  }

  Widget circularParentImage({url, shortName}) {
    return url.isNotEmpty
        ? FittedBox(
            fit: BoxFit
                .fill, // the picture will acquire all of the parent space.
            child: SizedBox(
                height: 80,
                width: 80,
                child: CircleAvatar(backgroundImage: NetworkImage(url))),
          )
        : Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: colorLightGray,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName,
              textAlign: TextAlign.center,
            )),
          );
  }
}
