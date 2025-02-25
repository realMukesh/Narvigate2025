import 'package:dreamcast/view/beforeLogin/splash/model/config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/routes/app_pages.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/dashboard_page.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';

class SplashController extends GetxController {
  AuthenticationManager? authenticationManager;
  ConfigModel? model = ConfigModel();
  var loading = true.obs;

  @override
  void onInit() {
    initialCall();
    super.onInit();
  }

  initialCall() async {
    print(AppUrl.splashDynamicImage);
    authenticationManager = Get.find<AuthenticationManager>();
    Future.delayed(const Duration(seconds: 0), () {
      getConfigDetail();
    });
  }

  Future<void> getConfigDetail() async {
    loading(true);
    model = await apiService.getConfigInit();
    try {
      if (model?.status == true && model?.code == 200) {
        authenticationManager?.configModel = model!;

        final firebase = model?.body?.config?.firebase;
        final meta = model?.body?.meta;

        AppUrl.setDefaultFirebaseNode = firebase?.name?.toLowerCase() ?? "";
        AppUrl.setTopicName = firebase?.topics?.all?.toString() ?? "";
        AppUrl.setDataBaseUrl = firebase?.configs?.databaseURL ?? "";
        AppUrl.appName = meta?.title ?? "";

        print("===>${AppUrl.defaultFirebaseNode}");
        print(AppUrl.topicName);
        print(AppUrl.dataBaseUrl);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
      update();
      nextScreen();
    }
  }

  nextScreen() async {
    Future.delayed(const Duration(seconds: 3), () {
      if (authenticationManager!.isLogin()) {
        Future.delayed(
          const Duration(milliseconds: 600),
          () {
            Get.offNamedUntil(DashboardPage.routeName, (route) => false);
          },
        );
      } else {
        Get.offAndToNamed(Routes.LOGIN);
      }
      //Get.offAndToNamed(Routes.LOGIN);
    });
  }
}
