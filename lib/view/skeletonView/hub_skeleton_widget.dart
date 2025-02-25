import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/button/custom_elevated_button.dart';

class HubSkeletonWidget extends StatelessWidget {
  static const routeName = "/MenuListView";
  HubSkeletonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildParentMenuList(context),
          const SizedBox(
            height: 20,
          ),
          buildMenuList(context)
        ],
      ),
    );
  }

  buildMenuList(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => buildChildMenuBody(index, context),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
    );
  }

  // create the menu item
  buildParentMenuList(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100.h),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) => buildParentMenuBody(index, context),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15),
      ),
    );
  }

  buildParentMenuBody(int index, BuildContext context) {
    return CommonMenuButton(
      color: white,
      borderColor: indicatorColor,
      borderWidth: 1,
      borderRadius: 15,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* SvgPicture.network(
            menuData.icon ?? "",
            height: 32.h,
          ),
          const SizedBox(
            height: 10,
          ),
          AutoCustomTextView(
            text: menuData.label ?? "",
            color: colorSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),*/
        ],
      ),
      onTap: () async {},
    );
  }

  buildChildMenuBody(int index, BuildContext context) {
    return GestureDetector(
      child: CommonMenuButton(
        color: colorLightGray,
        widget: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*SvgPicture.network(
                menuData.icon ?? "",
                height: 54.h,
              ),
              SizedBox(
                height: 16.h,
              ),
              AutoCustomTextView(
                text: menuData.label ?? "",
                color: colorSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),*/
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
