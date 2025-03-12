import 'dart:async';
import 'dart:io';
import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/view/storage/cache_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_repository/app_url.dart';
import '../../../fcm/push_notification_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/pref_utils.dart';
import '../splash/model/config_model.dart';
import '../../../api_repository/api_service.dart';

class AuthenticationManager extends GetxController with CacheManager {
  var iosAppVersion = 14;
  var _currAppVersion = "";
  get currAppVersion => _currAppVersion;

  final isLogged = false.obs;
  final loading = false.obs;
  final isRemember = false.obs;
  ConfigModel _configModel = ConfigModel();
  late String _osName;
  late FirebaseMessaging _firebaseMessaging;
  var tokenExpired = false;
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  late final FirebaseDatabase _firebaseDatabase;
  FirebaseDatabase get firebaseDatabase => _firebaseDatabase;
  var showBadge = false.obs;
  var isMuteNotification = false.obs;
  late final SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  String _platformVersion = "";
  late String _dc_device = "tablet";

  String get dc_device => _dc_device;

  String get platformVersion => _platformVersion;

  String get osName => _osName;
  ConfigModel get configModel => _configModel;
  String pageName = "";
  String pageId = "";
  var notificationNode = {};
  var showWelcomeDialog = false;
  var showForceUpdateDialog = false.obs;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  set configModel(ConfigModel value) {
    _configModel = value;
    update();
  }

  @override
  onInit() async {
    super.onInit();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseDatabase = FirebaseDatabase.instance;
    fcmSubscribe();
    getInitialInfo();
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
  }

  @override
  void onReady() {
    super.onReady();
    getFcmTokenFrom();
    initSharedPref();
    checkTheInternet();
  }

  void checkUpdate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIos();
      }
    });
  }

  Future<void> getConfigDetail() async {
    ConfigModel model = await apiService.getConfigInit();
    if (model.status! && model.code == 200) {
      configModel = model;
    }
  }

  Future<void> deleteYourAccount() async {
    loading(true);
    CommonModel? model =
        await apiService.commonGetRequest(AppUrl.deleteAccount);
    loading(false);
    if (model.status! && model.code == 200) {
      UiHelper.showSuccessMsg(null, model?.message ?? "");
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }
  }

  //used for the logout the session from the server
  Future<void> logoutTheUserAPi() async {
    loading(true);
    CommonModel? model = await apiService.commonGetRequest(AppUrl.logoutApi);
    loading(false);
    if (model.status! && model.code == 200) {
      PrefUtils().setToken("");
      //_firebaseMessaging.unsubscribeFromTopic(AppUrl.topicName);
      await FirebaseAuth.instance.signOut();
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    } else {
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    }
  }

  void fcmSubscribe() {
    //_firebaseMessaging.subscribeToTopic(AppUrl.topicName);
    _firebaseDatabase.databaseURL = AppUrl.dataBaseUrl;
    firebaseDatabase
        .ref("${AppUrl.eventAppNode}/${AppUrl.defaultNodeName}")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        if (json["endPoint"] != null &&
            json["endPoint"].toString().isNotEmpty) {
          AppUrl.baseURLV1 = json["endPoint"];
          print("AppUrl.baseURLV1 ${AppUrl.baseURLV1}");
        }
      }
    });
    if (getAuthToken() != null && getAuthToken()!.isNotEmpty) {
      signInFirebaseByCustomToken(getAuthToken() ?? "");
    }
  }

  initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /*get device token from firebase service*/
  void getFcmTokenFrom() async {
    _firebaseMessaging.getToken().then((token) {
      saveFcmToken(token);
      print('token: $token');
    }).catchError((err) {
      print("This is bug from FCM${err.message.toString()}");
    });
  }

  bool isLogin() {
    if (PrefUtils().getToken().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  getInitialInfo() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    _dc_device = data.size.shortestSide < 600 ? 'mobile' : 'tablet';

    print("_dc_device$_dc_device");

    _osName = Platform.isAndroid ? "android" : "ios";
  }

  Future<void> adFcmDeviceToken(String token) async {
    var loginRequest = {
      //"device_id": Platform.isAndroid ? "android" : "ios",
      "registration_token": token ?? ""
    };
    print(loginRequest);
    CommonModel loginResponseModel =
        await apiService.commonPostRequest(loginRequest, AppUrl.updateFcm);
  }

  signInFirebaseByCustomToken(customToken) async {
    print('customToken :$customToken');
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
      refreshTheFirebaseToken();
      print("Sign-in successful.");
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      switch (e.code) {
        case "invalid-custom-token":
          print("501 The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("501  The supplied token is for a different Firebase project.");
          break;
        default:
          print("501  Unkown error.");
      }
    }
  }

  //force update..
  versionCheck() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.buildNumber.trim().replaceAll(".", ""));
    _currAppVersion = info.version.toString();
    try {
      if (double.parse(configModel.body?.flutter?.version ?? "0") >
          currentVersion) {
        await Get.dialog(
            barrierDismissible: false,
            WillPopScope(
              onWillPop: () async => false,
              child: CustomDialogWidget(
                title: "force_update_title".tr,
                logo: "",
                description: configModel.body?.flutter?.updateMessage ??
                    "force_update_msg".tr,
                buttonAction: "update_now".tr,
                buttonCancel: "cancel".tr,
                isShowBtnCancel:
                    configModel.body!.flutter!.forceDownload ?? false,
                onCancelTap: () {},
                onActionTap: () async {
                  _launchURL(configModel.body?.flutter?.playStoreUrl ??
                      "PLAY_STORE_URL".tr);
                },
              ),
            ));
        showForceUpdateDialog(true);
      } else {
        showForceUpdateDialog(false);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  versionCheckIos() async {
    try {
      _currAppVersion = iosAppVersion.toString();
      print("version ${configModel.body?.flutter?.version}");
      if (double.parse(configModel.body?.flutter?.version ?? "0") >
          iosAppVersion) {
        showForceUpdateDialog(true);
        await Get.dialog(
            barrierDismissible: false,
            WillPopScope(
              onWillPop: () async => false,
              child: CustomDialogWidget(
                title: "force_update_title".tr,
                logo: "",
                description: configModel.body?.flutter?.updateMessage ??
                    "force_update_msg".tr,
                buttonAction: "update_now".tr,
                buttonCancel: "cancel".tr,
                isShowBtnCancel:
                    configModel.body!.flutter!.forceDownload ?? false,
                onCancelTap: () {},
                onActionTap: () async {
                  _launchURL(configModel.body?.flutter?.appStoreUrl ??
                      "APP_STORE_URL".tr);
                },
              ),
            ));
      } else {
        showForceUpdateDialog(false);
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIos();
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  refreshTheFirebaseToken() {
    Timer.periodic(const Duration(minutes: 55), (Timer t) {
      FirebaseAuth.instance.currentUser?.getIdToken(true);
      String msg =
          "${DateTime.now().hour} : ${DateTime.now().minute} ${DateTime.now().second}"; //'notification ' + counter.toString();
      print('SEND: $msg');
    });
  }

  checkTheInternet() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.disconnected:
          break;
        case InternetConnectionStatus.connected:
          break;
      }
    });
  }
}
