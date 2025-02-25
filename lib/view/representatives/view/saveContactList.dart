
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/qrCode/model/user_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import '../../../widgets/button/custom_outlined_button.dart';
import '../../../widgets/button/rounded_outline_button.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../qrCode/controller/qr_page_controller.dart';

class SaveContactPage extends GetView<QrPageController> {
  UserModelModel userModel;
  String code;
  SaveContactPage({Key? key, required this.userModel,required this.code}) : super(key: key);
  final AuthenticationManager _authManager = Get.find();
  final TextEditingController textAreaController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: false,
        leading: GestureDetector(
          child: const Icon(Icons.close),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(
          title: "save_contact".tr,
          color: Colors.black,
        ),
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        elevation: 0,
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: Container(
          color: Colors.transparent,
          height: context.height,
          width: context.width,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: GetX<QrPageController>(builder: (controller) {
            return Stack(
              children: [
                _buildBannerView(context: context),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            );
          })),
    );
  }

  //show top banner and type of media load
  _buildBannerView({required BuildContext context}) {
    var userData = userModel.body?.data;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: colorLightGray),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: buildProfileImage(userData),
                flex: 2,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextView(
                        text: userData?.name.toString().capitalize ?? ""),
                    CustomTextView(
                        maxLines: 2,
                        text: userData?.company.toString().capitalize ?? ""),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          buildNotesWidget(),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: CustomOutlinedButton(
                  height: 53.v,
                  // margin: EdgeInsets.only(bottom: 10.adaptSize),
                  buttonStyle: OutlinedButton.styleFrom(
                    backgroundColor: colorSecondary,
                    side: const BorderSide(color: colorSecondary, width: 1),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  buttonTextStyle: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.fSize),
                  onPressed: () async {
                    var jsonRequest={
                      // "code":code,
                      "qrcode":code,
                      "note":textAreaController.text.toString()??""
                    };
                    controller.saveUserToContact(context,jsonRequest);
                  },
                  text: "save".tr,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: RoundedOutlineButton(
                  text: "cancel".tr,
                  press: () {
                    Get.back();
                  },
                  color: colorSecondary,
                  textColor: colorSecondary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildNotesWidget(){
    return  SizedBox(
      height: 100,
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        validator: (String? value) {
          if (value!.trim().isEmpty || value.trim() == null) {
            return "enter_description".tr;
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          //labelText: "${createFieldBody.label}",
          hintText: "notes".tr,
          labelStyle: const TextStyle(color: colorSecondary),
          fillColor: Colors.transparent,
          filled: true,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: colorSecondary)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
        ),
        minLines: 6,
        maxLines: 12,
      ),
    );
  }


  buildProfileImage(dynamic personalObject) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorSecondary,
          border: Border.all(color: Colors.transparent)),
      child: Center(
          child: CustomTextView(
        text: personalObject?.shortName ?? "",
        textAlign: TextAlign.center,
        color: white,
      )),
    );
  }
}
