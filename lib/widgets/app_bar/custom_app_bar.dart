import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_helper.dart';

enum Style { bgOutline, bgFill }

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions,
      this.backgroundColor,
      this.dividerHeight})
      : super(
          key: key,
        );

  final double? height;

  final Style? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;
  final Color? backgroundColor;
  final double? dividerHeight;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: dividerHeight != 0
          ? Border(
              bottom:
                  BorderSide(color: indicatorColor, width: dividerHeight ?? 0)
      )
          : null,
      toolbarHeight: height ?? 86.v,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? appBarColor,
      flexibleSpace: _getStyle(),
      iconTheme: const IconThemeData(color: colorSecondary),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 86.v,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgOutline:
        return Container(
          height: 86.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: appTheme.gray100,
                width: 1.h,
              ),
            ),
          ),
        );
      case Style.bgFill:
        return Container(
          height: 1.v,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 86.v),
          decoration: BoxDecoration(
            color: appTheme.gray100,
          ),
        );
      default:
        return null;
    }
  }
}
