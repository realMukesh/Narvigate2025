import 'dart:io';
import 'dart:math';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/chat/view/chatDashboard.dart';
import 'package:dreamcast/view/eventFeed/view/feedListPage.dart';
import 'package:dreamcast/view/meeting/controller/meetingController.dart';
import 'package:dreamcast/view/profileSetup/view/edit_profile_page.dart';
import 'package:dreamcast/view/quiz/view/feedback_page.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api_repository/app_url.dart';
import '../theme/ui_helper.dart';
import '../view/alert/pages/alert_dashboard.dart';
import '../view/meeting/view/meeting_details_page.dart';
import '../view/schedule/model/speaker_webinar_model.dart';
import '../view/schedule/view/watch_session_page.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);

  Future<void> initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    } else {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
    _fcm.subscribeToTopic(AppUrl.topicName);
    startListeningNotificationEvents();

    // When app is terminated
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(
          data: message.data,
          page: message.data["page"] ?? "",
          notificationId: message.data["id"] ?? "",
          appStatus: "terminate",
        );
      }
    });

    // When app is open and in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null && Platform.isAndroid) {
        createNotification(message, "foreground");
      }
    });

    // When app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        handleMessage(
          data: message.data,
          page: message.data["page"] ?? "",
          notificationId: message.data["id"] ?? "",
          appStatus: "background",
        );
      }
    });
  }

  Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: PushNotificationService.onActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.Default ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      handleMessage(
        data: receivedAction.payload?["data"] ?? "",
        page: receivedAction.payload?["page"] ?? "",
        notificationId: receivedAction.payload?["id"] ?? "",
        appStatus: "background",
      );
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    }
    return onActionReceivedImplementationMethod(receivedAction);
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    print('Message ReceivedAction: "${receivedAction.buttonKeyInput}"');
  }

  // Only working for foreground
  Future<void> createNotification(RemoteMessage message, String key) async {
    print(message.data["page"]);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(2147483647),
        channelKey: "high_importance_channel",
        payload: {
          "page": message.data["page"] ?? "",
          "id": message.data["id"] ?? ""
        },
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        displayOnBackground: true,
        displayOnForeground: true,
        criticalAlert: true,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: /*message.data["page"]*/"session",
          label: 'Open Notification',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  static Future<void> handleMessage({
    required dynamic data,
    required String page,
    required String notificationId,
    required String appStatus,
  }) async {
    if (appStatus == "background" && page.isNotEmpty) {
      AuthenticationManager manager = Get.find();
      if (manager.isLogin()) {
        switch (page) {
          case "chat":
            Get.toNamed(AlertDashboard.routeName,arguments: {"tabIndex": 1});
            break;
          case "new_message":
            await Get.toNamed(ChatDashboardPage.routeName,
                arguments: {"chat_data": data});
            break;
          case "b2b_meeting":
            if (notificationId.isNotEmpty) {
              openMeetingDetail(notificationId);
            } else {
              Get.toNamed(AlertDashboard.routeName,arguments: {"tabIndex": 1});
            }
            break;
          case "normal":
            Get.toNamed(AlertDashboard.routeName);
            break;
          case "aiprofile":
            Get.toNamed(ProfileEditPage.routeName,arguments: "is_ai_profile");
            break;
          case "poll":
            Get.toNamed(AlertDashboard.routeName, arguments: {"tabIndex": 0});
            /*if (Get.isRegistered<PollController>()) {
              Get.delete<PollController>();
            }
            Get.toNamed(PollsPage.routeName,
                arguments: {"item_type": "event", "item_id": ""});*/
            break;
          case "auditoriums":
          case "attendees":
          case "exhibitors":
            Get.toNamed(AlertDashboard.routeName, arguments: {"tabIndex": 1});
            break;
          case "feeds":
            Get.toNamed(SocialFeedListPage.routeName);
            break;
          case "session":
            if (notificationId.isNotEmpty) {
              openScheduleDetail(notificationId);
            } else {
              Get.toNamed(AlertDashboard.routeName, arguments: {"tabIndex": 1});
            }
            break;
          case "Feedback":
            Get.toNamed(FeedbackPage.routeName);
            break;
        }
      }
    } else if (appStatus == "terminate") {
      AuthenticationManager manager = Get.find();
      if (page.isNotEmpty) {
        if (notificationId.isNotEmpty) {
          manager.pageId = notificationId;
        }
        manager.pageName = page;
        manager.notificationNode = data;
      } else {
        manager.pageName = "/alert";
      }
    }
  }

  static Future<void> openScheduleDetail(String sessionId) async {
    var controller = Get.put(SessionController());
    var result = await controller.getSessionDetail(requestBody: {"id": sessionId});
    if (result["status"]) {
      Get.to(() => WatchDetailPage(
        sessions: controller.sessionDetailBody,
      ));
    }
  }


  static Future<void> openMeetingDetail(String sessionId) async {
    var controller = Get.put(MeetingController());
    var result =
    await controller.getMeetingDetail(requestBody: {"id": sessionId});
    if (result['status']) {
      Get.toNamed(MeetingDetailPage.routeName);
    } else {
      UiHelper.showFailureMsg(
          null, result['message'] ?? "Oops! Meeting detail not found");
    }
  }
}

