import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 40.v,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle,
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}

class CommonMenuButton extends StatelessWidget {
  final Function onTap;
  final Color color,borderColor;
  final double height;
  final double borderWidth;
  final double borderRadius;
  final Widget widget;

  const CommonMenuButton({
    Key? key,
    required this.onTap,
    required this.widget,
    this.color = colorPrimary,
    this.borderColor = colorLightGray,
    this.borderWidth = 0.0,
    this.borderRadius=20,
    this.height = 90,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      //height: height,
      width: context.width,
      child: MaterialButton(
        elevation: 0.3,
        color: color,
        hoverColor: colorSecondary,
        padding: EdgeInsets.symmetric(horizontal: 4.v),
        //animationDuration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(width: borderWidth, color: borderColor)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            onTap();
          });
        },
        child: widget,
      ),
    );
  }
}
