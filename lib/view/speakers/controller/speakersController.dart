import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/commonController/bookmark_request_model.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:dreamcast/view/speakers/controller/speakerNetworkController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../model/common_model.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../../widgets/dialog/custom_dialog_widget.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../commonController/controller/common_chat_meeting_controller.dart';
import '../../myFavourites/controller/favourite_speaker_controller.dart';
import '../../schedule/model/scheduleModel.dart';
import '../../schedule/model/speaker_webinar_model.dart';
import '../model/speaker_session_model.dart';
import '../model/speakersDetailModel.dart';
import '../view/speakers_details_page.dart';

class SpeakersDetailController extends GetxController {
  @override
  final notesController = Get.put(MyNotesController());

  late final AuthenticationManager _authenticationManager;
  AuthenticationManager get authenticationManager => _authenticationManager;

  final CommonDocumentController _documentController = Get.find();

  final commonChatMeetingController = Get.put(CommonChatMeetingController());

  final TextEditingController notesEdtController = TextEditingController();
  var isLoading = false.obs;
  var isNotesLoading = false.obs;

  var isFavLoading = false.obs;
  var selectedIndex = 0.obs;

  var isBlocked = false.obs;

  //var iMReceiver = false.obs;
  final textController = TextEditingController().obs;

  ScrollController scrollController = ScrollController();
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var recommendedIdsList = <dynamic>[].obs;

  var userIdsList = <dynamic>[];

  var userDetailBody = UserDetailBody().obs;

  var role = MyConstant.speakers;

  var selectedSort = "ASC".obs;

  var notesData = NotesDataModel().obs;
  var isEditNotes = false.obs;
  var pageTitle = "".obs;

  var speakerSessionList = [].obs;

  final SessionController _sessionController = Get.find();

  @override
  void onInit() {
    _authenticationManager = Get.find();
    if(Get.arguments != null){
      role = Get.arguments["role"];
    }
    super.onInit();
  }

  Future<void> getBookmarkAndRecommendedByIds() async {
    getBookmarkIds();
    //getRecommendedIds();
  }

  ///get bookmark Ids
  Future<void> getBookmarkIds() async {
    bookMarkIdsList.value = await _documentController.getCommonBookmarkIds(
        items: userIdsList, itemType: role);
  }

  clearDefaultList() {
    bookMarkIdsList.clear();
    recommendedIdsList.clear();
  }

  //get user details
  Future<void> getSpeakerDetail({speakerId, role, isSessionSpeaker}) async {
    notesData.value.text = "";
    notesEdtController.text = "";
    isEditNotes(true);
    this.role = role;
    var body = {"id": speakerId, "role": role};
    isLoading(true);
    SpeakersDetailModel? model = await apiService.getSpeakerDetail(body);
    isLoading(false);
    try {
      if (model.status! && model.code == 200) {
        userDetailBody.value = model.body!;
        isBlocked(
            userDetailBody.value.isBlocked.toString() == "1" ? true : false);

        pageTitle("${role.toString().toLowerCase() == MyConstant.attendee ? "performer".tr : role.toString().capitalize} Profile");
        Get.toNamed(SpeakersDetailPage.routeName);
        commonChatMeetingController.getChatRequestStatus(
            isShow: false, receiverId: userDetailBody.value.id ?? "");
        getUserNotes(requestBody: {
          "item_type": role,
          "item_id": userDetailBody.value.id ?? "",
        });
        getSessionBySpeakerId(
            requestBody: {"speaker_id": userDetailBody.value.id ?? ""});
      } else {
        print(model.code.toString());
      }
    } catch (exception) {
      UiHelper.showFailureMsg(
          null, "User may be currently unavailable or Inactive.");
    }
  }

  //get notes text
  Future<void> getUserNotes({required requestBody}) async {
    isNotesLoading(true);
    CommonNotesModel? model = await apiService.getUserNotes(requestBody);
    isNotesLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body != null && model.body!.isNotEmpty) {
        notesEdtController.text = model.body?[0].text ?? "";
        notesData(model.body?[0]);
        isEditNotes(notesData.value.text.toString().isNotEmpty ? false : true);
      } else {
        notesData(NotesDataModel());
      }
    }
  }

  saveEditNotesApi(BuildContext context) async {
    var postRequest = {
      "id": notesData.value.id ?? "",
      "item_id": userDetailBody.value.id ?? "",
      "item_type": userDetailBody.value.role,
      "text": notesEdtController.text.trim().toString()
    };
    isLoading(true);
    var result = await notesController.addNotesToUser(postRequest);
    isLoading(false);
    if (result['status'] == true) {
      isEditNotes(!isEditNotes.value);
      notesData.value.text = result["text"];
      //Navigator.pop(context);
    } else {
      notesData.value.text = "";
    }
  }

  Future<void> getSessionBySpeakerId({required requestBody}) async {
    isNotesLoading(true);
    speakerSessionList.clear();
    speakerSessionList.refresh();
    SpeakerSessionModel? model =
        await apiService.getSpeakerSession(requestBody);
    isNotesLoading(false);
    if (model.status! && model.code == 200) {
      if (model.body != null && model.body!.isNotEmpty) {
        speakerSessionList.addAll(model.body ?? []);
        speakerSessionList.refresh();
        _sessionController.userIdsList =
            speakerSessionList.map((obj) => obj.id).toList();
        _sessionController.getBookmarkIds();
        if (speakerSessionList != null) {
          var userIdsList = speakerSessionList.map((obj) => obj.id).toList();
          _sessionController.getSpeakerWebinarList(
              sessionList: speakerSessionList, userIdsList: userIdsList);
        }
      }
    }
  }

  /*used for attendee*/
  Future<dynamic> bookmarkToUser(dynamic id, dynamic role) async {
    isFavLoading(true);
    var model = await _documentController.bookmarkToItem(
        requestBody:
            BookmarkRequestModel(itemType: role, itemId: id));
            // BookmarkRequestModel(itemType: MyConstant.speakers, itemId: id));
    isFavLoading(false);
    if (model["status"]) {
      bookMarkIdsList.add(id);
    } else {
      bookMarkIdsList.remove(id);
      removeItemFromBookmark(id);
    }
    bookMarkIdsList.refresh();
    return model;
  }

  ///used for the delete the ite from the list at time time of bookmark
  void removeItemFromBookmark(String id) {
    if (Get.isRegistered<FavSpeakerController>()) {
      FavSpeakerController favouriteController = Get.find();
      // Remove item where 'id' matches 'idToDelete'
      favouriteController.favouriteSpeakerList
          .removeWhere((item) => item.id == id);
      favouriteController.favouriteSpeakerList.refresh();
    }
  }

  void saveBlockUnblockDialog(
      {required context, required content, required body}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          title: isBlocked.value ? "Unblock?" : "Block?",
          logo: ImageConstant.block,
          description:
              "Are you sure you want to ${isBlocked.value ? "unblock" : "block"} this user.",
          buttonAction: isBlocked.value ? "Yes, Unblock" : "Yes, Block",
          buttonCancel: "Cancel",
          onCancelTap: () {},
          onActionTap: () async {
            isLoading(true);
            CommonModel? model = await apiService.blockUnBlock(body);
            isLoading(false);
            if (model.status! && model.code == 200) {
              isBlocked(!isBlocked.value);
              if (isBlocked.value) {
                removeTheBlockedUser(userId: body["block_user_id"]);
              }
              await Get.dialog(
                  barrierDismissible: false,
                  CustomAnimatedDialogWidget(
                    title: "",
                    logo: ImageConstant.icSuccessAnimated,
                    description: model.body!.message ?? "",
                    buttonAction: "close".tr,
                    buttonCancel: "cancel".tr,
                    isHideCancelBtn: true,
                    onCancelTap: () {},
                    onActionTap: () async {},
                  ));
            } else {
              UiHelper.showFailureMsg(null, model.body?.message ?? "");
            }

            //Get.back();
            //;
          },
        );
      },
    );
  }

  removeTheBlockedUser({userId}) {
    final SpeakerNetworkController networkingController = Get.find();
    networkingController.attendeeList.removeWhere((user) => user.id == userId);
    networkingController.getUserCount(isRefresh: false);
    networkingController.attendeeList.refresh();
  }
}
