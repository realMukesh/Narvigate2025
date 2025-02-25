import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'customTextView.dart';

class FoundationalTrackWidget extends StatelessWidget {
  String? title;
  Color? color;
  FoundationalTrackWidget({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 5.v, bottom: 5.v,),
      decoration: BoxDecoration(
          color: title == "General" ? const Color(0xff4658A7) : color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Align(
        alignment: Alignment.center,
        child: CustomTextView(
          text: title ?? "General",
          color: white,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
