import 'package:dreamcast/utils/dialog_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/account/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/common_model.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/button/rounded_button.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../account/model/createProfileModel.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../beforeLogin/signup/model/city_res_model.dart';
import '../../beforeLogin/signup/model/state_res_model.dart';
import '../../../widgets/customTextView.dart';
import '../model/ai_profile_data_model.dart';
import '../model/profile_update_model.dart';

class EditProfileController extends GetxController {
  late final AuthenticationManager _authManager;
  //used for change the profile tab
  final selectedTabIndex = 0.obs;
  final textController = TextEditingController().obs;
  var tempOptionList = <Options>[].obs;
  //parent list of profile
  final profileFieldList = <ProfileFieldData>[].obs;
  final selectedAiMatch = <dynamic>[].obs;
  final profileImage = CroppedFile("").obs;

  final cityList = <Options>[].obs;
  final stateList = <Options>[].obs;

  var selectedCountryId = "";
  var selectedStateId = "";
  var countryCode = "";

  //parent list of profile
  //its used for profile steps
  final profileFieldStep1 = <ProfileFieldData>[].obs;
  final profileFieldStep2 = <ProfileFieldData>[].obs;
  final profileFieldStep3 = <ProfileFieldData>[].obs;
  final profileFieldStep4 = <ProfileFieldData>[].obs;

  //show loading
  var isLoading = false.obs;
  var isFirstLoading = false.obs;

  //for the name field
  var userName = "";
  var isUserEditEnable = false.obs;

  @override
  void onInit() {
    _authManager = Get.find();
    super.onInit();
    userName = _authManager.getName() ?? "";
    getProfileFields();
  }

  //create profile dynamic
  Future<void> getProfileFields() async {
    isFirstLoading(true);
    CreateProfileModel? createProfileModel =
        await apiService.profileField(AppUrl.getProfileFields);
    isFirstLoading(false);
    if (createProfileModel!.status! && createProfileModel.code == 200) {
      profileFieldList.clear();
      profileFieldList.addAll(createProfileModel.body ?? []);
      profileFieldStep1.clear();
      profileFieldStep2.clear();
      profileFieldStep3.clear();
      profileFieldStep4.clear();
      profileFieldStep1
          .addAll(profileFieldList.where((u) => u.step == 0).toList());
      profileFieldStep2
          .addAll(profileFieldList.where((u) => u.step == 1).toList());
      profileFieldStep3
          .addAll(profileFieldList.where((u) => u.step == 2).toList());
      profileFieldStep4
          .addAll(profileFieldList.where((u) => u.step == 3).toList());
      update();
      if (Get.arguments != null && Get.arguments.isNotEmpty) {
        aiProfileGet();
      }
    } else {
      print(createProfileModel!.code.toString());
    }
    isFirstLoading(false);
  }

  Future<void> updateProfile(BuildContext context) async {
    var formData = <String, dynamic>{};
    profileFieldList.clear();
    profileFieldList.addAll(profileFieldStep1);
    profileFieldList.addAll(profileFieldStep2);
    profileFieldList.addAll(profileFieldStep3);
    profileFieldList.addAll(profileFieldStep4);
    var aiFormKey = [];
    for (int index = 0; index < profileFieldList.length; index++) {
      var mapList = [];
      var data = profileFieldList[index];
      if (data.value != null) {
        if (data.value is List) {
          for (int cIndex = 0; cIndex < data.value!.length; cIndex++) {
            mapList.add(data.value[cIndex]);
          }
          formData["${data.name}"] = mapList;
        } else {
          formData["${data.name}"] = data.value.toString();
          if (data.isAiFormField != null && data.isAiFormField == true) {
            aiFormKey.add(data.name);
          }
        }
      }
      if (_authManager.getImage() != null &&
          _authManager.getImage()!.isNotEmpty) {
        formData["avatar"] = _authManager.getImage() ?? "";
      }
      formData["aiUpdatedFiled"] = aiFormKey;
    }
    isLoading(true);
    ProfileUpdateModel? responseModel =
        await apiService.updateProfile(formData, AppUrl.updateProfile);
    isLoading(false);
    if (responseModel!.status!) {
      await _authManager.setProfileUpdate(1);
      Get.back(result: "update");
      // UiHelper.showSuccessMsg(context, responseModel.message ?? "");
      UiHelper.showSuccessMsg(context, responseModel.message ?? "");
    } else {
      Map<String, dynamic> decoded = responseModel.body!.toJson();
      String message = "";
      for (var colour in decoded.keys) {
        message = "$message${decoded[colour] ?? ""}";
      }
      UiHelper.showFailureMsg(context, message ?? "");
    }
  }

  //used for the update the linked url
  Future<void> updateLinkedInUrl(BuildContext? context, String url) async {
    var jsonRequest = {"linkedin": url};
    isLoading(true);
    CommonModel? responseModel = await apiService.updateLinkedin(jsonRequest);
    isLoading(false);
    if (responseModel!.status!) {
      _authManager.saveLinkedUrl(url);
      Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: ImageConstant.icSuccessAnimated,
            description: responseModel.message ?? "",
            buttonAction: "go_back".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              Get.back();
              //await aiProfileGet();
            },
          ));
      // UiHelper.showSuccessMsg(null, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(context, responseModel.message ?? "");
    }
  }

  Future<Map> aiMessageUpdate() async {
    var result = {};
    CommonModel? responseModel = await apiService.aiMessageLinkedin();
    if (responseModel!.status!) {
      result = {
        'status': responseModel.status ?? false,
        'message': responseModel?.message ?? "",
      };
    } else {
      result = {
        'status': responseModel.status ?? false,
        'message': responseModel?.message ?? "",
      };
    }
    return result;
  }

  //ai field get
  Future<void> aiProfileGet() async {
    isLoading(true);
    AiProfileDataModel? responseModel = await apiService.aiProfileGet({});
    isLoading(false);
    if (responseModel!.status!) {
      for (var data in profileFieldList) {
        if (data.name == "avatar") {
          data.value = responseModel.body?.avatar ?? "";
          data.isAiFormField = true;
          _authManager.saveProfileImage(data.value) ?? "";
        } else if (data.name == "company") {
          if (data.readonly != null && data.readonly == false) {
            data.value = responseModel.body?.company ?? "";
            data.isAiFormField = true;
          }
        } else if (data.name == "position") {
          if (data.readonly != null && data.readonly == false) {
            data.value = responseModel.body?.position ?? "";
            data.isAiFormField = true;
          }
        } else if (data.name == "description") {
          data.value = responseModel.body?.description ?? "";
          data.isAiFormField = true;
        } else if (data.name == "linkedin") {
          data.value = responseModel.body?.linkedin ?? "";
          data.isAiFormField = true;
        } else if (data.name == "interest") {
          data.value = responseModel.body?.interested ?? "";
          data.isAiFormField = true;
        } else if (data.name == "insights") {
          data.value = responseModel.body?.insights ?? "";
          data.isAiFormField = true;
        }
      }
      profileFieldStep1.refresh();
      update();
      //UiHelper.showSuccessMsg(null, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(null, responseModel.message ?? "");
    }
  }

  //update the profile
  Future<void> updatePicture() async {
    isLoading(true);
    ProfileUpdateModel? responseModel =
        await apiService.updateImage(profileImage.value.path);
    isLoading(false);
    if (responseModel!.status!) {
      if (Get.isRegistered<AccountController>()) {
        AccountController accountController = Get.find();
        accountController.callDefaultApi();
        // Get.back(result: "update");
      }
      UiHelper.showSuccessMsg(null, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(null, responseModel.message ?? "");
    }
  }

  Future<void> removePicture() async {
    isLoading(true);
    ProfileUpdateModel? responseModel = await apiService.removeImage();
    isLoading(false);
    if (responseModel!.status!) {
      profileImage(CroppedFile(""));
      _authManager.saveProfileImage("");
      if (Get.isRegistered<AccountController>()) {
        AccountController accountController = Get.find();
        accountController.callDefaultApi();
        // Get.back(result: "update");
      }
      update();
      UiHelper.showSuccessMsg(null, responseModel.message ?? "");
    } else {
      UiHelper.showFailureMsg(null, responseModel.message ?? "");
    }
  }

  showErrorMessage(message) {
    Get.snackbar(
      backgroundColor: Colors.red,
      colorText: Colors.white,
      "Error",
      message,
    );
  }

  final ImagePicker _picker = ImagePicker();

  void showPicker(BuildContext context, index, int step) {
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: colorSecondary,
                    ),
                    title: CustomTextView(
                      text: "photo".tr,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      imgFromGallery(index);
                      Navigator.of(bc).pop();
                    }),
                ListTile(
                  leading:
                      const Icon(Icons.photo_camera, color: colorSecondary),
                  title: CustomTextView(
                    text: "camera".tr,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  onTap: () {
                    imgFromCamera(index);
                    Navigator.of(bc).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: colorSecondary),
                  title: CustomTextView(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      text: "remove_image".tr,
                      textAlign: TextAlign.start),
                  onTap: () {
                    removePicture();
                    Navigator.of(bc).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  imgFromCamera(int index) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    debugPrint("@@ camera status ${status.isDenied}");
    if (status.isPermanentlyDenied /*|| status.isDenied*/) {
      // If permission is denied or permanently denied
      DialogConstant.showPermissionDialog();
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      await _cropImage(pickedFile, index);
    }
  }

  imgFromGallery(int index) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      // If permission is denied or permanently denied
      DialogConstant.showPermissionDialog();
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    await _cropImage(pickedFile, index);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController linkedInEdtController = TextEditingController();
  var linkedInUrl = "";

  showLinkedinDialog({title, content, linkedinUrl, context}) async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(), // to push the close button to the right
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      color: colorGray,
                    ),
                    onPressed: () => Get.back(result: ""),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: CustomTextView(
                    text: "have_not_shared_linkedin_profile".tr,
                    maxLines: 4,
                    fontSize: 16,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    child: TextFormField(
                      controller: linkedInEdtController,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.getFont(MyConstant.currentFont,
                          fontSize: 15.fSize,
                          color: colorSecondary,
                          fontWeight: FontWeight.normal),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "please_enter_url".tr;
                        } else if (!UiHelper.isValidLinkedInUrlNew(
                            value.trim())) {
                          return "Please enter valid linkedin url";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        linkedInUrl = value;
                      },
                      decoration: InputDecoration(
                        prefixStyle: const TextStyle(color: grayColorLight),
                        counter: const Offstage(),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        labelText: "LinkedIn",
                        hintText: "Add URL" ?? "",
                        hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
                            fontSize: 15.fSize,
                            color: colorGray,
                            fontWeight: FontWeight.normal),
                        labelStyle: GoogleFonts.getFont(MyConstant.currentFont,
                            fontSize: 15.fSize,
                            color: colorGray,
                            fontWeight: FontWeight.normal),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 60),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: borderEditColor, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: borderEditColor, width: 1)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: borderEditColor, width: 1)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.adaptSize,
              ),
              SizedBox(
                height: 50.v,
                width: 150.h,
                child: MyRoundedButton(
                    color: colorPrimary,
                    textColor: white,
                    textSize: 16,
                    text: "update_now".tr,
                    press: () async {
                      if (_formKey.currentState?.validate() == true) {
                        Get.back();
                        await updateLinkedInUrl(context, linkedInUrl);
                      } else {
                        return;
                      }
                    }),
              ),
              SizedBox(
                height: 40.adaptSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage(_pickedFile, index) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "cropper".tr,
              toolbarColor: colorSecondary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            hideBottomControls: true
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true, // Lock aspect ratio
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
            hidesNavigationBar: true
          ),
        ],
      );
      if (croppedFile != null) {
        profileImage(croppedFile);
        refresh();
        updatePicture();
      }
    }
  }

  Future<void> getState(String countryId) async {
    isLoading(true);
    StateResponseModel? model = await apiService.getStateByCountry(countryId);
    if (model!.status! && model!.code == 200) {
      isLoading(false);
      stateList.clear();
      stateList.addAll(model.body ?? []);
    } else {
      isLoading(false);
    }
  }

  Future<void> getCities(String countryId, String stateId) async {
    isLoading(true);
    CityResponseModel? model =
        await apiService.getCityByCountry(countryId, stateId);
    if (model!.status! && model!.code == 200) {
      isLoading(false);
      cityList.clear();
      cityList.addAll(model.body ?? []);
    } else {
      isLoading(false);
    }
  }
}
