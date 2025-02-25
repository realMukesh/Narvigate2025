import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';

class MyPointsPage extends StatelessWidget {
  const MyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextView(
                      text: 'Visiting Partner Booth',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colorLightGray,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Column(
                      children: [
                        CustomTextView(
                          text: '1000',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorPrimary,
                        ),
                        CustomTextView(
                          text: 'Points',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorGray,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
