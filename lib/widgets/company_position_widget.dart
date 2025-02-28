import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'customTextView.dart';

class CompanyPositionWidget extends StatelessWidget {
  String company;
  String position;
  String? association;
  CompanyPositionWidget(
      {super.key, required this.company, required this.position, this.association});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        position.isNotEmpty
            ? CustomTextView(
                maxLines: 3,
                fontSize: 16,textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
                color: colorGray,
                text: position)
            : const SizedBox(),
        company.isNotEmpty
            ? CustomTextView(
                maxLines: 3,
                fontSize: 16,textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                color: colorGray,
                text: company)
            : const SizedBox(),
        (association ?? "").isNotEmpty
            ? CustomTextView(
                maxLines: 3,
                fontSize: 16,textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                color: colorGray,
                text: association ?? "")
            : const SizedBox(),
      ],
    );
  }
}
