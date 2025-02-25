import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowLoadingPage extends StatelessWidget {
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  String? message;
  String? title;
  String? iconUrl;
  ShowLoadingPage(
      {Key? key,
      required this.refreshIndicatorKey,
      this.message,
      this.title,
      this.iconUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromRGBO(244, 243, 247, 1),
                ),
                child: Image.asset(
                  (iconUrl?.isNotEmpty ?? false)
                      ? iconUrl!
                      : ImageConstant.noData,
                  scale: 2.5,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CustomTextView(
                text:
                    (title?.isNotEmpty ?? false) ? title! : "no_data_found".tr,
                color: colorSecondary, // Adjust text color if needed
                fontSize: 22,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextView(
                text:
                (message?.isNotEmpty ?? false) ? message! : "no_data_found_description".tr,
                color: colorSecondary, // Adjust text color if needed
                fontSize: 16,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
