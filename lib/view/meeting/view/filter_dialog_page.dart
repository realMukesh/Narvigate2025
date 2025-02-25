import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/view/meeting/model/meeting_filter_model.dart';
import 'package:flutter/material.dart';
import '../../../widgets/customTextView.dart';
import 'package:get/get.dart';

import '../../../widgets/button/custom_outlined_button.dart';
import '../../../widgets/toolbarTitle.dart';

class MeetingFilterDialogPage extends StatefulWidget {
  const MeetingFilterDialogPage({Key? key}) : super(key: key);

  @override
  State<MeetingFilterDialogPage> createState() =>
      _MeetingFilterDialogPageState();
}

class _MeetingFilterDialogPageState extends State<MeetingFilterDialogPage> {
  MeetingController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.80),
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: false,
        iconTheme: const IconThemeData(color: colorSecondary),
        title: ToolbarTitle(title: "choose_filter".tr),
        actions: [
          GestureDetector(
            onTap: () {
              controller.getMeetingListFilter(tabName: "");
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
              color: white, borderRadius: BorderRadius.all(Radius.circular(0))),
          height: context.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Stack(
            children: [
              _loadFilterData(),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomOutlinedButton(
                  height: 55.v,
                  margin: EdgeInsets.only(bottom: 10.adaptSize),
                  buttonStyle: OutlinedButton.styleFrom(
                    backgroundColor: colorSecondary,
                    side:
                    const BorderSide(color: colorSecondary, width: 1),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                  ),
                  buttonTextStyle: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.fSize),
                  onPressed: () async {
                    var formData = <String, dynamic>{};
                    formData["date"] = "";
                    formData["page"] = "1";
                    formData["filters"] = {
                      "status": controller.confirmStatus.value
                    };
                    _sendDataToServer(formData);
                  },
                  text: "submit".tr,
                ),
              )
            ],
          )),
    );
  }

  _sendDataToServer(Map<String, dynamic> formData) async {
    Get.back(result: formData);
  }

  _loadFilterData() {
    return GetX<MeetingController>(builder: (controller) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.meetingFilterList.length,
        itemBuilder: (context, index) {
          var filter = controller.meetingFilterList[index];
          return ExpansionTile(
            initiallyExpanded: true,
            title: CustomTextView(
              text: filter.label ?? "",
              color: colorSecondary,
              textAlign: TextAlign.start,
            ),
            children: [_loadOptionData(filter.options)],
          );
        },
      );
    });
  }

  _loadOptionData(List<Options>? options) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: options?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var option = options![index];
        return InkWell(
          onTap: () {
            controller.confirmStatus.value = option.id.toString();
            setState(() {});
          },
          child: ListTile(
            leading: controller.confirmStatus.value == option.id
                ? const Icon(Icons.radio_button_checked, color: colorSecondary)
                : const Icon(
                    Icons.radio_button_off,
                    color: grayColorLight,
                  ),
            title: CustomTextView(
              text: option.name ?? "",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
