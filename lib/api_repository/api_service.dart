import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dreamcast/model/guide_model.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/view/Notes/model/common_notes_model.dart';
import 'package:dreamcast/view/account/model/createProfileModel.dart';
import 'package:dreamcast/view/account/model/notes_model.dart';
import 'package:dreamcast/view/beforeLogin/signup/model/city_res_model.dart';
import 'package:dreamcast/view/beforeLogin/signup/model/signup_category_model.dart';
import 'package:dreamcast/view/beforeLogin/signup/model/state_res_model.dart';
import 'package:dreamcast/view/eventFeed/model/postLikeModel.dart';
import 'package:dreamcast/view/gallery/model/galleryModel.dart';
import 'package:dreamcast/view/guide/model/dodont_model.dart';
import 'package:dreamcast/view/leaderboard/model/leaderboard_model.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/menu/model/shiftingModel.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_exhibitor_model.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_products_model.dart';
import 'package:dreamcast/view/myFavourites/model/bookmark_speaker_model.dart';
import 'package:dreamcast/view/exhibitors/model/product_detail_model.dart';
import 'package:dreamcast/view/exhibitors/model/product_list_model.dart';
import 'package:dreamcast/view/home/model/config_detail_model.dart';
import 'package:dreamcast/view/meeting/model/meeting_detail_model.dart';
import 'package:dreamcast/view/meeting/model/meeting_model.dart';
import 'package:dreamcast/view/meeting/model/timeslot_model.dart';
import 'package:dreamcast/view/contact/model/contact_list_model.dart';
import 'package:dreamcast/view/partners/model/homeSponsorsPartnersListModel.dart';
import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';
import 'package:dreamcast/view/qrCode/model/qrScannedUserDetails_Model.dart';
import 'package:dreamcast/view/representatives/model/user_model.dart';
import 'package:dreamcast/view/representatives/model/user_filter_model.dart';
import 'package:dreamcast/api_repository/app_url.dart';
import 'package:dreamcast/view/beforeLogin/login/login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/badge_model.dart';
import '../model/common_model.dart';
import '../model/pages_model.dart';
import '../routes/app_pages.dart';
import '../theme/app_colors.dart';
import '../utils/logger.dart';
import '../utils/pref_utils.dart';
import '../view/account/model/profileModel.dart';
import '../view/askQuestion/model/ask_question_model.dart';
import '../view/askQuestion/model/ask_save_model.dart';
import '../view/beforeLogin/globalController/authentication_manager.dart';
import '../view/beforeLogin/signup/model/signup_reponse_model.dart';
import '../view/beforeLogin/splash/model/config_model.dart';
import '../view/bestForYou/model/best_for_you_data_model.dart';
import '../view/breifcase/model/BriefcaseModel.dart';
import '../view/chat/model/create_room_model.dart';
import '../view/contact/model/model_contact_filter.dart';
import '../view/home/model/recommended_model.dart';
import '../view/representatives/model/user_count_model.dart';
import '../view/partners/model/partnerDetailModel.dart';
import '../view/profileSetup/model/ai_profile_data_model.dart';
import '../view/schedule/model/speaker_webinar_model.dart';
import '../view/speakers/model/speaker_session_model.dart';
import '../view/startNetworking/model/angelAllyModel.dart';
import '../view/startNetworking/model/startNetworkingModel.dart';
import '../view/startNetworking/model/startNetworkingSlot.dart';
import '../view/support/model/sos_model.dart';
import '../widgets/customTextView.dart';
import '../view/exhibitors/model/exhibitorTeamModel.dart';
import '../view/support/model/faq_model.dart';
import '../view/meeting/model/meeting_participant_model.dart';
import '../view/myFavourites/model/BookmarkIdsModel.dart';
import '../view/myFavourites/model/bookmark_session_model.dart';
import '../view/eventFeed/model/commentModel.dart';
import '../view/eventFeed/model/createCommentModel.dart';
import '../view/eventFeed/model/createPostModel.dart';
import '../view/eventFeed/model/feedDataModel.dart';
import '../view/eventFeed/model/feedLikeModel.dart';
import '../view/meeting/model/meeting_filter_model.dart';
import '../view/exhibitors/model/bookmark_common_model.dart';
import '../view/exhibitors/model/exhibitors_filter_model.dart';
import '../view/exhibitors/model/exibitorsModel.dart';
import '../view/exhibitors/model/exibitors_detail_model.dart';
import '../view/exhibitors/model/exibitors_document_model.dart';
import '../view/exhibitors/model/product_filter_model.dart';
import '../view/partners/model/partnersModel.dart';
import '../view/home/model/timezone_model.dart';
import '../view/meeting/model/colleagues_model.dart';
import '../view/menu/model/photobooth_model.dart';
import '../view/photobooth/model/myPhotoModel.dart';
import '../view/photobooth/model/photoListModel.dart';
import '../view/photos/model/videoModel.dart';
import '../view/polls/model/pollsReponse.dart';
import '../view/products/model/productExhibitorModel.dart';
import '../view/profileSetup/model/profile_update_model.dart';
import '../view/qrCode/model/unique_code_model.dart';
import '../view/qrCode/model/user_detail_model.dart';
import '../view/quiz/model/question_list_model.dart';
import '../view/representatives/model/chat_accept_model.dart';
import '../view/representatives/model/chat_request_model.dart';
import '../view/representatives/model/chat_request_status_model.dart';
import '../view/contact/model/contact_export_model.dart';
import '../view/representatives/model/user_detail_model.dart';
import '../view/schedule/model/sessionPollsStatus.dart';
import '../view/schedule/model/scheduleModel.dart';
import '../view/schedule/model/sessin_detail_model.dart';
import '../view/schedule/model/session_filter_model.dart';
import '../view/speakers/model/speakersDetailModel.dart';
import '../view/speakers/model/speakersModel.dart';
import '../view/speakers/model/speakers_filter_model.dart';
import '../widgets/button/rounded_button.dart';
import 'digestauthclient.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'exceptions.dart';

ApiService apiService = Get.find<ApiService>();

class ApiService extends GetxService {
  late final AuthenticationManager _authManager;
  var cphiHeaders;
  var authHeader;
  var DIGEST_AUTH_USERNAME = "";
  var DIGEST_AUTH_PASSWORD = "";
  var isDialogShow = false;

  Future<ApiService> init() async {
    DIGEST_AUTH_USERNAME = "41ab073b088c9b12b231643ff6f437d9";
    DIGEST_AUTH_PASSWORD = "9381edb30e889126282379eae2bf2aee";
    _authManager = Get.find();
    cphiHeaders = {
      "Content-Type": "application/json; charset=utf-8",
      "X-Api-Key": "%2BiR%2Ftt9g8E1tk1%2BDCJgiO7i5XrI%3D",
      "X-Requested-With": "XMLHttpRequest",
      "dc-timezone": "-330",
      "User-Agent": _authManager.osName.toUpperCase(),
      "Dc-OS": _authManager.osName.toLowerCase(),
      "Dc-Device": _authManager.dc_device.toLowerCase(),
      "Dc-Platform": "flutter",
      "Dc-OS-Version": _authManager.platformVersion,
      "DC-UUID": "",
      "Dc-App-Version": "6"
    };
    return this;
  }

  dynamic getHeaders() {
    //dc-device-id, dc-os, dc-os-version
    authHeader = {
      "Content-Type": "application/json; charset=utf-8",
      "X-Api-Key": '%2BiR%2Ftt9g8E1tk1%2BDCJgiO7i5XrI%3D',
      "X-Requested-With": "XMLHttpRequest",
      "dc-timezone": "-330",
      "Cookie": PrefUtils().getToken(),
      "User-Agent": _authManager.osName.toUpperCase(),
      "Dc-OS": _authManager.osName,
      "Dc-Device": _authManager.dc_device,
      "Dc-Platform": "flutter",
      "Dc-OS-Version": _authManager.platformVersion,
      "DC-UUID": "",
      "Dc-App-Version": "6"
    };
    return authHeader!;
  }

  dynamic getHeadersPart() {
    //dc-device-id, dc-os, dc-os-version
    authHeader = {
      "Content-Type": "multipart/form-data",
      "X-Api-Key": '%2BiR%2Ftt9g8E1tk1%2BDCJgiO7i5XrI%3D',
      "X-Requested-With": "XMLHttpRequest",
      "dc-timezone": "-330",
      "Cookie": PrefUtils().getToken(),
      "User-Agent": _authManager.osName.toUpperCase(),
      "Dc-OS": _authManager.osName,
      "Dc-Device": _authManager.dc_device,
      "Dc-Platform": "flutter",
      "Dc-OS-Version": _authManager.platformVersion,
      "DC-UUID": "",
      "Dc-App-Version": "6"
    };
    return authHeader!;
  }

  //To get the default data without login

  Future<ConfigModel> getConfigInit() async {
    try {
      if (kIsWeb) {
        final response =
            await http.get(Uri.parse(AppUrl.getConfig), headers: cphiHeaders);
        return ConfigModel.fromJson(json.decode(response.body));
      } else {
        final response =
            await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
                .get(Uri.parse(AppUrl.getConfig), headers: cphiHeaders)
                .timeout(const Duration(seconds: 60));
        log("somen ${response.body}");
        return ConfigModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print('excception $e');
      checkException(e);
      rethrow;
    }
  }

  //to get the static pages content
  Future<PagesModel> getPagesContent(String url) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(
                  Uri.parse(
                    url,
                  ),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      return PagesModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<LoginResponseModel?> login(dynamic body, String url) async {
    print("request  ${body}");

    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: cphiHeaders, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      print("response ${response.body}");
      if (json.decode(response.body)["status"]) {
        PrefUtils().setToken(response.headers['set-cookie'].toString());
      } else {
        PrefUtils().setToken("");
      }
      isDialogShow = false;
      return LoginResponseModel.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<CommonModel> shareVerificationCode(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.shareVerificationCode),
                  headers: cphiHeaders, body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());

      checkException(e);
      rethrow;
    }
  }

//logout the user form the app
  Future<CommonModel> commonGetRequest(url) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(url), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<CommonModel> commonPatchRequest(
      {required jsonBody, required url}) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(jsonBody),
                  Uri.parse(url),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<PostLikeModel> likePost(dynamic body, url) async {
    debugPrint("body-:$body");
    debugPrint("url-:$url");
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      debugPrint("body:${response.body}");
      return PostLikeModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<CommonModel> commonPostRequest(dynamic body, url) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      print("@@@ respomce ${response.body}");
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<BookmarkCommonModel> bookmarkPostRequest(
      dynamic body, dynamic url) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      debugPrint(body.toString());
      debugPrint(url);
      debugPrint(response.body);
      if (BookmarkCommonModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkCommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SaveQuestionModel> saveAskQuestionApi(
      dynamic requestBody, dynamic url) async {
    debugPrint(url);
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(url),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      if (SaveQuestionModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SaveQuestionModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<AskQuestionModel> getAskedQuestionList(
      dynamic requestBody, dynamic url) async {
    debugPrint(url);
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(url),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (AskQuestionModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return AskQuestionModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<BookmarkCommonModel> bookmarkPutRequest(
    dynamic body,
    dynamic url,
  ) async {
    try {
      debugPrint(url.toString());
      debugPrint(jsonEncode(body));
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.commonBookmarkApi),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      debugPrint("somen ${jsonEncode(response.body)}");

      if (BookmarkCommonModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkCommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<CommonDocumentModel> getCommonDocument(dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getCommonDocument),
                  body: jsonEncode(jsonRequest), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      Logger.log("common doc ${response.body}");
      if (CommonDocumentModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return CommonDocumentModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ParentCommonDocumentModel> getCommonResourceList(
      dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getCommonDocument),
                  body: jsonEncode(jsonRequest), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      Logger.log("common doc ${response.body}");
      if (ParentCommonDocumentModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ParentCommonDocumentModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  ///get list of bookmark ids
  Future<BookmarkIdsModel> getBookmarkIds(dynamic body) async {
    debugPrint("sam $body");
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.commonListByItemIds),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BookmarkIdsModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return BookmarkIdsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  //get list of blocked ids
  Future<BookmarkIdsModel> getBlockedIds(dynamic body) async {
    debugPrint(jsonEncode(body));
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.blockListByItemIds),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BookmarkIdsModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return BookmarkIdsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  ///its used for the recommondation
  Future<BookmarkIdsModel> getRecommendedIds(dynamic body, dynamic url) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(body: jsonEncode(body), Uri.parse(url), headers: getHeaders())
          .timeout(const Duration(seconds: 30));
      if (BookmarkIdsModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return BookmarkIdsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<SignupResponseModel?> signupApi(
      dynamic body, List<dynamic> list) async {
    final uri = Uri.parse(AppUrl.signup);
    final req = http.MultipartRequest("POST", uri);

    req.headers.addAll(cphiHeaders);

    if (list.isNotEmpty) {
      for (var formData in list) {
        if (formData.file != null) {
          final mimeTypeData = lookupMimeType(formData.file!.path ?? "",
                  headerBytes: [0xFF, 0xD8])!
              .split('/');
          req.files.add(await http.MultipartFile.fromPath(
              formData.name ?? "avatar", formData.file!.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
        }
      }
    }
    req.fields.addAll(body);
    try {
      http.Response response = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 30)));
      return SignupResponseModel.fromJson(
          json.decode(response.body.toString()));
    } catch (e) {
      checkException(e);
    }
    return null;
  }

  Future<CreateProfileModel?> profileField(apiUrl) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(apiUrl), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (CreateProfileModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CreateProfileModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ProfileUpdateModel?> updateProfile(dynamic body, apiUrl) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(apiUrl),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (ProfileUpdateModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ProfileUpdateModel.fromJson(json.decode(response.body.toString()));
    } catch (e) {
      debugPrint(e.toString());
      checkException(e);
    }
    return null;
  }

  /*ai realted api*/

  Future<CommonModel> updateLinkedin(requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.updateLinkedin),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 100));
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<AiProfileDataModel> aiProfileGet(requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.aiProfileGet), headers: getHeaders())
              .timeout(const Duration(seconds: 60));
      if (AiProfileDataModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return AiProfileDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<BestForYouDataModel> getAiMatchmakingLinkedin(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.aiMatchDataUrl),
                  body: jsonEncode(body), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BestForYouDataModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }

      return BestForYouDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<RecommendedModel> getRecommendedApi() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.recommended), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (RecommendedModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return RecommendedModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<CommonModel> aiMessageLinkedin() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.aiProfileMessage), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ProfileUpdateModel?> updateImage(dynamic imagePath) async {
    final uri = Uri.parse(AppUrl.updatePicture);
    final req = http.MultipartRequest("POST", uri);
    final mimeTypeData =
        lookupMimeType(imagePath ?? "", headerBytes: [0xFF, 0xD8])!.split('/');
    if (imagePath.toString().isNotEmpty) {
      req.files.add(await http.MultipartFile.fromPath("avatar", imagePath,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
    }
    req.headers.addAll(getHeadersPart());
    try {
      http.Response response = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 30)));
      return ProfileUpdateModel.fromJson(json.decode(response.body.toString()));
    } catch (e) {
      debugPrint(e.toString());
      checkException(e);
    }
    return null;
  }

  Future<ProfileUpdateModel?> removeImage() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode({"avatar": ""}),
                  Uri.parse(AppUrl.updatePicture),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      return ProfileUpdateModel.fromJson(json.decode(response.body.toString()));
    } catch (e) {
      debugPrint(e.toString());
      checkException(e);
    }
    return null;
  }

  Future<ProfileModel> getProfile() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getProfileData),
                  body: jsonEncode({"id": "", "role": "", "mine": true}),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (ProfileModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ProfileModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  //get to my notes
  Future<NotesModel> getMyNotes() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.getMyNoteCount), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (NotesModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return NotesModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SignupCategoryModel?> getSignupCategory() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.signupCategory), headers: cphiHeaders)
              .timeout(const Duration(seconds: 30));
      return SignupCategoryModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<StateResponseModel?> getStateByCountry(String country) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getStatesByCountry),
                  body: jsonEncode({"country": country}), headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      return StateResponseModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<CityResponseModel?> getCityByCountry(
      String country, String state) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getCityByState),
                  body: jsonEncode({"country": country, "state": state}),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      return CityResponseModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<HomePageModel> getHomePageData() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.getConfigDetail), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      log("somen getHomePageData ${response.body}");
      if (HomePageModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return HomePageModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }


  Future<HomeSponsorsPartnerListModel> homeSponsorsPartnersListApi(
      dynamic requestBody) async {
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getPartnerList),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      if (HomeSponsorsPartnerListModel.fromJson(json.decode(response.body))
              .code ==
          440) {
        tokenExpire();
      }
      return HomeSponsorsPartnerListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<AllSponsorsPartnerListModel> allSponsorsPartnersListApi(
      dynamic requestBody) async {
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getPartnerList),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      if (AllSponsorsPartnerListModel.fromJson(json.decode(response.body))
              .code ==
          440) {
        tokenExpire();
      }
      return AllSponsorsPartnerListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }


  Future<TimezoneModel> getTimezone() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse("${AppUrl.timezone}/get"), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (TimezoneModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return TimezoneModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  /*Exhibitor api*/
  Future<ExhibitorsModel> getExhibitorsList(dynamic body, dynamic url) async {

    print(" @@@12 ${jsonEncode(body)}");
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      if (ExhibitorsModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ExhibitorsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ExhibitorsFilterModel> getExhibitorsFilterList(requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.exhibitorsListApi}/getFilters"),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      if (ExhibitorsFilterModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ExhibitorsFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ExhibitorsDetailsModel> getExhibitorsDetail(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.exhibitorsListApi}/get"),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ExhibitorsDetailsModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ExhibitorsDetailsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ExhibitorsDocumentModel> getExhibitorsDocument(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.exhibitorsVideoApi),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ExhibitorsDocumentModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ExhibitorsDocumentModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ExhibitorTeamListModel> getExhibitorsRepresentatives(
      dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.exhibitorsRepresentativesApi),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);

      if (ExhibitorTeamListModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ExhibitorTeamListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  /*product*/
  Future<ProductListModel> getProductList(dynamic body, dynamic url) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      if (ProductListModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ProductListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ProductExhibitorModel> getProductExhibitor(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getProductExhibitor),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ProductExhibitorModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ProductExhibitorModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ProductFilterModel> getFilterProduct(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getProductFilter),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ProductFilterModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      //_authManager.saveToken(response.headers['set-cookie']);
      return ProductFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ProductDetailModel> getProductDetail(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getProductDetail),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ProductDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ProductDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  /*representative*/
  Future<TimeslotModel> getTimeslot(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingSlotsGet),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (TimeslotModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return TimeslotModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<MeetingModel> getMeetingList(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingsSearch),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (MeetingModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return MeetingModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<MeetingFilterModel> getMeetingFilterList(dynamic requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingFilter),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (MeetingFilterModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return MeetingFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<MeetingDetailModel> getMeetingDetail(dynamic body) async {
    Logger.log(body);
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingDetail),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (MeetingDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return MeetingDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<MeetingParticipantModel> getMeetingParticipant(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingsParticipants),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (MeetingParticipantModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return MeetingParticipantModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<ColleaguesModel> getColleaguesList(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.userMeetingColleagues),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ColleaguesModel.fromJson(json.decode(response.body)).head?.code ==
          440) {
        tokenExpire();
      }
      return ColleaguesModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  /*start for speakers module*/
  Future<SpeakersModel> getSpeakersApi(dynamic body, dynamic apiUrl) async {
    debugPrint("speaker data-:${jsonEncode(body)}");
    debugPrint("speaker data-:$apiUrl");

    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(apiUrl),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      debugPrint("speaker data somen -:${response.body}");

      if (SpeakersModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SpeakersModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SpeakersDetailModel> getSpeakerDetail(dynamic body) async {
    try {
      
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.usersListApi}/get"),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      //_authManager.saveToken(response.headers['set-cookie']);
      print("@@@ ${response.body}");
      if (SpeakersDetailModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return SpeakersDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SpeakerSessionModel> getSpeakerSession(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.sessionBySpeakerId),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      //_authManager.saveToken(response.headers['set-cookie']);
      if (SpeakerSessionModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return SpeakerSessionModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ContactListModel> getContactList(dynamic body) async {

    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.contactListApi),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ContactListModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ContactListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<RepresentativeFilterModel> getRepresentativeFilterList(
      Map<String, String> requestBody) async {
    log("sam getRepresentativeFilterList ${requestBody}");
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.usersListApi}/getFilters"),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      log("sam getRepresentativeFilterList ${response.body}");
      if (RepresentativeFilterModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return RepresentativeFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  ///
  Future<UserCountModel> getUserCountApi(dynamic body, dynamic url) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      Logger.log(response.body);

      if (UserCountModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return UserCountModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<UserDetailModel> getUserDetail(dynamic body) async {
    print("@@@ ${body}");
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.usersListApi}/get"),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      print("@@@ ${response.body}");
      //_authManager.saveToken(response.headers['set-cookie']);
      if (UserDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return UserDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      print("@@@ ${e}");
      checkException(e);
      rethrow;
    }
  }

  Future<CommonModel> blockUnBlock(dynamic body) async {
    Logger.log("${AppUrl.blockUnblockUser}/save");
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse("${AppUrl.blockUnblockUser}/save"),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (UserDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<CommonModel> saveCommonNotes(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.saveNotes),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);

      if (UserDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

//get save notes by user_id
  Future<CommonNotesModel> getUserNotes(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getNotes),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      debugPrint("notes ${response.body}");
      if (CommonNotesModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return CommonNotesModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  //navigation item api
  Future<MenuDataModel> getMenuNavigation() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.navigationsMenu), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (MenuDataModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return MenuDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  //navigation item api
  Future<dynamic> commonPostApi({requestBody, url}) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(url),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      if (json.decode(response.body)["code"] == 440) {
        tokenExpire();
      }
      return response.body;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }
  //navigation item api
  Future<dynamic> commonGetApi({url}) async {
    try {
      final response =
      await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url),
          headers: getHeaders())
          .timeout(const Duration(seconds: 30));
      if (json.decode(response.body)["code"] == 440) {
        tokenExpire();
      }
      return response.body;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  // Delete saved note api
  Future<CommonNotesModel> deleteSavedNote(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.deleteNote),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (CommonNotesModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return CommonNotesModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<RepresentativeModel> getUserList(dynamic body, dynamic url) async {
    debugPrint("requestBody-:${jsonEncode(body)}");
    debugPrint("requestBody-:${url}");
    print("Entertainment ${body}");
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (RepresentativeModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return RepresentativeModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  /*my event bookmark*/
  Future<BookmarkSpeakerModel> getBookmarkUser(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.getBookmarkUser),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (BookmarkSpeakerModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkSpeakerModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<BookmarkSpeakerModel> getBookmarkSpeaker(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.getBookmarkSpeaker),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BookmarkSpeakerModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkSpeakerModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<BookmarkProductModel> getBookmarkProduct(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.myBookmarkProduct),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BookmarkProductModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkProductModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  Future<BookmarkExhibitorModel> getBookmarkExhibitor(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(body),
                  Uri.parse(AppUrl.getBookmarkExhibitor),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (BookmarkExhibitorModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkExhibitorModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);

      rethrow;
    }
  }

  //realted to chat
  Future<CreateRoomModel> sendFirstMessage(
    dynamic requestBody,
  ) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(requestBody),
                  Uri.parse(AppUrl.createRoom),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      if (CreateRoomModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CreateRoomModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<void> sendChatNotification(
    dynamic requestBody,
  ) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(requestBody),
                  Uri.parse(AppUrl.sendChatNotification),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ChatRequestModel> sendChatRequest(
    dynamic requestBody,
  ) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(requestBody),
                  Uri.parse(AppUrl.sendChatRequest),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (ChatRequestModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ChatRequestModel.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<ChatRequestStatusModel> chatRequestStatus(
    dynamic requestBody,
  ) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(requestBody),
                  Uri.parse(AppUrl.getChatRequestStatus),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (ChatRequestStatusModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ChatRequestStatusModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ChatRequestAcceptModel> takeChatRequestAction(
    dynamic requestBody,
  ) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(requestBody),
                  Uri.parse(AppUrl.takeChatRequestAction),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      debugPrint(response.body);

      if (ChatRequestAcceptModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return ChatRequestAcceptModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  //related to ai frame and  html content
  Future<PhotoboothModel> getPhotobooth() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.photobooth), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (PhotoboothModel.fromJson(json.decode(response.body)).head?.code ==
          440) {
        tokenExpire();
      }
      return PhotoboothModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<VideoModel> eventVideoList(dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.eventVideoList),
                  body: jsonEncode(jsonRequest), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (VideoModel.fromJson(json.decode(response.body)).head?.code == 440) {
        tokenExpire();
      }
      return VideoModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<FaqModel> getFaqList(dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.faqList), headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      if (FaqModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return FaqModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SOSDataModel> getSOSData(dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.sos), headers: getHeaders())
              .timeout(const Duration(seconds: 30));

      if (SOSDataModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SOSDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<TipsDataModel> getTipsData(dynamic jsonRequest) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.tips), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (TipsDataModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return TipsDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<IFrameModel> getIframe({slug}) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse("${AppUrl.iframe}/$slug"), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (IFrameModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }

      return IFrameModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  //my qr page start
  Future<UniqueCodeModel> getUniqueCode() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.getUserCode), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (UniqueCodeModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return UniqueCodeModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<BadgeModel> getBadge() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getBadge),
                  headers: getHeaders(),
                  // body: jsonEncode({"type": "badge"})
                  body: jsonEncode({"type": "mbadge"}))
              .timeout(const Duration(seconds: 30));
      if (BadgeModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return BadgeModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<QrScannedUserDetailsModel> getUserDetailByCode(uniqueCode) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  // body: jsonEncode({"code": uniqueCode, "type": "qrcode"}),
                  body: jsonEncode({"qrcode": uniqueCode}),
                  Uri.parse(AppUrl.getUserDetail),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (QrScannedUserDetailsModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return QrScannedUserDetailsModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<UniqueCodeModel> saveUserToContact({jsonRequest}) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(jsonRequest),
                  Uri.parse(AppUrl.saveContact),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (UniqueCodeModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return UniqueCodeModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<ExportModel> exportContact() async {
    try {
      var jsonRequest = {
        "page": 1,
        "filters": {"type": "all", "search": ""},
        "export": 1
      };
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(
                  body: jsonEncode(jsonRequest),
                  Uri.parse(AppUrl.exportContact),
                  headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (ExportModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ExportModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<FilterContactModel> getFilterContact() async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .get(Uri.parse(AppUrl.contactListFiltersApi), headers: getHeaders())
          .timeout(const Duration(seconds: 30));
      if (FilterContactModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return FilterContactModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  /*session module start*/
  Future<ScheduleModel> getSessionList(dynamic body, dynamic apiUrl) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(apiUrl),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (ScheduleModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ScheduleModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<SpeakerModelWebinarModel> getSpeakerWebinarList(
      dynamic body, dynamic apiUrl) async {
    Logger.log(jsonEncode("requestBody-:$body"));
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(apiUrl),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      debugPrint("apiUrl${apiUrl}");
      debugPrint(response.body);
      if (SpeakerModelWebinarModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return SpeakerModelWebinarModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<ScheduleModel> getTodaySession() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getSession),
                  headers: getHeaders(),
                  body: jsonEncode({
                    "page": 1,
                    "favourite": 0,
                    "filters": {
                      "params": {"status": 1}
                    }
                  }))
              .timeout(const Duration(seconds: 30));
      if (ScheduleModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return ScheduleModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  Future<CommonModel> seatBook(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.seatBooking),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SessionDetailModel> getSessionDetail(dynamic body) async {
    Logger.log(body);
    Logger.log(AppUrl.getSessionDetail);
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getSessionDetail),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      log("getSessionDetail ${response.body}");
      if (SessionDetailModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      Logger.log(response.body);
      return SessionDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SessionFilterModel> getSessionsFilter(dynamic url) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(url), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (SessionFilterModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SessionFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SessionPollStatus> getPollStatus(dynamic body, dynamic url) async {
    try {
      Logger.log(body);
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      print("@@ ${response.body}");
      if (SessionPollStatus.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SessionPollStatus.fromJson(json.decode(response.body));
    } catch (e) {
      return SessionPollStatus(status: false);
      checkException(e);
      rethrow;
    }
  }

  Future<PollsSubmitModel> submitPolls(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.savePolls),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (PollsSubmitModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return PollsSubmitModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SessionBookmarkModel?> getBookmarkSessionApi(dynamic body) async {
    Logger.log(jsonEncode(body));
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getSession),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (SessionBookmarkModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return SessionBookmarkModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<QuestionListModel> getFeedbackList(String url, dynamic body) async {
    debugPrint("url $url");
    debugPrint("feedback ${jsonEncode(body).toString()}");
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      if (QuestionListModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return QuestionListModel.fromJson(json.decode(response.body));
    } catch (e) {
      return QuestionListModel(
          body: [],
          message: "something_went_wrong".tr,
          status: false,
          code: 200);
    }
  }

  Future<CreatePostModel?> createEventFeed(
      dynamic body, XFile? file, File? thumbnailFile, String? type) async {
    final uri = Uri.parse(AppUrl.feedCreate);
    final req = http.MultipartRequest("POST", uri);

    if (file != null && file.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');
      if (type == "image" || type == "document") {
        req.files.add(await http.MultipartFile.fromPath("media", file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      } else {
        if (thumbnailFile != null) {
          final mimeTypeData =
              lookupMimeType(thumbnailFile.path, headerBytes: [0xFF, 0xD8])!
                  .split('/');
          req.files.add(await http.MultipartFile.fromPath(
              "media", thumbnailFile.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
          req.files.add(await http.MultipartFile.fromPath("video", file.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
        }
      }
    }

    print("event feed thumbnailFile ${thumbnailFile?.path}");
    print("event feed thumbnailFile ${file?.path}");

    req.fields.addAll(body);
    req.headers.addAll(getHeaders());
    try {
      //final response =
      http.Response response1 = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 120)));
      if (CreatePostModel.fromJson(json.decode(response1.body)).code == 440) {
        tokenExpire();
      }
      return CreatePostModel.fromJson(json.decode(response1.body.toString()));
    } catch (e) {
      print(e.toString());
      checkException(e);
    }
    return null;
  }

  Future<FeedDataModel> getFeedList(dynamic requestBody) async {
    debugPrint("request feed ${requestBody}");
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.feedGetList),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      debugPrint("response ${response.body}");

      if (FeedDataModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }

      return FeedDataModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<CreateCommentModel> createFeedComment(dynamic requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.feedCommentGetCreate),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      if (CreateCommentModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CreateCommentModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<FeedCommentModel> getFeedCommentList(dynamic requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.feedCommentGet),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));
      debugPrint(response.body);
      if (FeedCommentModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return FeedCommentModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<LikeFeedModel> getFeedLikeList(dynamic requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.feedEmotionsGet),
                  headers: getHeaders(), body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 30));

      if (LikeFeedModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return LikeFeedModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<PhotoListModel> getAiPhotoList(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.eventPhotoListApi),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (PhotoListModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return PhotoListModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<MyPhotoModel?> searchAiPhoto(dynamic body, String imageFile) async {
    final uri = Uri.parse(AppUrl.seachAiPhototApi);
    final req = http.MultipartRequest("POST", uri);
    if (true) {
      final mimeTypeData =
          lookupMimeType(imageFile ?? "", headerBytes: [0xFF, 0xD8])!
              .split('/');
      req.files.add(await http.MultipartFile.fromPath("image", imageFile,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
    }
    req.fields.addAll(body);
    req.headers.addAll(authHeader);
    try {
      http.Response response = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 50)));
      debugPrint("112->ai search ${response.body}");
      return MyPhotoModel.fromJson(json.decode(response.body.toString()));
    } catch (e) {
      checkException(e);
      debugPrint(e.toString());
    }
    return null;
  }

  Future<CommonModel?> uploadImage(dynamic type, dynamic imageFile) async {
    final uri = Uri.parse(AppUrl.uploadAiPhoto);
    final req = http.MultipartRequest("POST", uri);
    if (true) {
      if (imageFile != null) {
        final mimeTypeData =
            lookupMimeType(imageFile ?? "", headerBytes: [0xFF, 0xD8])!
                .split('/');
        req.files.add(await http.MultipartFile.fromPath("image", imageFile,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }
    }
    req.fields.addAll({"type": /*type*/ "file"});
    req.headers.addAll(authHeader);
    try {
      http.Response response = await http.Response.fromStream(
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .send(req)
              .timeout(const Duration(seconds: 50)));
      return CommonModel.fromJson(json.decode(response.body.toString()));
    } catch (e) {
      checkException(e);
      UiHelper.showFailureMsg(null, e.toString());
      debugPrint(e.toString());
    }
    return null;
  }

  ///get angel ally*/
  Future<ShiftingDetailModel> getShiftingDetail() async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .get(Uri.parse(AppUrl.shiftingDetail), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (ShiftingDetailModel.fromJson(json.decode(response.body)).head?.code ==
          440) {
        tokenExpire();
      }
      return ShiftingDetailModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  ///get the list of start networking
  Future<StartNetworkingModel> getAspireSearch(requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.searchAspireList),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (StartNetworkingModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return StartNetworkingModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  ///get the detail of start networking
  Future<StartNetworkingModel> getAspireDetails(requestBody) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.searchAspireList),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (StartNetworkingModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return StartNetworkingModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  ///get booking slot of start networking
  Future<StartNetworkingSlot> startNetworkingSlot(requestBody) async {
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.getAspireUserSlot),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      debugPrint(response.body.toString());
      if (StartNetworkingSlot.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return StartNetworkingSlot.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  ///appoinment of start networking
  Future<BookmarkCommonModel> bookAspireAppointment(requestBody) async {
    debugPrint(requestBody.toString());
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.bookAspireAppointmentUrl),
                  body: jsonEncode(requestBody), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      debugPrint(response.body.toString());
      if (BookmarkCommonModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return BookmarkCommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  ///get the angel list
  Future<AngelAllyModel> getAngelAllyHallList(
      dynamic body, dynamic apiUrl) async {
    Logger.log(jsonEncode(body));
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(apiUrl),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      Logger.log(response.body);
      if (AngelAllyModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return AngelAllyModel.fromJson(json.decode(response.body));
    } catch (e) {
      Logger.log(e.toString());
      checkException(e);
      rethrow;
    }
  }

  ///get the angel detail by id
  Future<AngelAllyModel> getAngelAllyDetail({payload, url}) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(url),
                  body: jsonEncode(payload), headers: getHeaders())
              .timeout(const Duration(seconds: 30));
      if (AngelAllyModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      //print(response.body);
      return AngelAllyModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  ///get meeting filter
  Future<CommonModel> bookSessionSeat(dynamic body) async {
    try {
      final response =
          await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
              .post(Uri.parse(AppUrl.bookSessionSeat),
                  headers: getHeaders(), body: jsonEncode(body))
              .timeout(const Duration(seconds: 30));
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return CommonModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<SessionFilterModel> getBookingSessionsFilter() async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .get(Uri.parse(AppUrl.bookingSessionsFilter), headers: getHeaders())
          .timeout(const Duration(seconds: 30));
      if (SessionFilterModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return SessionFilterModel.fromJson(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  /*used this for the common post method*/
  Future<dynamic> dynamicPostRequest({dynamic body, url}) async {
    try {
      final response = await DigestAuthClient(
          DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: getHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      print(response.body);
      if (CommonModel.fromJson(json.decode(response.body)).code == 440) {
        tokenExpire();
      }
      return response.body;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  tokenExpire() {
    if (isDialogShow) {
      return;
    }
    isDialogShow = true;
    Get.defaultDialog(
        backgroundColor: white,
        title: "",
        // titleStyle: const TextStyle(color: Colors.black),
        barrierDismissible: false,
        // middleTextStyle: const TextStyle(color: Colors.black),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomTextView(
              fontSize: 22,
              textAlign: TextAlign.center,
              text: "Login Expired",
              fontWeight: FontWeight.bold,
              maxLines: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextView(
              fontSize: 16,
              textAlign: TextAlign.center,
              text:
                  "You have either logged out or you were automatically logged out for security purposes",
              fontWeight: FontWeight.normal,
              maxLines: 4,
            ),
            const SizedBox(
              height: 20,
            ),
            MyRoundedButton(
                height: 50,
                textSize: 16,
                text: "Login Again",
                color: colorPrimary,
                press: () {
                  PrefUtils().setToken("");
                  Get.offNamedUntil(Routes.LOGIN, (route) => false);
                }),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
        radius: 10);
  }

  void checkException(Object exception) {
    if (exception is ServerException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Http status error [500]",
        (exception).message.toString(),
      );
      print((exception).statusCode);
    } else if (exception is ClientException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Http status error [500]",
        (exception as ServerException).message.toString(),
      );
    } else if (exception is HttpException) {
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        "Network",
        "Please check your internet connection.",
      );
    } else {
      UiHelper.isNoInternet();
    }
  }

  Future<ApiResponse<T>> fetchPostApiData<T>(String url,
      T Function(Map<String, dynamic>) decoder, dynamic body) async {
    try {
      final response = await DigestAuthClient(
              DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(url), headers: cphiHeaders, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      if (RepresentativeModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      dynamic jsonData = jsonDecode(response.body);
      T data = decoder(jsonData);
      return ApiResponse(
          data: data, statusCode: response.statusCode, error: null);
    } catch (e) {
      return ApiResponse(
          data: decoder(<String, dynamic>{}),
          statusCode: 500,
          error: "Something went wrong, please try again.");
    }
  }

  Future<GalleryModel> getGalleryList({required int page, required String type, String text = ""}) async {
    try {
      // Create the request payload
      Map<String, dynamic> jsonRequest = {
        "page": page,
        "type": type,
        "text": text,
      };

      print(jsonRequest);

      final response = await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(AppUrl.getBriefcases), headers: getHeaders(), body: jsonEncode(jsonRequest))
          .timeout(const Duration(seconds: 20));
      print(response.body);

      // Parse the response
      GalleryModel galleryData = GalleryModel.fromJson(json.decode(response.body));

      // Check if the token is expired
      if (galleryData.code == 440) {
        tokenExpire();
      }

      return galleryData;
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<LeaderBoardModel> getLeaderboard({body}) async {
    try {
      final response =
      await DigestAuthClient(DIGEST_AUTH_USERNAME, DIGEST_AUTH_PASSWORD)
          .post(Uri.parse(AppUrl.leaderBoardApi),body: jsonEncode(body), headers: getHeaders())
          .timeout(const Duration(seconds: 20));
      if (LeaderBoardModel.fromJson(json.decode(response.body)).code ==
          440) {
        tokenExpire();
      }
      return LeaderBoardModel.fromJson(json.decode(response.body));
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

}

class ApiResponse<T> {
  final T data;
  final int statusCode;
  final String? error;

  ApiResponse({this.error, required this.data, required this.statusCode});
}
