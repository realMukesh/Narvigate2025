import 'package:get_storage/get_storage.dart';


enum CacheManagerKey {
  FCMTOKEN,
  USERNAME,
  USER_ID,
  PROFILE,
  NAME,
  IMAGE,
  ROLE,
  IS_REMEMBER,
  TIMEZONE,
  dreamcast_chat_id,
  EMAIL,
  COMPANY,
  ASSOCIATION,
  POSITION,
  FEED_EMAIL,
  URL,
  QR_CODE,
  IS_CHAT,
  IS_MEETINGS,
  IS_ISPROFILE
}

mixin CacheManager {
  Future<bool> saveFcmToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.FCMTOKEN.toString(), token);
    return true;
  }

  String? getFcmToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.FCMTOKEN.toString());
  }

  Future<bool> saveAuthToken(String? token) async {
    final box = GetStorage();
    await box.write("auth_token", token);
    return true;
  }

  String? getAuthToken() {
    final box = GetStorage();
    return box.read("auth_token");
  }

  Future<bool> saveQRCode(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.QR_CODE.toString(), token);
    return true;
  }

  String? getQRCode() {
    final box = GetStorage();
    return box.read(CacheManagerKey.QR_CODE.toString());
  }

  Future<bool> saveBaseUrl(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.URL.toString(), token);
    return true;
  }

  Future<bool> saveFeedEmail(String? email) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.FEED_EMAIL.toString(), email);
    return true;
  }

  String? getBaseUrl() {
    final box = GetStorage();
    return box.read(CacheManagerKey.URL.toString());
  }

  Future<bool> saveProfileData(
      {required String fullName,
      required String username,
      required String profile,
      required String role,
      required String userId,
      required String chatId,
      required String email,
      required String category,
        required String company,
        required String association,
        required String position,
      }) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.NAME.toString(), fullName);
    await box.write(CacheManagerKey.USERNAME.toString(), username);
    await box.write(CacheManagerKey.PROFILE.toString(), profile);
    await box.write(CacheManagerKey.ROLE.toString(), role);
    await box.write(CacheManagerKey.USER_ID.toString(), userId);
    await box.write(CacheManagerKey.dreamcast_chat_id.toString(), chatId);
    await box.write(CacheManagerKey.EMAIL.toString(), email);
    await box.write(CacheManagerKey.COMPANY.toString(), company);
    await box.write(CacheManagerKey.ASSOCIATION.toString(), association);
    await box.write(CacheManagerKey.POSITION.toString(), position);
    await box.write("category", category);

    return true;
  }

  Future<bool> savePrivacyData(
      {required bool isChat,
      required bool isMeeting,
      required bool isProfile}) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.IS_CHAT.toString(), isChat);
    await box.write(CacheManagerKey.IS_MEETINGS.toString(), isMeeting);
    await box.write(CacheManagerKey.IS_ISPROFILE.toString(), isProfile);
    return true;
  }

  Future<bool> saveLinkedUrl(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.URL.toString(), token);
    return true;
  }

  String? getLinkedUrl() {
    final box = GetStorage();
    return box.read(CacheManagerKey.URL.toString());
  }

  String? getCategory() {
    final box = GetStorage();
    return box.read("category");
  }

  String? getDreamcastId() {
    final box = GetStorage();
    return box.read(CacheManagerKey.dreamcast_chat_id.toString());
  }

  String? getAssociation() {
    final box = GetStorage();
    return box.read(CacheManagerKey.ASSOCIATION.toString());
  }

  String? getCompany() {
    final box = GetStorage();
    return box.read(CacheManagerKey.COMPANY.toString());
  }

  String? getPosition() {
    final box = GetStorage();
    return box.read(CacheManagerKey.POSITION.toString());
  }

  bool? isMeeting() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IS_MEETINGS.toString());
  }

  bool? isChat() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IS_CHAT.toString());
  }

  String? getEmail() {
    final box = GetStorage();
    return box.read(CacheManagerKey.EMAIL.toString());
  }

  String? getFeedEmail() {
    final box = GetStorage();
    return box.read(CacheManagerKey.FEED_EMAIL.toString());
  }

  bool? isProfile() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IS_ISPROFILE.toString());
  }

  Future<bool> saveProfileImage(String? profile) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.PROFILE.toString(), profile);
    return true;
  }


  String? getUsername() {
    final box = GetStorage();
    return box.read(CacheManagerKey.USERNAME.toString());
  }

  String? getUserId() {
    final box = GetStorage();
    return box.read(CacheManagerKey.USER_ID.toString());
  }

  bool? isRememberLogin() {
    final box = GetStorage();
    return box.read(CacheManagerKey.IS_REMEMBER.toString());
  }

  String? getName() {
    final box = GetStorage();
    return box.read(CacheManagerKey.NAME.toString()) ?? "";
  }

  String? getImage() {
    final box = GetStorage();
    return box.read(CacheManagerKey.PROFILE.toString()) ?? "";
  }

  String? getRole() {
    final box = GetStorage();
    return box.read(CacheManagerKey.ROLE.toString()) ?? "user";
  }

  Future<bool> saveTimezone(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TIMEZONE.toString(), token);
    return true;
  }
  String? getTimezone() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TIMEZONE.toString());
  }

  Future<bool> saveExhibitorType(String? type) async {
    final box = GetStorage();
    await box.write("exhibitor_type", type);
    return true;
  }
  String? getExhibitorType() {
    final box = GetStorage();
    return box.read("exhibitor_type");
  }

  Future<bool> setProfileUpdate(int isProfile) async {
    final box = GetStorage();
    await box.write("is_profile_update", isProfile);
    return true;
  }

  int getProfileUpdate() {
    final box = GetStorage();
    return box.read("is_profile_update") ?? 0;
  }
}
