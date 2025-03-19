class AppUrl {
  ///hello this is my last commit
  ///firebase base url config
  static String appName = "dreamcast2024";

  /*used for the dynamic base url*/
  static const eventAppNode = "EventAppBaseUrl";
  static String defaultNodeName = "narvigate2025";

  ///firebase database url dynamic updater from splash controller
  static String setDataBaseUrl =
      "https://cto-talks-webapp-default-rtdb.asia-southeast1.firebasedatabase.app";
  static String setDefaultFirebaseNode = "eappnarvigate2025prod";
  static String setTopicName = "EVENTAPP_NARVIGATE_2024";

  static String get dataBaseUrl => setDataBaseUrl;
  static String get defaultFirebaseNode => setDefaultFirebaseNode;
  static String get topicName => setTopicName;

  /****************dynamic base url updated from the auth manager*****/

  static String baseURLV1 =
      'https://eappsapi.vehub.live/narvigate_2025/api/v1'; // production

  // static String baseURLV1 =
  //     'https://live.dreamcast.in/narvigate_2025/api/v1';   /// staging url


  /* static String baseURLV1 =
      'https://development.dreamcast.in/dreamcast_2025/api/v1'; // development url*/

  /****************api link stating************************************/

  ///its is used for the load the splash url
  static String splashDynamicImage =
      "${baseURLV1.replaceAll("/v1", "")}/cli/v1/event/splash";

  static String chatConversation = "chat_rooms/conversations";

  static String chatUsers = "chat_rooms/users";

  static String get login => '$baseURLV1/signin';

  static String get loginByOTP => '$baseURLV1/signin/byVerificationCode';

  static String get shareVerificationCode => '$baseURLV1/signin/verifyUsername';

  static String get signupCategory => '$baseURLV1/signup/getCategories';

  static String get aboutUs => '$baseURLV1/cms/getAboutUs';

  static String get getWhyIndia => '$baseURLV1/cms/getWhyIndia';

  static String get getGlance => '$baseURLV1/cms/getGlance';

  static String get engagement => '$baseURLV1/cms/engagement';

  static String get venueManagement => '$baseURLV1/cms/venueManagement';

  static String get signup => '$baseURLV1/signup';

  static String get logoutApi => '$baseURLV1/signout';

  static String get getStatesByCountry => '$baseURLV1/locality/getStates';

  static String get getCityByState => '$baseURLV1/locality/getCities';

  static String get getConfig => '$baseURLV1/event/config';

  static String get timezone => '$baseURLV1/timezones';

  static String get getConfigDetail => '$baseURLV1/home/get';

  static String get getProfileFields => '$baseURLV1/users/getProfileFields';

  static String get getPrivacyPreference =>
      '$baseURLV1/UserPrivacyPreference/getFormFields';

  static String get updatePrivacyPreference =>
      '$baseURLV1/UserPrivacyPreference/updatePreference';

  static String get muteNotification =>
      '$baseURLV1/UserPrivacyPreference/muteNotification';

  static String get getProfileData => '$baseURLV1/users/get';

  static String get getMyNoteCount => '$baseURLV1/users/getMyNoteCount';

  static String get updateProfile => '$baseURLV1/users/updateProfile';

  static String get updatePicture => '$baseURLV1/users/updateProfileAvatar';

  static String get getProductList => '$baseURLV1/exhibitorProducts';

  static String get getProductExhibitor =>
      '$baseURLV1/exhibitorProducts/getRelatedExhibitor';

  static String get commonBookmarkApi => '$baseURLV1/favourites/toggle';

  static String get commonListByItemIds =>
      '$baseURLV1/favourites/listByItemIds';

  static String get blockListByItemIds => '$baseURLV1/blockUsers/listByItemIds';

  /*send request*/
  static String get sendChatRequest => '$baseURLV1/userChatRooms/makeRequest';

  static String get getChatRequestStatus => '$baseURLV1/userChatRooms/get';

  static String get sendChatNotification =>
      '$baseURLV1/userChatRooms/sendChatNotification';

  static String get takeChatRequestAction =>
      '$baseURLV1/userChatRooms/takeRequestAction';

  static String get myBookmarkDocument =>
      '$baseURLV1/userExhibitorDocumentFavourites/get';

  static String get myBookmarkProduct =>
      '$baseURLV1/userExhibitorProductFavourites/get';

  static String get myBookmarkRepresentative =>
      '$baseURLV1/representative/bookmark/get';

  static String get getProductFilter =>
      '$baseURLV1/exhibitorProducts/getFilters';

  static String get getProductDetail => '$baseURLV1/exhibitorProducts/get';

  //send role to body representative
  static String get globalSearchApi => '$baseURLV1/search';

  //send role to body attendee
  static String get usersListApi => '$baseURLV1/users';

  static String get sessionBySpeakerId => '$baseURLV1/webinars/bySpeakerId';

  static String get exhibitorsListApi => '$baseURLV1/exhibitors';

  static String get exhibitorsRepresentativesApi =>
      '$baseURLV1/exhibitors/representatives';

  static String get exhibitorsVideoApi => '$baseURLV1/exhibitorDocuments/get';

  static String get exhibitorsDocumentApi => '$baseURLV1/exhibitor.json/';

  /*Guid and photobooth api*/
  static String get gallery => '$baseURLV1/gallery/get';

  static String get swagBag => '$baseURLV1/guides/search';

  static String get faqList => '$baseURLV1/faqs/get';
  static String get sos => '$baseURLV1/sosContacts/get';
  static String get tips => '$baseURLV1/tips/get';

  //pdf/html url/normal url with login
  static String get iframe => '$baseURLV1/iframe';

  //html content without login
  static String get webview => '$baseURLV1/webview/';

  static String get shiftingDetail => '$baseURLV1/sightseeing/get';

  static String get saveShiftingDetail => '$baseURLV1/sightseeing/save';

  static String get myBookmarkSwagbag => '$baseURLV1/swagBag/bookmark/get';

  static String get feedbackQuestions => '$baseURLV1/feedbacks';

  static String get photobooth => '$baseURLV1/photobooth/get';

  static String get allSponsors => '$baseURLV1/embeded/getSponsors';

  static String get getPartnerList => '$baseURLV1/sponsors/get';

  static String get getPartnerDetails => '$baseURLV1/sponsors/getDetail';

  /*chat module post body{user_id:101, message:"HI"}*/
  static String get createRoom => '$baseURLV1/userChatRooms/makeRequest';

  /*{user_id:101, message:"HI"}*/
  static String get sendFirstMessageOnGroup =>
      '$baseURLV1/chatRooms/sendFirstMessage/group';

  /*availability get request*/
  static String get getMine => '$baseURLV1/userAvailability/getMine';

  /*availability post request*/
  static String get updateMine => '$baseURLV1/userAvailability/updateMine';

  /*availability delete request by id*/
  static String get deleteMine => '$baseURLV1/userAvailability/delete';

  /*timeslot of user meetings*/
  static String get userMeetingSlotsGet => '$baseURLV1/userMeetingSlots/get';

  /*user meetings filter*/
  static String get userMeetingFilter => '$baseURLV1/userMeetings/getFilters';

  /*userMeetings/search*/
  static String get userMeetingsSearch => '$baseURLV1/UserMeetings/search';

  /*User meeting detail by meeting id*/
  static String get userMeetingDetail => '$baseURLV1/userMeetings/get';

  /*ActionAgainstRequest*/
  static String get actionAgainstRequest =>
      '$baseURLV1/userMeetingSlots/actionAgainstRequest';

  /*meting compete action*/
  static String get markMeetingStatus =>
      '$baseURLV1/userMeetings/markMeetingStatus';

  /*ActionAgainstRequest*/
  static String get joinVideoCall => '$baseURLV1/userMeetings/joinVideoCall';

  /*User meeting detail by meeting id*/
  static String get userMeetingsParticipants =>
      '$baseURLV1/userMeetings/participants';

  /*UserMeetingColleagues*/
  static String get userMeetingColleagues =>
      '$baseURLV1/UserMeetingColleagues/get';

  /*sendJoinRequest post request*/
  static String get sendJoinRequest =>
      '$baseURLV1/UserMeetingColleagues/sendJoinRequest';

  /*timeslot of user meetings*/
  static String get bookAppointment =>
      '$baseURLV1/userMeetingSlots/bookAnAppointment';

  /*used for contact section*/
  // static String get contactListApi => '$baseURLV1/UserContacts';  // old url
  static String get contactListApi => '$baseURLV1/qrcode/getMyContacts';

  static String get contactListFiltersApi => '$baseURLV1/qrcode/getFilters';

  static String get getUserCode => '$baseURLV1/UserContacts/getUserCode';

  // static String get getUserDetail => '$baseURLV1/UserContacts/getUserDetails';  // old url
  static String get getUserDetail => '$baseURLV1/qrcode/getUser';

  // static String get saveContact => '$baseURLV1/UserContacts/save'; // old url
  static String get saveContact => '$baseURLV1/qrcode/save';

  // static String get exportContact => '$baseURLV1/UserContacts/exportContact'; // old url
  static String get exportContact => '$baseURLV1/qrcode/getMyContacts';

  static String get blockUnblockUser => '$baseURLV1/blockUsers';

  //getMyQRCodeOrBadge
  // static String get getBadge => '$baseURLV1/userContacts/getMyQRCodeOrBadge'; // old url
  static String get getBadge => '$baseURLV1/qrcode/getMine';

  static String get sessionView => '$baseURLV1/sessions/webview';

  /*session module*/
  static String get getSession => '$baseURLV1/webinars/search';
  static String get getSpeakerByWebinarId => '$baseURLV1/speakers/byWebinarIds';

  static String get webinarEmoticons => '$baseURLV1/webinarEmoticons/save';

  //get live session
  static String get getTodaySession => '$baseURLV1/webinars/getTodaySession';

  /*session detail by session id*/
  static String get getSessionDetail => '$baseURLV1/webinars/get';

  static String get seatBooking => '$baseURLV1/webinars/seatBooking';

  static String get saveAngelAlly => '$baseURLV1/angelAlly/save';

  ///the the filter for the  networking
  static String get getStartNetworkingFilters =>
      '$baseURLV1/startupNetworking/getFilters';

  ///get the list of startupNetworking
  static String get searchAspireList =>
      '$baseURLV1/startupNetworking/getAspire';

  ///get the slot for the meeting
  static String get getAspireUserSlot =>
      '$baseURLV1/networkingMeetingSlots/get';

  ///book the slot for the meeting
  static String get bookAspireAppointmentUrl =>
      '$baseURLV1/networkingMeetingSlots/bookAnAppointment';

  static String get bookSessionSeat =>
      '$baseURLV1/UserSessionBookedSeats/bookSeat';

  static String get sessionSavePolls => '$baseURLV1/WebinarPolls/save';

  static String get sessionIsPollSubmitted =>
      '$baseURLV1/WebinarPolls/isSubmitted';

  static String get savePolls => '$baseURLV1/polls/save';

  static String get isPollSubmitted => '$baseURLV1/polls/isSubmitted';

  static String get askQuestion => '$baseURLV1/askAQuestions';

  static String get sessionsFilter => '$baseURLV1/webinars/getFilters';

  static String get bookingSessionsFilter =>
      '$baseURLV1/UserSessionBookedSeats/getFilters';

  static String get getBookingSeat => '$baseURLV1/UserSessionBookedSeats/get';

  static String get getBookmarkExhibitor =>
      '$baseURLV1/userExhibitorFavourites/get';

  static String get getBookmarkSession =>
      '$baseURLV1/UserSessionFavourites/get';

  static String get getBookmarkUser => '$baseURLV1/userFavourites/get';

  static String get getBookmarkSpeaker => '$baseURLV1/speakerFavourites/get';

  static String get galleryFrame => '$baseURLV1/iframe/gallery';

  static String get deleteAccount => '$baseURLV1/profiles/delete';

  static String get menuStatus => '$baseURLV1/iframe/checkMenuStatus';

  static String get pollStatus => '$baseURLV1/iframe/checkPollStatus';

  static String get feedbackStatus => '$baseURLV1/iframe/checkFeedbackStatus';

  static String get feedGetList => '$baseURLV1/feeds/get';

  static String get feedCreate => '$baseURLV1/feeds/create';

  static String get feedDelete => '$baseURLV1/feeds/trash';

  static String get feedReport => '$baseURLV1/feeds/report';

  static String get videPost => '$baseURLV1/feeds/view';

  static String get feedCommentGet => '$baseURLV1/feedComments/get';

  static String get feedCommentGetCreate => '$baseURLV1/feedComments/create';

  static String get feedCommentGetTrash => '$baseURLV1/feedComments/trash';

  static String get feedCommentGetReply => '$baseURLV1/feedComments/reply';

  static String get feedCommentGetReport => '$baseURLV1/feedComments/report';

  static String get feedEmotionsGet => '$baseURLV1/feedEmoticons/get';

  static String get feedEmotionsToggleMe => '$baseURLV1/feedEmoticons/toggleMe';

  static String get feedEmotionsToggleOther =>
      '$baseURLV1/feedEmoticons/toggleIntoAnother';

  static String get updateFcm => '$baseURLV1/userDevices/subscribe';

  static String get eventVideoList => '$baseURLV1/video/get';

  /*photo booth api*/
  static String get eventPhotoListApi => '$baseURLV1/aiGallery/get';

  static String get seachAiPhototApi => '$baseURLV1/aiGallery/search';

  static String get uploadAiPhoto => '$baseURLV1/aiGallery/upload';

  static String get getState => '$baseURLV1/locality/getStates';

  static String get getCities => '$baseURLV1/locality/getCities';

  static String get getCommonDocument => '$baseURLV1/documents/get';

  static String get saveNotes => '$baseURLV1/notes/save';
  static String get getNotes => '$baseURLV1/notes/getAll';
  static String get deleteNote => '$baseURLV1/notes/delete';

  static String get getBriefcasesIds =>
      '$baseURLV1/userBriefcases/listByBriefcaseIds';

  static String get getBriefcasesToggle => '$baseURLV1/userBriefcases/toggle';

  static String get getBriefcasesBookmarkList =>
      '$baseURLV1/userFavouritesBriefcase/get';

  ///ai related api
  static String get updateLinkedin => '$baseURLV1/Onepage/updateLinkedin';

  static String get aiProfileGet => '$baseURLV1/Onepage/aiProfileGet';

  static String get aiMatchDataUrl => '$baseURLV1/Onepage/aiMatchmaking';

  static String get recommended => '$baseURLV1/recommended/get';

  static String get aiProfileMessage => '$baseURLV1/Onepage/aiProfileMessage';

  /*api slug data*/
  static String get homeBanner => 'home_banner';
  static String get webinarBanner => 'webinar_banner';
  static String get event => 'event';
  static String get document => 'document';
  static String get exhibitorDocument => 'exhibitor';

  static String get navigationsMenu => '$baseURLV1/navigations/get';

  static String get linkedInLoginApi => '$baseURLV1/signin/byLinkedinToken';

  static String get mindmixer => 'https://staging-mindmixer.godreamcast.com/mm_saasboomi_2025/#/onboarding/login/by/token/Yx68HXlV61GBLOqAcjmNjUDZU53DNjQfSWNrdtoKZ1V6KvTnmqJ-4JpU7hXEYSU6';

  static String get leaderBoardApi => '$baseURLV1/leaderboard/get';

  static String get getBriefcases => '$baseURLV1/briefcases/search';

}

/// new commmit
