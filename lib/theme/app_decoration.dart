import 'package:dreamcast/theme/theme_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';

import '../routes/my_constant.dart';
import '../widgets/customTextView.dart';
import 'app_colors.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => const BoxDecoration(
        color: colorLightGray,
      );
  static commonHorizontalPadding() {
    return const EdgeInsets.symmetric(horizontal: 12);
  }

  static commonVerticalPadding() {
    return const EdgeInsets.symmetric(vertical: 12);
  }

  static userParentPadding() {
    return const EdgeInsets.all(12);
  }

  static userChildPadding() {
    return const EdgeInsets.all(12);
  }


  static exhibitorParentPadding() {
    return const EdgeInsets.all(12);
  }

  static exhibitorChildPadding() {
    return const EdgeInsets.all(12);
  }

  static editBoxGradientBorder() {
    return const GradientOutlineInputBorder(
        width: 1,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(colors: [aiColor1, aiColor2]));
  }

  static commonTabPadding() {
    return const EdgeInsets.only(top: 8);
  }

  static shortNameImageDecoration() {
    return BoxDecoration(
      color: white,
      shape: BoxShape.circle,
      border: Border.all(
        color: colorLightGray,
        width: 5.0,
      ),
    );
  }


  static editFieldDecoration({required createFieldBody}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: "${createFieldBody.label}",
      hintText: createFieldBody.placeholder ?? "",
      hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: Colors.white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderEditColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }

  static editFieldDecorationDropdown({required createFieldBody}) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      labelText: "${createFieldBody.label}",
      hintText: "",
      hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: Colors.white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderEditColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: colorSecondary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderEditColor)),
    );
  }

  static editFieldDecorationArea({
    required String label,
    required String placeHolder,
    required Color color,
  }) {
    return InputDecoration(
      counter: const Offstage(),
      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      hintText: placeHolder,
      hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
          fontSize: 15.fSize, color: colorGray, fontWeight: FontWeight.normal),
      fillColor: Colors.white,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderEditColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black)),
    );
  }

  static outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black));
  }

  static gradientIcon({url}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientBegin, gradientEnd],
        ).createShader(bounds);
      },
      child: Image.asset(
        url,
        width: 35,
        color: colorSecondary,
      ),
    );
  }

  static recommendedDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      /*image: const DecorationImage(
          image: AssetImage("assets/images/recommended_tag.png"))*/
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[aiColor1, aiColor2],
      ),
    );
  }

  static speakerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorPrimary, colorPrimary],
      ),
    );
  }

  static commonDecoration() {
    return const BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(10)));
  }

  static Widget commonLabelTextWidget(String label) {
    return CustomTextView(
      text: label,
      color: colorSecondary,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.start,
      maxLines: 2,
    );
  }

  static getDecoration() {
    return const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)));
  }

  static getDecorationAllCorner({borderColor}) {
    return BoxDecoration(
        color: borderColor,
        borderRadius: const BorderRadius.all(Radius.circular(6)));
  }

  static getDecorationAgenda({borderColor}) {
    return BoxDecoration(
        color: borderColor,
        borderRadius: const BorderRadius.all(Radius.circular(6)));
  }

  static getDecorationForDate() {
    return const BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.all(Radius.circular(6)));
  }

  static getDecorationInvestorForDate() {
    return const BoxDecoration(
        color: white, borderRadius: BorderRadius.all(Radius.circular(6)));
  }

  static getDecorationTab() {
    return const BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.all(Radius.circular(50)));
  }

  static BoxDecoration get filterTop => BoxDecoration(
      color: appTheme.white,
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)));

  static BoxDecoration get decorationAddEvent => BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: colorGray, width: 0.8),
      borderRadius: const BorderRadius.all(Radius.circular(20)));

  static BoxDecoration get decorationActionButton => BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: colorSecondary, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(16)));

  // Gradient decorations
  static BoxDecoration get gradientBlackToBlack => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.38, 1),
          end: const Alignment(0.38, 0),
          colors: [
            appTheme.black900,
            appTheme.black900.withOpacity(0),
          ],
        ),
      );

  // Fill decorations
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
// Gradient decorations
  static BoxDecoration get gradientBlueAToGreenA => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0),
          end: const Alignment(1, 0),
          colors: [appTheme.blueA200, appTheme.greenA400],
        ),
      );
  static BoxDecoration get gradientBlueAToGreenA400 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.01, 0.08),
          end: const Alignment(1.12, 1.37),
          colors: [appTheme.blueA200, appTheme.greenA400],
        ),
      );
// Grey decorations
  static BoxDecoration get greyBoxF4F3F7 => BoxDecoration(
        color: appTheme.gray10001,
      );
// Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 10.h,
            offset: const Offset(
              0,
              0,
              // -3,
            ),
          )
        ],
      );
  static BoxDecoration get outlineBlueA => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.blueA200,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineDeepOrange => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.deepOrange400,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.gray10001,
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray300 => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray3001 => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOrange => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.orange300,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: appTheme.gray10001,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL10 => BorderRadius.horizontal(
        left: Radius.circular(10.h),
      );
  static BorderRadius get customBorderTL18 => BorderRadius.vertical(
        top: Radius.circular(18.h),
      );
// Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder14 => BorderRadius.circular(
        14.h,
      );
  static BorderRadius get roundedBorder34 => BorderRadius.circular(
        34.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
}
