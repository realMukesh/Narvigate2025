import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../view/account/controller/account_controller.dart';
import '../view/account/view/account_page.dart';

class CustomProfileImage extends StatelessWidget {
  String shortName;
  String profileUrl;
  bool? isAiProfile;
  Color borderColor;
  bool isAccountPage;

  CustomProfileImage(
      {super.key,
      required this.shortName,
      required this.profileUrl,
      this.isAiProfile,
      required this.borderColor,
      required this.isAccountPage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if(isAccountPage){
              return;
            }
            if (Get.isRegistered<AccountController>()) {
              AccountController controller = Get.find();
              controller.callDefaultApi();
            }
            Get.toNamed(AccountPage.routeName);
          },
          child: Container(
            padding: EdgeInsets.all(6.adaptSize),
            height: 105.adaptSize,
            width: 105.adaptSize,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: gray.withOpacity(0.1),blurRadius: 4.0,spreadRadius: 1.0)]
                // gradient: LinearGradient(
                //   colors: [
                //     aiColor1,
                //     aiColor2,
                //   ],
                // ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: white,
              ),
              child: CachedNetworkImage(
                imageUrl: profileUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Center(
                    child: CustomTextView(
                  text: shortName ?? "",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
        ),
        isAiProfile != null && isAiProfile == true
            ? Positioned(
                bottom: 6,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          aiColor1,
                          aiColor2,
                        ],
                      )),
                  child: SvgPicture.asset(ImageConstant.icAIStart),
                ))
            : const SizedBox()
      ],
    );
  }
}
