import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/toolbarTitle.dart';
import '../controller/exhibitorsController.dart';

class GalleryListPage extends GetView<BootController> {
  GalleryListPage({Key? key}) : super(key: key);
  static const routeName = "/GalleryListPage";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  ToolbarTitle(
          title: "image".tr,
          color: Colors.black,
        ),
        elevation: 0,
        shape: const Border(
            bottom: BorderSide(
                color: indicatorColor,
                width: 1
            )
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: Container(
          padding: const EdgeInsets.all(12),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: colorLightGray,
            backgroundColor: colorPrimary,
            strokeWidth: 1.0,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              return Future.delayed(
                const Duration(seconds: 1),
                () {
                  //controller.getNotificationList();
                },
              );
            },
            child: buildListView(context),
          )),
    );
  }

  Widget buildListView(BuildContext context) {
    return /*ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
          child: Container(
            color: Colors.white,
          ),
        );
      },
      itemCount: controller.exhibitorsBody.value.gallery!
          .value?.length??0,
      itemBuilder: (context, index) {
        return Container(
          width: context.width,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(image: NetworkImage(
            controller.exhibitorsBody.value?.gallery.value![index]),fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        );
      },
    )*/const Text("gallery");
  }
}
