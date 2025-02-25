import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/Validations.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import '../../../api_repository/app_url.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../../widgets/input_form_field.dart';
import '../../../widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../../widgets/or_divider.dart';
import 'login_controller.dart';

class LoginPageOTP extends StatefulWidget {
  const LoginPageOTP({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageOTP> {
  final AuthenticationManager _authmanager = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey();
  final _storage = const FlutterSecureStorage();
  final LoginController _viewModel = Get.find();

  TextEditingController emailCtr = TextEditingController(text: '');
  LinkedInConfig? _linkedInConfig;
  LinkedInUser? _linkedInUser;

  @override
  void initState() {
    super.initState();
    /*_linkedInConfig = LinkedInConfig(
        clientId: _authmanager.configModel.body?.linkedInDetail?.clientId ?? "",
        clientSecret:
            _authmanager.configModel.body?.linkedInDetail?.clientSecret ?? "",
        redirectUrl:
            _authmanager.configModel.body?.linkedInDetail?.redirectUrl ?? "",
        scope: ['openid', 'profile', 'email']);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        height: context.height,
        child: Stack(
          children: [
            buildBgImage(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 28.v,
                ),
                loginLogo(),
                SizedBox(
                  height: 65.v,
                ),
                Obx(() => _viewModel.signupform.value
                    ? signupForm(context)
                    : loginForm(context)),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomImage(),
            ),
            Obx(() => _viewModel.isLoading.value
                ? const Loading()
                : const SizedBox()),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget loginForm(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 35.adaptSize),
        padding:
            const EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _viewModel.isOtpSend.value
                        ? CustomTextView(
                            text: _viewModel.sentOTPMessage.value,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorSecondary,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          )
                        : CustomTextView(
                            text: "enter_your_detail".tr,
                            fontSize: 26,
                            color: colorSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    SizedBox(
                      height: 28.v,
                    ),
                    _viewModel.isOtpSend.value ? otpWidget() : usernameWidget(),
                    _viewModel.isOtpSend.value
                        ? const SizedBox(
                            height: 0,
                          )
                        : SizedBox(height: 20.v),
                    CommonMaterialButton(
                      height: 55.v,
                      color: colorPrimary,
                      textSize: 18,
                      textColor: white,
                      weight: FontWeight.w600,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_viewModel.isOtpSend.value) {
                            if (_viewModel.otpCode.isEmpty) {
                              UiHelper.showFailureMsg(
                                  context, "please_enter_OTP".tr);
                              return;
                            }
                            var loginRequest = {
                              'mobile': emailCtr.text.trim(),
                              "verification_code": _viewModel.otpCode,
                            };
                            _viewModel.commonLoginApi(
                                requestBody: loginRequest,
                                url: AppUrl.loginByOTP,
                                context: context);
                          } else {
                            _viewModel.shareVerificationCode(
                                emailCtr.text.trim(), context);
                          }
                        }
                      },
                      text: _viewModel.isOtpSend.value
                          ? "login".tr.toString()
                          : "send_otp".tr.toString(),
                    ),
                    _viewModel.isOtpSend.value
                        ? const SizedBox()
                        : const SizedBox(),
                    /* _viewModel.isOtpSend.value
                        ? const SizedBox()
                        : Platform.isIOS || Platform.isAndroid
                            ? OrDivider()
                            : const SizedBox(),
                    !_viewModel.isOtpSend.value && Platform.isIOS
                        ? loginWithApple()
                        : const SizedBox(),
                    !_viewModel.isOtpSend.value
                        ? loginWithLinked()
                        : const SizedBox(),*/
                    _viewModel.isOtpSend.value ? backButton() : signupButton()
                  ])),
        ),
      ),
    );
  }

  Widget signupForm(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
            color: white, borderRadius: BorderRadius.all(Radius.circular(12))),
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        padding:
            const EdgeInsets.only(top: 42, bottom: 30, left: 25, right: 25),
        child: SingleChildScrollView(
          child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextView(
                      text: "signup".tr,
                      fontSize: 26,
                      color: colorSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 28.v,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: loginWithWeb(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: loginWithWhatsApp(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40.v,
                    ),
                    GestureDetector(
                      onTap: () {
                        _viewModel.signupform.value = false;
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomTextView(
                                text: "already_have_account".tr,
                                color: colorSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              const CustomTextView(
                                  text: "Sign In",
                                  underline: true,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: colorPrimary),
                              //RegularTextView(text: login ? MyStrings.signup : "Login",color: primaryColor,)
                            ],
                          )),
                    )
                  ])),
        ),
      ),
    );
  }

  Widget infoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextView(
          text: "enter_your_detail".tr,
          fontSize: 24,
        ),
        const SizedBox(
          width: 6,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogWidget(
                  title: "hygiene_points".tr,
                  logo: ImageConstant.logout,
                  description: "hyginePoints".tr,
                  buttonAction: "okay".tr,
                  buttonCancel: "Cancel",
                  isShowBtnCancel: true,
                  onCancelTap: () {},
                  onActionTap: () async {},
                );
              },
            );
          },
          child: const Icon(Icons.info),
        ),
      ],
    );
  }

  Widget loginLogo() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: /*_authmanager.configModel.body?.meta?.logos?.icon != null*/
            false
                ? Image.network(
                    height: 45,
                    fit: BoxFit.contain,
                    _authmanager.configModel.body?.meta?.logos?.icon ?? "",
                    //height: 44.v,
                  )
                : Image.asset(
                    height: 180,
                    ImageConstant.header_logo,
                    fit: BoxFit.contain,
                    //height: 100.v,
                  ));
  }

  Widget signupButton() {
    return (_authmanager.configModel.body?.pages?.signup?.whatsApp != null &&
                _authmanager
                    .configModel.body!.pages!.signup!.whatsApp!.isNotEmpty) ||
            (_authmanager.configModel.body?.pages?.signup?.url != null &&
                _authmanager.configModel.body!.pages!.signup!.url!.isNotEmpty)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.v),
              GestureDetector(
                onTap: () {
                  if ((_authmanager.configModel.body?.pages?.signup?.whatsApp !=
                              null &&
                          _authmanager.configModel.body!.pages!.signup!
                              .whatsApp!.isNotEmpty) &&
                      (_authmanager.configModel.body?.pages?.signup?.url !=
                              null &&
                          _authmanager.configModel.body!.pages!.signup!.url!
                              .isNotEmpty)) {
                    _viewModel.signupform.value = true;
                  } else if (_authmanager
                              .configModel.body?.pages?.signup?.whatsApp !=
                          null &&
                      _authmanager.configModel.body!.pages!.signup!.whatsApp!
                          .isNotEmpty) {
                    UiHelper.inAppBrowserView(Uri.parse(_authmanager
                            .configModel.body!.pages!.signup!.whatsApp ??
                        ""));
                  } else {
                    UiHelper.inAppBrowserView(Uri.parse(
                        _authmanager.configModel.body!.pages!.signup!.url ??
                            ""));
                  }

                  /*var signupLink =
                      _authmanager.configModel.body?.pages?.signup?.url ?? "";
                  UiHelper.inAppBrowserView(Uri.parse(signupLink ?? ""));*/
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const AlreadyHaveAnAccountCheck(
                    true,
                  ),
                ),
              )
            ],
          )
        : const SizedBox();
  }

  Widget backButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24.v),
        _viewModel.isOtpSend.value
            ? InkWell(
                onTap: () {
                  _viewModel.isOtpSend(false);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  height: 29,
                  width: 73,
                  decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: CustomTextView(
                      text: "back".tr,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      color: colorSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  /// used in case of login via mobile number
  Widget usernameWidget() {
    return InputFormFieldMobile(
      controller: emailCtr,
      isMobile: true,
      inputExperssion: "[0123456789]",
      inputAction: TextInputAction.done,
      inputType: TextInputType.phone,
      hintText: "Mobile Number",
      maxLength: 16,
      validator: (String? value) {
        if (value!.trim().isEmpty || value.trim() == null) {
          return "please_enter_login_id".tr;
        } else if (!UiHelper.isMobileValid(value)) {
          return "Please enter valid mobile number.";
        } else {
          return null;
        }
      },
    );
  }

  ///used for this in case of login via email.
  Widget emailWidget() {
    return InputFormField(
      controller: emailCtr,
      isMobile: false,
      inputAction: TextInputAction.done,
      inputType: TextInputType.emailAddress,
      inputFormatters: Validations.emailFormatters,
      hintText: "loginId".tr,
      maxLength: 50,
      enableFocusBorderColor: hintColor,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "enter_email_address".tr;
        } else if (!UiHelper.isEmail(value.toString())) {
          return "enter_valid_email_address".tr;
        } else {
          return null;
        }
      },
    );
  }

  Widget otpWidget() {
    return GetX<LoginController>(
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              length: 6,
              defaultPinTheme: _viewModel.defaultPinTheme,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              pinAnimationType: PinAnimationType.fade,
              animationCurve: Curves.linear,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Only allows numbers
              ],
              onCompleted: (pin) {
                _viewModel.otpCode = pin;
              },
              onChanged: (value) {
                if (value.length < 5) {
                  _viewModel.otpCode = "";
                }
              },
              cursor: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 2,
                      height: 23,
                      color: indicatorColor,
                    ),
                  ),
                ],
              ),
              focusedPinTheme: _viewModel.defaultPinTheme.copyWith(
                decoration: _viewModel.defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorSecondary),
                ),
              ),
              submittedPinTheme: _viewModel.defaultPinTheme.copyWith(
                decoration: _viewModel.defaultPinTheme.decoration!.copyWith(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorSecondary),
                ),
              ),
              errorPinTheme: _viewModel.defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: !controller.isTimerIsRunning.value
                  ? GestureDetector(
                      onTap: () {
                        _viewModel.shareVerificationCode(
                            emailCtr.text.trim(), context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: CustomTextView(
                          text: "resend_otp".tr,
                          underline: true,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: colorPrimary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 6, left: 12, right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextView(
                            text: "resend_otp_in".tr,
                            fontSize: 15,
                            color: colorGray,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            width: 60.adaptSize,
                            child: CustomTextView(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colorGray,
                                text:
                                    '${UiHelper.formatCountdown(controller.tickCount.value)} Sec'),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget disclaimerWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                if (_viewModel.isDisclamer.value) {
                  _viewModel.isDisclamer(false);
                } else {
                  _viewModel.isDisclamer(true);
                }
                setState(() {});
              },
              child: _viewModel.isDisclamer.value
                  ? const Icon(
                      Icons.check_box,
                      color: colorSecondary,
                    )
                  : const Icon(Icons.check_box_outline_blank)),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          flex: 9,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogWidget(
                    title: "disclaimer".tr,
                    logo: ImageConstant.logout,
                    description: "disclamer".tr,
                    buttonAction: "okay".tr,
                    buttonCancel: "Cancel",
                    isShowBtnCancel: true,
                    onCancelTap: () {},
                    onActionTap: () async {},
                  );
                },
              );
            },
            child: Text.rich(
              TextSpan(
                text: "disclamerHalf".tr,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "read_more".tr,
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          color: colorSecondary)),
                  // can add more TextSpans here...
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildStaticLink({label, url}) {
    return InkWell(
      onTap: () {
        if (url != null && url.isNotEmpty)
          UiHelper.inAppWebView(Uri.parse(url));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextView(
              text: label.toString().toUpperCase() ?? "",
              fontSize: 14,
              color: colorSecondary,
            ),
            const SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBgImage() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CachedNetworkImage(
        imageUrl:
            /*_authmanager.configModel.body?.meta?.backgrounds?.loginBg ?? ""*/ "",
        imageBuilder: (context, imageProvider) => Container(
          height: context.height,
          width: context.width,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Center(
          child: Image.asset(
            ImageConstant.login_bg,
            height: context.height,
            width: context.width,
            fit: BoxFit.cover,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          ImageConstant.login_bg,
          height: context.height,
          width: context.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildBottomImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "powered_by".tr,
              style: GoogleFonts.getFont(MyConstant.currentFont,
                  color: white, fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          SvgPicture.asset(
            ImageConstant.icDreamcast,
            height: 26.adaptSize,
          )
        ],
      ),
    );
  }

  Widget loginWithApple() {
    return Platform.isIOS
        ? CommonMaterialButton(
            showIcon: true,
            borderWidth: 1,
            borderColor: black,
            color: white,
            svgIcon: "assets/svg/AppleLogo.svg",
            iconHeight: 15,
            height: 52.v,
            text: "Continue with Apple",
            textSize: 16,
            textColor: black,
            weight: FontWeight.w500,
            onPressed: () async {
              try {
                // Retrieve the Apple Sign-In credential
                final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                  ],
                  webAuthenticationOptions: WebAuthenticationOptions(
                    clientId: "signInAppleClientId".tr,
                    redirectUri: Uri.parse("signInWithAppleUrl".tr),
                  ),
                  nonce: 'example-nonce',
                  state: 'example-state',
                );

                // Check if email is available in the credential
                if (credential.email != null) {
                  // If email is available, store it securely
                  await _storage.write(
                      key: "user_email", value: credential.email);
                  print("Email stored securely: ${credential.email}");

                  var loginRequest = {
                    'email': credential.email.toString(),
                    "verification_code": "242526",
                    "login_via": "apple",
                  };
                  _viewModel.commonLoginApi(
                      requestBody: loginRequest,
                      url: AppUrl.loginByOTP,
                      context: context);
                } else {
                  // If email is null, fallback to the stored email
                  String? storedEmail = await _storage.read(key: "user_email");
                  if (storedEmail != null) {
                    print("Using stored email: $storedEmail");
                    var loginRequest = {
                      'email': storedEmail,
                      "verification_code": "242526",
                      "login_via": "apple",
                    };
                    _viewModel.commonLoginApi(
                        requestBody: loginRequest,
                        url: AppUrl.loginByOTP,
                        context: context);
                  } else {
                    // Handle the case where no email is available
                    print("No email available for login.");
                    // Optionally, show a message to the user
                    UiHelper.showFailureMsg(
                        context, "Unable to sign in. Email not available.");
                  }
                }
              } catch (e) {
                print("Error during Apple Sign-In: $e");
                // Handle the error appropriately, e.g., show an error message
                //UiHelper.showFailureMsg(context, "Error during Apple Sign-In: $e");
              }
            },
          )
        : const SizedBox();
  }

  Widget loginWithWeb() {
    return CommonMaterialButton(
        showIcon: true,
        borderWidth: 1,
        borderColor: black,
        color: white,
        svgIcon: "assets/svg/web.svg",
        iconHeight: 18,
        height: 52.v,
        text: "Continue with Web",
        textSize: 14,
        textColor: black,
        onPressed: () {
          var signupLink =
              _authmanager.configModel.body?.pages?.signup?.url ?? "";
          UiHelper.inAppBrowserView(Uri.parse(signupLink ?? ""));
        });
  }

  Widget loginWithWhatsApp() {
    return CommonMaterialButton(
        showIcon: true,
        borderWidth: 1,
        borderColor: black,
        color: white,
        svgIcon: "assets/svg/whatsapp.svg",
        iconHeight: 18,
        height: 52.v,
        text: "Continue with WhatsApp",
        textSize: 14,
        textColor: black,
        onPressed: () {
          var signupLink =
              _authmanager.configModel.body?.pages?.signup?.whatsApp ?? "";
          UiHelper.inAppBrowserView(Uri.parse(signupLink ?? ""));
        });
  }

  ///social login widget
  Widget loginWithLinked() {
    return _linkedInConfig != null
        ? CommonMaterialButton(
            showIcon: true,
            borderWidth: 1,
            borderColor: black,
            color: white,
            svgIcon: "assets/svg/linkedin.svg",
            iconHeight: 15,
            height: 52.v,
            text: "Continue with LinkedIn",
            textSize: 16,
            textColor: black,
            weight: FontWeight.w500,
            onPressed: () async {
              SignInWithLinkedIn.signIn(
                context,
                config: _linkedInConfig!,
                onGetUserProfile: (tokenData, user) {
                  print('Auth token data: ${tokenData.accessToken}');
                  print('LinkedIn User: ${user.toJson()}');
                  setState(() => _linkedInUser = user);
                  if (_linkedInUser?.email != null &&
                      _linkedInUser!.email!.isNotEmpty) {
                    var loginRequest = {
                      'code': tokenData.accessToken ?? "",
                    };
                    _viewModel.commonLoginApi(
                        requestBody: loginRequest,
                        url: AppUrl.linkedInLoginApi,
                        context: context);
                  } else {
                    UiHelper.showFailureMsg(context, "user_not_found".tr);
                  }
                },
                onSignInError: (error) {
                  UiHelper.showFailureMsg(context, 'Error on sign in: $error');
                },
              );
            },
          )
        : const SizedBox();
  }
}

enum FormType { login, register }

// Modify the "scope" below as per your need
/*final _linkedInConfig = LinkedInConfig(
    clientId: '779t0y9f5ktq1i' */ /*"77eyp1qqv75h26"*/ /*,
    clientSecret: 'MBxjONEOyNe0Y346' */ /*"U4DGUjRm5MPMKESv"*/ /*,
    redirectUrl:
        'https://live.dreamcast.in/dc_eventapp_2025' */ /*"https://www.indiamobilecongress.com"*/ /*,
    scope: ['openid', 'profile', 'email'],
  );*/
