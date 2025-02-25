
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/button/rounded_button.dart';

class NeedToLogin extends StatelessWidget {
  const NeedToLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: colorSecondary),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          child: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset(ImageConstant.bg_logo_icon),
                        )
                      ],
                    ), /* add child content here */
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                    child: CustomTextView(
                      text: "welcome_title".tr,
                      fontSize: 30,
                      color: colorSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                    child: CustomTextView(
                      text: "welcome_subtitle".tr,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      maxLines: 2,color: colorSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                    child: ProfileButton(
                        color: colorSecondary,
                        text: "sign".tr,
                        press: () {
                          Get.toNamed(Routes.LOGIN);
                        }),
                  ),
                ],
              )
          )
      ),
    );
  }
}
