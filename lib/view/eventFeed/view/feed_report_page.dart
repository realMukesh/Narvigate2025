import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/eventFeed/controller/eventFeedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/loading.dart';
import '../../../widgets/button/rounded_button.dart';
import '../../../widgets/toolbarTitle.dart';

class FeedReportPage extends GetView<EventFeedController> {
  String eventFeedId = "";
  String? feedCommentId = "";
  bool isReportPost;
  FeedReportPage({Key? key, required this.eventFeedId, this.feedCommentId,required this.isReportPost})
      : super(key: key);
  static const routeName = "/FeedbackPage";
  final TextEditingController textAreaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ToolbarTitle(
          title: "report_on_Feed".tr,
          color: Colors.black,
        ),
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: GetX<EventFeedController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    buildSelectionWidget(),
                    ProfileButton(
                      text: 'Submit',
                      press: () async {
                        if(isReportPost){
                          controller.reportPostApi(requestBody: {
                            "feed_id": eventFeedId,
                            "reason": controller.commentResign[
                            controller.selectedReportOption.value]
                          });
                        }else{
                          controller.reportCommentApi(requestBody: {
                            "feed_id": eventFeedId,
                            "feed_comment_id":feedCommentId,
                            "reason": controller.commentResign[
                            controller.selectedReportOption.value]
                          });
                        }

                        Get.back();
                      },
                    )
                  ],
                ),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            );
          })),
    );
  }

  buildSelectionWidget() {
    return Expanded(
        child: ListView.builder(
            itemCount: controller.commentResign.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  controller.selectedReportOption(index);
                },
                child: ListTile(
                    title: CustomTextView(
                      fontWeight: FontWeight.normal,
                      text: controller.commentResign[index],fontSize: 18,maxLines: 2,textAlign: TextAlign.start,
                    ),
                    trailing: Obx(() => Icon(
                          color: Colors.black,
                          controller.selectedReportOption.value != -1 &&
                                  controller.selectedReportOption.value == index
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                        ))),
              );
            }));
  }

  textArea() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "enter_description_about_post".tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: TextFormField(
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
          hintText: "",
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
}
