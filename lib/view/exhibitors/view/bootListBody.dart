import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_boot_controller.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/exhibitors/controller/exhibitorsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/recommended_widget.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';

class BootListBody extends StatelessWidget {
  dynamic exhibitor;
  bool isBookmark;
  bool? isFromSearch;

  BootListBody(
      {super.key,
      required this.exhibitor,
      required this.isBookmark,
      this.isFromSearch});
  final BootController controller = Get.find();
  final AuthenticationManager authenticationManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: indicatorColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(15.adaptSize)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        child: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.loose,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 35.v,
                ),
                SizedBox(
                  height: 70.adaptSize,
                  width: 70.adaptSize,
                  child: Container(
                    child: UiHelper.getExhibitorImage(
                        imageUrl: exhibitor.avatar ?? ""),
                  ),
                ),
                SizedBox(
                  height: 10.v,
                ),
                Flexible(
                  child: CustomTextView(
                    text: exhibitor.fasciaName?.toString().trim() ?? "",
                    color: colorSecondary,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 6.v,
                ),
                CustomTextView(
                  text: (exhibitor.hallNumber?.toString().isNotEmpty ?? false)
                      ? "Booth No. ${exhibitor.boothNumber}"
                      : "",
                  color: colorGray,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                CustomTextView(
                  text: (exhibitor.hallNumber?.toString().isNotEmpty ?? false)
                      ? "Hall No. ${exhibitor.hallNumber}"
                      : "",
                  color: colorGray,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            isFromSearch != null && isFromSearch == true
                ? const SizedBox()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.recommendedIdsList.contains(exhibitor.id)
                                ? const Padding(
                                  padding: EdgeInsets.only(left: 0.0,bottom: 0),
                                  child: RecommendedWidget(),
                                )
                                : const SizedBox(),
                            GestureDetector(
                              onTap: () async {
                                exhibitor.isFavLoading(true);
                                await controller.bookmarkToExhibitorItem(
                                    id: exhibitor.id,
                                    itemType: "exhibitor",
                                    context: context);
                                exhibitor.isFavLoading(false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      isBookmark
                                          ? ImageConstant.bookmarkIcon
                                          : controller.bookMarkIdsList
                                                  .contains(exhibitor.id)
                                              ? ImageConstant.bookmarkIcon
                                              : ImageConstant.unBookmarkIcon,
                                      width: 14,
                                      height: 18,
                                    ),
                                    exhibitor.isFavLoading.value
                                        ? const FavLoading()
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
          ],
        ),
      ),
    );
  }
}
