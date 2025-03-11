import 'dart:io';

import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/utils/Validations.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFormField extends StatelessWidget {
  final String hintText;
  final bool isMobile;
  final int maxLength;
  final IconData icon;
  final String inputExperssion;
  final TextInputType inputType;
  final Color? enableFocusBorderColor;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction inputAction;
  final FormFieldValidator<String> validator;

  const InputFormField({
    Key? key,
    this.inputExperssion = "",
    this.isMobile = false,
    this.inputFormatters,
    this.enableFocusBorderColor,
    required this.controller,
    required this.inputAction,
    required this.inputType,
    required this.hintText,
    this.maxLength = 50,
    this.icon = Icons.person,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      controller: controller,
      textInputAction: inputAction,
      keyboardType: inputType,
      validator: validator,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters == null
          ? []
          : [
              ...?inputFormatters,
              FilteringTextInputFormatter.deny(
                  RegExp(Validations.regexToRemoveEmoji))
            ],
      style: TextStyle(
        fontSize: isMobile ? 22 : 22,
        fontFamily: MyConstant.currentFont,
      ),
      cursorColor: colorSecondary,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(isMobile ? 0 : 0, 15, 0, 0),
          filled: true,
          // Bottom border when unselected
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: enableFocusBorderColor ?? const Color(0xffC4C4C6),
              // Change this to the unselected border color you want
              width:
                  4.0, // Change this to increase the width of the bottom border when unselected
            ),
          ),
          hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
              color: hintColor,
              fontWeight: FontWeight.w600,
              fontSize: Platform.isAndroid ? 43.adaptSize : 40.adaptSize),
          hintText: hintText,
          fillColor: Colors.transparent),
    );
  }
}

class InputFormFieldMobile extends StatelessWidget {
  final String hintText;
  final bool isMobile;
  final int maxLength;
  final IconData icon;
  final String inputExperssion;
  final TextInputType inputType;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final FormFieldValidator<String> validator;
  final Color? enableFocusBorderColor;

  const InputFormFieldMobile({
    Key? key,
    this.inputExperssion = "",
    this.isMobile = false,
    required this.controller,
    required this.inputAction,
    required this.inputType,
    required this.hintText,
    this.maxLength = 50,
    this.icon = Icons.person,
    required this.validator,
    this.enableFocusBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      controller: controller,
      textInputAction: inputAction,
      //keyboardType: inputType,
      maxLength: maxLength,
      validator: validator,
      textAlign: TextAlign.center,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      //maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 32,
        fontFamily: MyConstant.currentFont,
        fontWeight: FontWeight.bold,
      ),
      cursorColor: colorSecondary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(isMobile ? 0 : 0, 15, 0, 0),
        filled: true,
        hintStyle: const TextStyle(
          color: hintColor,
          fontFamily: MyConstant.currentFont,
        ),
        hintText: hintText,
        fillColor: Colors.transparent,
        counterText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: enableFocusBorderColor ?? hintColor,
            // Change this to the unselected border color you want
            width: 4.0, // Change this to increase the width of the bottom border when unselected
          ),
        ),
      ),
    );
  }
}
