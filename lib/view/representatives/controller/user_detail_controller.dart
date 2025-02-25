import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/Notes/controller/my_notes_controller.dart';
import 'package:dreamcast/view/breifcase/controller/common_document_controller.dart';
import 'package:dreamcast/view/myFavourites/controller/favourite_user_controller.dart';
import 'package:dreamcast/view/representatives/model/chat_request_status_model.dart';
import 'package:dreamcast/widgets/dialog/custom_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../../widgets/dialog/custom_animated_dialog_widget.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../commonController/bookmark_request_model.dart';
import '../../commonController/controller/common_chat_meeting_controller.dart';
import '../../exhibitors/model/bookmark_common_model.dart';
import '../../meeting/model/create_time_slot.dart';
import '../../meeting/model/timeslot_model.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../myFavourites/model/BookmarkIdsModel.dart';
import '../dialog/sechdule_meeting_dialog.dart';
import '../model/chat_request_model.dart';
import '../model/user_detail_model.dart';
import '../view/userDetailsPage.dart';
import 'networkingController.dart';

class UserDetailController extends GetxController {
  @override
  final controller = Get.put(MyNotesController());

  late final AuthenticationManager _authenticationManager;
  AuthenticationManager get authenticationManager => _authenticationManager;

  final CommonDocumentController _documentController = Get.find();

  final commonChatMeetingController = Get.put(CommonChatMeetingController());

  final MyNotesController notesController = Get.find();
  final TextEditingController notesEdtController = TextEditingController();
  var isLoading = false.obs;
  var isNotesLoading = false.obs;

  var isFavLoading = false.obs;
  var isChatLoading = false.obs;

  var selectedIndex = 0.obs;
  var allowedDate = "";
  var isBlocked = false.obs;

  //var chatStatusRequest = 0.obs;
  //var iMReceiver = false.obs;
  final textController = TextEditingController().obs;

  ScrollController scrollController = ScrollController();
  //used for match the ids to user ids
  var bookMarkIdsList = <dynamic>[].obs;
  var recommendedIdsList = <dynamic>[].obs;

  var userIdsList = <dynamic>[];

  //var chatStatusBody = ChatRequestBody().obs;

  var userDetailBody = UserDetailBody().obs;

  var role = MyConstant.attendee;

  //var timeslotsList = <MeetingSlots>[].obs;
  //var slots = <CreatedSlots>[].obs;
  var selectedSort = "ASC".obs;

  //used in meeting section dialog
  //var selectedLocation = "Networking lounge".obs;
  //var bookingAppoinmentList = [];

  var notesData = NotesDataModel().obs;
  var isEditNotes = false.obs;
  var pageTitle = "".obs;

  @override
  void onInit() {
    _authenticationManager = Get.find();
    super.onInit();
  }

  Future<void> getBookmarkAndRecommendedByIds() async {
    getBookmarkIds();
    getRecommendedIds();
  }

  ///get bookmark Ids
  Future<void> getBookmarkIds() async {
    bookMarkIdsList.value = await _documentController.getCommonBookmarkIds(
        items: userIdsList, itemType: MyConstant.networking);
  }

  clearDefaultList() {
    bookMarkIdsList.clear();
    recommendedIdsList.clear();
  }

  Future<void> getRecommendedIds() async {
    try {
      if (userIdsList.isEmpty) {
        return;
      }
      BookmarkIdsModel? model = await apiService.getRecommendedIds(
          {"users": userIdsList}, "${AppUrl.usersListApi}/getAiRecommended");
      if (model.status! && model.code == 200) {
        // Extract the list from the body and filter items with recommended == true
        if (model.body != null) {
          recommendedIdsList.addAll(model.body!
              .where((item) => item.isRecommended == true)
              .map((item) => item.id)
              .toList());
        }
      } else {
        print(model.code.toString());
        return;
      }
    } catch (exception) {
      debugPrint(exception.toString());
    } finally {
      // Code here will run whether or not an exception was thrown
      debugPrint("Completed the process of fetching recommended IDs");
    }
  }

  //get user details
  Future<void> getUserDetailApi(
    dynamic id,
    role,
  ) async {
    notesData.value.text = "";
    notesEdtController.text = "";
    isEditNotes(true);
    this.role = role;
    var body = {"id": id, "role": role};
    isLoading(true);
    UserDetailModel? model = await apiService.getUserDetail(body);
    isLoading(false);
    if (model.status! && model.code == 200) {
      userDetailBody.value = model.body!;
      isBlocked(
          userDetailBody.value.isBlocked.toString() == "1" ? true : false);
      pageTitle(role == MyConstant.attendee ? "Profile" : "Profile");
      Get.toNamed(UserDetailPage.routeName);
      commonChatMeetingController.getChatRequestStatus(
          isShow: false, receiverId: userDetailBody.value.id ?? "");
      getUserNotes(requestBody: {
        "item_type": role,
        "item_id": userDetailBody.value.id ?? "",
      });
    } else {
      print(model.code.toString());
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

  /*used for attendee*/
  Future<dynamic> bookmarkToUser(
      dynamic id, dynamic role, BuildContext context) async {
    isFavLoading(true);
    var model = await _documentController.bookmarkToItem(
        requestBody: BookmarkRequestModel(itemType: role, itemId: id));
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
    if (Get.isRegistered<FavUserController>()) {
      FavUserController favouriteController = Get.find();
      // Remove item where 'id' matches 'idToDelete'
      favouriteController.favouriteAttendeeList
          .removeWhere((item) => item.id == id);
      favouriteController.favouriteAttendeeList.refresh();
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
                    buttonAction: "okay".tr,
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
    final NetworkingController networkingController = Get.find();
    networkingController.attendeeList.removeWhere((user) => user.id == userId);
    networkingController.getUserCount(isRefresh: false);
    networkingController.attendeeList.refresh();
  }
}
