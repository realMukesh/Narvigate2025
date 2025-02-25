import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_decoration.dart';

class CommonMaterialButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color, textColor, borderColor;
  final double textSize;
  final double height;
  final double radius;
  final bool showIcon;
  final double borderWidth;
  final FontWeight weight;
  final String? svgIcon;
  final double? iconHeight;

  const CommonMaterialButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = colorSecondary,
      this.textColor = Colors.white,
      this.textSize = 20,
      this.showIcon = false,
      this.height = 55,
      this.radius = 10,
      this.svgIcon,
      this.borderWidth = 0,
      this.borderColor = Colors.transparent,
      this.iconHeight,
      this.weight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, svgIcon != null ? 0 : 10),
      width: size.width,
      height: height,
      child: MaterialButton(
          elevation: 0,
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: borderWidth, color: borderColor),
              borderRadius: BorderRadius.circular(radius)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              onPressed();
            });
          },
          child: svgIcon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      svgIcon.toString(),
                      height: iconHeight ?? 12.adaptSize,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    CustomTextView(
                      text: text,
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: weight,
                    )
                  ],
                )
              : CustomTextView(
                  text: text,
                  color: textColor,
                  fontSize: textSize,
                  fontWeight: weight,
                )),
    );
  }
}

class CommonChatButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color, textColor;
  final double textSize;
  final double height;
  final double radius;
  final bool showIcon;
  final FontWeight weight;
  final String? svgIcon;
  final double? iconHeight;

  const CommonChatButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = colorSecondary,
      this.textColor = Colors.white,
      this.textSize = 20,
      this.showIcon = false,
      this.height = 55,
      this.radius = 10,
      this.svgIcon,
      this.iconHeight,
      this.weight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, svgIcon != null ? 0 : 10),
      width: size.width,
      height: height,
      child: MaterialButton(
          elevation: 0,
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              onPressed();
            });
          },
          child: svgIcon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      svgIcon.toString(),
                      height: iconHeight ?? 12.adaptSize,
                      color: white,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomTextView(
                      text: text,
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                )
              : CustomTextView(
                  text: text,
                  color: textColor,
                  fontSize: textSize,
                  fontWeight: FontWeight.w400,
                )),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double height;
  final bool showIcon;
  final FontWeight weight;

  const ProfileButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = Colors.white,
      this.textSize = 14,
      this.showIcon = false,
      this.height = 45,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: 160,
      height: height,
      decoration: AppDecoration.getDecorationAllCorner(borderColor: color),
      child: MaterialButton(
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextView(
                text: text,
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              /*Icon(Icons.arrow_forward_ios,size: 13,color: Colors.white,)*/
            ],
          )),
    );
  }
}

class MyRoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double height;
  final bool showIcon;
  final FontWeight weight;

  const MyRoundedButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = Colors.white,
      this.textSize = 14,
      this.showIcon = false,
      this.height = 50,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width*.40,
      decoration: AppDecoration.getDecorationAllCorner(borderColor: color),
      child: MaterialButton(
        height: height,
          splashColor: Colors.transparent,
          animationDuration: const Duration(seconds: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: CustomTextView(
            text: text,
            color: textColor,
            fontSize: textSize,
            fontWeight: FontWeight.w400,
            /*weight: weight,*/
          )),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String text;
  final String subText;
  final Function press;
  final Color color, textColor;
  final double height;
  final String iconPath;
  final bool showCount;
  final int count;

  const DashboardButton({
    Key? key,
    required this.text,
    required this.subText,
    required this.press,
    this.color = colorSecondary,
    this.textColor = black,
    this.height = 90,
    required this.iconPath,
    this.showCount = false,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: height,
      width: context.width,
      child: MaterialButton(
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: dividerColor, width: 1)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  iconPath,
                  height: 50,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextView(
                      text: text,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                      color: textColor),
                  const SizedBox(
                    width: 6,
                  ),
                  CustomTextView(
                      text: subText,
                      textAlign: TextAlign.start,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      color: textColor)
                ],
              )
            ],
          )),
    );
  }
}
