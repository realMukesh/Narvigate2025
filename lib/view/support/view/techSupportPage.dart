import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/chat/model/message_model.dart';
import 'package:dreamcast/view/support/controller/supportController.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../chat/view/chat_bubble.dart';
import '../../../widgets/loading.dart';

class TechSupportPage extends GetView<SupportController> {
  //UserModel userModel;
  TechSupportPage({Key? key}) : super(key: key);
  static const routeName = "/chat_detail_page";

  final _messageController = TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        toolbarHeight: 0,
        centerTitle: false,
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: Container(
          color: Colors.transparent,
          height: context.height,
          width: context.width,
          padding: const EdgeInsets.all(0),
          child: GetX<SupportController>(
            builder: (controller) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: [
                      const SizedBox(
                        height: 0,
                      ),
                      controller.getRoomId.isNotEmpty
                          ? Expanded(child: buildMessageView())
                          : const SizedBox(),
                      SizedBox(
                        height: 100.v,
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: context.width,
                          color: bgColor,
                          child: CustomTextView(
                            text: "helpdesk_query_text".tr,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(width: 1, color: indicatorColor)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          // height: 56,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode,
                                  controller: _messageController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 2,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "type_your_message".tr,
                                      hintStyle: GoogleFonts.getFont(
                                          MyConstant.currentFont,
                                          color: grayColorLight,
                                          fontSize: 14.fSize,
                                          fontWeight: FontWeight.normal),
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                height: 46,
                                width: 46,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_messageController.text
                                        .toString()
                                        .trim()
                                        .isNotEmpty) {
                                      _sendMessage();
                                    } else {
                                      return;
                                    }
                                  },
                                  backgroundColor: colorPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const ImageIcon(
                                    AssetImage("assets/icons/send_icon.png"),
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.loading.value ? const Loading() : const SizedBox(),
                  Center(
                      child: CustomTextView(
                    text: controller.loadingLabel.value,
                    fontSize: 16,
                  )),
                ],
              );
            },
          )),
    );
  }

  buildMessageView() {
    return controller.newChatDetailList.isNotEmpty
        ? ListView.builder(
            controller: controller.scrollController,
            //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: controller.newChatDetailList.length,
            itemBuilder: (BuildContext context, int index) {
              ChatModel chatModel = controller.newChatDetailList[index];
              return ChatBubble(
                text: chatModel.message.toString().trim() ?? "",
                date: UiHelper.displayCommonDateTime(
                    date: chatModel.dateTime.toString(),
                    dateFormat: "dd MMM, hh:mm aa",
                    timezone: controller.authManager.getTimezone()),
                isSender: chatModel.userId == controller.authManager.getUserId()
                    ? true
                    : false,
                userName: chatModel.userId == controller.authManager.getUserId()
                    ? controller.authManager.getName() ?? ""
                    : controller.userModel.fullName ?? "",
                shortName:
                    chatModel.userId == controller.authManager.getUserId()
                        ? controller.authManager.getUsername() ?? ""
                        : controller.userModel.shortName ?? "",
                avtar: chatModel.userId == controller.authManager.getUserId()
                    ? controller.authManager.getImage() ?? ""
                    : controller.userModel.avtar ?? "",
              );
            },
          )
        : const SizedBox();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }
    if (controller.getRoomId.isNotEmpty) {
      final message = ChatModel(controller.authManager.getUserId(),
          _messageController.text.trim(), DateTime.now().toUtc());
      controller.sendMessage(message, controller.userModel.userId ?? "");
      _messageController.clear();
    } else {
      var body = {
        "receiver_id": controller.userModel.userId,
        "text": _messageController.text.trim()
      };
      await controller.sendFirstMessage(body, controller.userModel.userId);
      _messageController.clear();
    }
  }
}
