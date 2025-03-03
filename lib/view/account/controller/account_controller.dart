import 'dart:io';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/account/model/createProfileModel.dart';
import 'package:dreamcast/view/account/model/notes_model.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dreamcast/api_repository/api_service.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../widgets/home_menu_item.dart';
import '../../home/controller/home_controller.dart';
import '../../menu/controller/menuController.dart';
import '../../menu/model/menu_data_model.dart';
import '../model/profileModel.dart';

class AccountController extends GetxController {
  late final AuthenticationManager _authManager;
  late final DashboardController _dashboardController;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;
  final ImagePicker _picker = ImagePicker();
  ProfileBody? _profileBody;
  ProfileBody? get profileBody => _profileBody;
  XFile _xFile = XFile("");
  XFile get profileFile => _xFile;

  //var menuItemExplorer = <HomeMenuNewItem>[].obs;
  var profileMenu = <MenuData>[].obs;

  Rx<bool> isSelectedSwitch = false.obs;
  var notesData = NotesData().obs;

  ProfileFieldData countryCodeData = ProfileFieldData();
  var appVersionName = "".obs;

  var profilePicUrl = "".obs;

  set profileFile(XFile xFile) {
    _xFile = xFile;
    update();
  }

  @override
  void onInit() {
    _authManager = Get.find();
    _dashboardController = Get.find();
    super.onInit();
    callDefaultApi();
  }

  callDefaultApi() {
    getProfileData(isFromDashboard: false);
  }

  @override
  void onReady() {
    super.onReady();
    getCountryList();
    getAppVersion();
  }

  Future<void> getProfileData({required isFromDashboard}) async {
    isLoading(true);
    ProfileModel? model = await apiService.getProfile();
    print("ye lo ${model.profileBody?.avatar ?? ""}");
    isLoading(false);
    if (model.status! && model.code == 200) {
      _profileBody = model.profileBody;
      _authManager.saveProfileData(
        fullName: model.profileBody?.name ?? "",
        username: model.profileBody?.shortName ?? "",
        profile: model.profileBody?.avatar ?? "",
        userId: _authManager.getUserId() ?? "",
        role: model.profileBody?.role ?? "",
        company: model.profileBody?.company ?? "",
        position: model.profileBody?.position ?? "",
        email: _authManager.getEmail() ?? "",
        chatId: _authManager.getDreamcastId() ?? "",
        category: _authManager.getCategory() ?? "",
        association: model.profileBody?.association ?? "",
      );
      profilePicUrl(model.profileBody?.avatar ?? "");
      _authManager.savePrivacyData(
          isChat: model.profileBody?.isChat == 1 ? true : false,
          isMeeting: model.profileBody?.isMeeting == 1 ? true : false,
          isProfile: false);
      if (model.profileBody?.isChat == 1 || model.profileBody?.isMeeting == 1) {
        isSelectedSwitch(true);
      } else {
        isSelectedSwitch(false);
      }
    } else {
      print(model.status!);
    }
  }

  //create profile dynamic
  Future<void> getCountryList() async {
    CreateProfileModel? createProfileModel =
    await apiService.profileField(AppUrl.getProfileFields);
    if (createProfileModel!.status! && createProfileModel!.code == 200) {
      for (ProfileFieldData data in createProfileModel.body ?? []) {
        if (data.name == "country_code") {
          countryCodeData = data;
        }
      }
      update();
    } else {
      print(createProfileModel!.code.toString());
    }
  }

  getAppVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.buildNumber.trim().replaceAll(".", ""));
    if (Platform.isAndroid) {
      appVersionName(currentVersion.toString());
    } else {
      appVersionName(_authManager.iosAppVersion.toString());
    }
  }

  String getTextFromValue(String countryCode) {
    var value = "";
    for (var data in countryCodeData.options ?? []) {
      if (data.value == countryCode) {
        value = data.text ?? "";
      }
    }
    return value;
  }

  void showPicker(BuildContext context) {
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
                    title: const CustomTextView(
                      text: "Photo",
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(bc).pop();
                    }),
                ListTile(
                  leading:
                  const Icon(Icons.photo_camera, color: colorSecondary),
                  title: const CustomTextView(
                      text: "Camera", textAlign: TextAlign.start),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(bc).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  imgFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    profileFile = pickedFile!;
  }

  imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    profileFile = pickedFile!;
  }
  bool isHubLoading(){
    if(Get.isRegistered<HubController>()){
      HubController hubController = Get.find();
      return hubController.contentLoading.value;
    }
    else{
      return false;
    }
  }
}
