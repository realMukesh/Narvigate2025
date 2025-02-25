import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/quiz/view/feedback_page.dart';
import 'package:dreamcast/view/schedule/view/session_list_page.dart';
import 'package:dreamcast/view/speakers/controller/speakersController.dart';
import 'package:get/get.dart';
import '../../theme/ui_helper.dart';
import '../alert/pages/alert_dashboard.dart';
import '../beforeLogin/globalController/authentication_manager.dart';
import '../chat/view/chatDashboard.dart';
import '../eventFeed/view/feedListPage.dart';
import '../meeting/controller/meetingController.dart';
import '../meeting/view/meeting_details_page.dart';
import '../polls/controller/pollsController.dart';
import '../polls/view/pollsPage.dart';
import '../profileSetup/view/edit_profile_page.dart';
import '../schedule/controller/session_controller.dart';
import '../schedule/view/watch_session_page.dart';

/// Controller for handling deep linking in the app using GetX.
class DeepLinkingController extends GetxController {
  // Reference to the authentication manager, fetched using Get.find().
  final AuthenticationManager _authManager = Get.find();
  final DashboardController dashboardController = Get.find();

  // Observable variable to track the loading state.
  var loading = false.obs;

  // Deep linking instance and stream subscription for listening to app links.
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    // Initialize deep linking when the controller is initialized.
    navigatePageAsPerNotification();
  }
  @override
  void onReady() {
    super.onReady();
    _initAppLinks();
  }



  /// Method to navigate to different pages based on the notification data.
  navigatePageAsPerNotification() async {
    switch (_authManager.pageName) {
      case "chat":
        // Reset pageName and pageId, then navigate to the AlertPage.
        _authManager.pageName = "";
        _authManager.pageId = "";
        Get.toNamed(AlertDashboard.routeName,arguments: {"tabIndex": 1});
        break;

      case "new_message":
        // Navigate to ChatDashboardPage with notification data as arguments.
        _authManager.pageName = "";
        _authManager.pageId = "";
        await Get.toNamed(
          ChatDashboardPage.routeName,
          arguments: {"chat_data": _authManager.notificationNode},
        );
        break;

      case "b2b_meeting":
        // If there's a valid pageId, open meeting details; otherwise, navigate to AlertPage.
        _authManager.pageName = "";
        if (_authManager.pageId.isNotEmpty) {
          openMeetingDetail(_authManager.pageId);
        } else {
          _authManager.pageId = "";
          Get.toNamed(AlertDashboard.routeName,arguments: {"tabIndex": 1});
        }
        break;

      // For general pages like "normal", "auditoriums", etc., navigate to AlertPage with a tab index.
      case "normal":
      case "auditoriums":
      case "attendees":
      case "exhibitors":
        _authManager.pageName = "";
        _authManager.pageId = "";
        Get.toNamed(AlertDashboard.routeName, arguments: {"tabIndex": 1});
        break;

      case "session":
        // Open session details if pageId is valid; otherwise, navigate to the SessionListPage.
        _authManager.pageName = "";
        if (_authManager.pageId.isNotEmpty) {
          openScheduleDetail(_authManager.pageId);
        } else {
          Get.toNamed(SessionListPage.routeName);
        }
        break;

      case "/alert":
        // Navigate to AlertPage directly.
        _authManager.pageName = "";
        Get.toNamed(AlertDashboard.routeName);
        break;

      case "poll":
        // If PollController is registered, delete it before navigating to PollsPage.
        Get.toNamed(AlertDashboard.routeName, arguments: {"tabIndex": 0});

        /* if (Get.isRegistered<PollController>()) {
          Get.delete<PollController>();
        }
        Get.toNamed(PollsPage.routeName,
            arguments: {"item_type": "event", "item_id": ""});*/
        break;

      case "feeds":
        // Navigate to the social feed list page.
        Get.toNamed(SocialFeedListPage.routeName);
        break;

      case "aiprofile":
        // Navigate to ProfileEditPage with an argument for AI profile.
        Get.toNamed(ProfileEditPage.routeName, arguments: "is_ai_profile");
        break;
      case "Feedback":
        Get.toNamed(FeedbackPage.routeName);
        break;
    }
  }

  /// Method to open the schedule detail page based on the session ID.
  openScheduleDetail(String sessionId) async {
    var controller = Get.put(SessionController());
    // Fetch session details using the controller.
    dashboardController.loading(true);
    var result =
        await controller.getSessionDetail(requestBody: {"id": sessionId});
    dashboardController.loading(false);
    if (result["status"]) {
      _authManager.pageId = "";
      // Check if the session has an embed link; navigate to WatchDetailPage or SessionDetailPage.
      Get.to(() => WatchDetailPage(sessions: controller.sessionDetailBody));
    }
  }

  /// Method to open the meeting detail page based on the session ID.
  openMeetingDetail(String sessionId) async {
    var controller = Get.put(MeetingController());
    // Fetch meeting details using the controller.
    dashboardController.loading(true);
    var result =
        await controller.getMeetingDetail(requestBody: {"id": sessionId});
    dashboardController.loading(false);
    if (result['status']) {
      _authManager.pageId = "";
      // Navigate to the meeting detail page.
      Get.toNamed(MeetingDetailPage.routeName);
    } else {
      // Show error message if meeting details are not found.
      UiHelper.showFailureMsg(
        null,
        result['message'] ?? "meeting_details_not_found".tr,
      );
    }
  }

  /// Initialize deep linking and listen for incoming links.
  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();

    try {
      // Get the initial link when the app starts.
      final uri = await _appLinks.getInitialLink();
      print("Initial link: $uri");
    } catch (e) {
      print('Failed to get initial uri: $e');
    }

    // Listen for incoming URI links while the app is running.
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri == null || uri.toString().isEmpty) return;

      print('Received URI: $uri');
      // Extract query parameters from the URI.
      final queryParams = uri.queryParameters;
      if(queryParams['page']!=null){
        _authManager.pageName = queryParams['page'] ?? "";
      }
      if(queryParams['id']!=null){
        _authManager.pageId = queryParams['id'] ?? "";
      }
      // Navigate based on the extracted page name and ID.
      if (_authManager.pageName.isNotEmpty || _authManager.pageId.isNotEmpty) {
        navigatePageAsPerNotification();
      }
      print("Page: ${_authManager.pageName}, ID: ${_authManager.pageId}");
    }, onError: (err) => print('Error: $err'));
  }

  @override
  void dispose() {
    // Cancel the link subscription when the controller is disposed.
    _linkSubscription?.cancel();
    super.dispose();
  }
}
