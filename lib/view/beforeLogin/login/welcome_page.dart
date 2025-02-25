import 'package:dreamcast/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';

import '../../../widgets/button/rounded_button.dart';
import '../../../widgets/button/rounded_outline_button.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "/WelcomePage";

  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget fdfsf(){
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50.0),
                topLeft: Radius.circular(50.0))),
        padding: const EdgeInsets.all(MyConstant.default_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30,),
            ProfileButton(text: "Sign In",press: (){
              Get.toNamed(Routes.LOGIN);

            },),

            RoundedOutlineButton(text: "enter_as_guest".tr, press: (){
              Get.toNamed(DashboardPage.routeName);
            },),

            CustomTextView(text:  "enter_as_guest".tr),

          ],
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body:Container(
          alignment: Alignment.topCenter,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                color: bgColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 0),
                        height: 250,
                        color: bgColor,
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(ImageConstant.bg_logo,
                                height: 60))),
                  fdfsf()
                  ],
                ),
              ),
            ],
          )
        )
    );


  }
}
