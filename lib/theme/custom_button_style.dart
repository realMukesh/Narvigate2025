import 'package:dreamcast/theme/theme_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Outline button style
  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: BorderSide(
      color: appTheme.gray300.withOpacity(0.34),
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26.h),
    ),
  );
  static ButtonStyle get outlineOnPrimary => OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    side: BorderSide(
      color: theme.colorScheme.onPrimary,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
  );
  static ButtonStyle get outlinePrimaryContainer => OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    side: BorderSide(
      color: theme.colorScheme.primaryContainer,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.h),
    ),
  );
  static ButtonStyle get outlinePurple => OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    side: BorderSide(
      color: appTheme.purple300,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.h),
    ),
  );
// text button style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
  );
}
