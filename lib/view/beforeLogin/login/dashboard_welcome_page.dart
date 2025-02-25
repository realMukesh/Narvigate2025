import 'package:dreamcast/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/routes/app_pages.dart';
import '../../../widgets/button/rounded_button.dart';

class DashboardWelcomePage extends StatelessWidget {
  static const routeName = "/WelcomePage";

  const DashboardWelcomePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: const EdgeInsets.all(22),
          height: context.height,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100,),
              Align(
                  alignment: Alignment.center,
                  child:  Image.asset(ImageConstant.bg_logo, height: 70)),
              const SizedBox(height: 150,),
              ProfileButton(text: "Sign In",press: (){
                Get.toNamed(Routes.LOGIN);

              },),

            ],
          ),
        )
    );
  }
}
