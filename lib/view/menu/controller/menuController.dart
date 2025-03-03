import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/dashboard/dashboard_controller.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:dreamcast/view/menu/model/menu_data_model.dart';
import 'package:dreamcast/view/representatives/controller/networkingController.dart';
import 'package:dreamcast/view/representatives/view/networkingPage.dart';
import 'package:dreamcast/view/startNetworking/view/dashboard/networkingDashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../model/guide_model.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/ui_helper.dart';
import '../../IFrame/socialWallController.dart';
import '../../IFrame/socialWallpage.dart';
import '../../Notes/controller/my_notes_controller.dart';
import '../../Notes/view/notes_dashboard.dart';
import '../../account/controller/account_controller.dart';
import '../../bestForYou/view/aiMatch_dashboard_page.dart';
import '../../breifcase/controller/common_document_controller.dart';
import '../../breifcase/view/breifcase_page.dart';
import '../../breifcase/view/resourceCenter.dart';
import '../../eventFeed/controller/eventFeedController.dart';
import '../../eventFeed/view/feedListPage.dart';
import '../../exhibitors/controller/exhibitorsController.dart';
import '../../exhibitors/view/bootListPage.dart';
import '../../guide/view/info_faq_dashboard.dart';
import '../../home/screen/inAppWebview.dart';
import '../../home/screen/pdfViewer.dart';
import '../../leaderboard/view/leaderboard__dashboard_page.dart';
import '../../meeting/view/meeting_dashboard_page.dart';
import '../../myFavourites/view/for_you_dashboard.dart';
import '../../nearbyAttraction/view/nearbyAttractionPage.dart';
import '../../partners/controller/partnersController.dart';
import '../../partners/view/partnersPage.dart';
import '../../photobooth/view/photoBooth.dart';
import '../../polls/controller/pollsController.dart';
import '../../polls/view/pollsPage.dart';
import '../../qrCode/view/qr_dashboard_page.dart';
import '../../quiz/view/feedback_page.dart';
import '../../speakers/view/speaker_list_page.dart';
import '../../support/view/helpdeskDashboard.dart';
import '../../travelDesk/view/travelDeskPage.dart';

class HubController extends GetxController {
  var loading = false.obs;
  var contentLoading = false.obs;

  var hubMenuMain = <MenuData>[].obs;
  var hubTopMenu = <MenuData>[].obs;

  var galleryFrameUrl = "";
  var aboutUsHtml = "";
  AuthenticationManager authenticationManager = Get.find();
  DashboardController dashboardController = Get.find();
  HomeController homeController = Get.find();
  bool _isButtonDisabled = false;

  @override
  void onInit() {
    super.onInit();
    getHubMenuAPi(isRefresh: false);
  }

  Future<void> getHtmlPage(
      {required String title,
        required String slug,
        required bool isExternal}) async {
    try {
      contentLoading(true);
      IFrameModel? model = await apiService.getIframe(slug: slug);
      contentLoading(false);

      if (model.status == true) {
        final body = model.body;

        // Handle API body status
        if (body?.status == false) {
          UiHelper.showFailureMsg(
              null, body?.messageData?.body ?? "Something went wrong");
          return;
        }
        final webview = body?.webview;
        if (webview != null) {
          if (webview.contains("pdf")) {
            Get.to(PdfViewPage(htmlPath: webview, title: title));
          } else if (isExternal) {
            UiHelper.inAppBrowserView(Uri.parse(webview ?? ""));
          } else {
            Get.toNamed(CustomWebViewPage.routeName, arguments: {
              "page_url": webview,
              "title": title,
            });
          }
        } else {
          UiHelper.showFailureMsg(null, "Webview data is missing");
        }
      } else {
        UiHelper.showFailureMsg(null, model.message ?? "Failed to load data");
      }
    } catch (e) {
      contentLoading(false);
      UiHelper.showFailureMsg(null, "An error occurred: $e");
    }
  }

  //get notes text
  Future<void> getHubMenuAPi({required bool isRefresh}) async {
    try {
      loading(!isRefresh);
      MenuDataModel? model = await apiService.getMenuNavigation();
      loading(false);
      if (model.status! && model.code == 200) {
        hubTopMenu.clear();
        hubMenuMain.clear();

        hubTopMenu.addAll(model.body?.hubTop ?? []);
        hubMenuMain.addAll(model.body?.hubMain ?? []);

        homeController.menuHorizontalHome(model.body?.homeProfile ?? []);
        homeController.menuFeatureHome(model.body?.homeFeature ?? []);

        if (Get.isRegistered<AccountController>()) {
          AccountController accountController = Get.find();
          accountController.profileMenu(model.body?.userProfile ?? []);
        } else {
          AccountController accountController = Get.put(AccountController());
          accountController.profileMenu(model.body?.userProfile ?? []);
        }
      }
    } catch (e) {
      print(e.toString());
      loading(false);
    }
  }

  commonMenuRouting({required MenuData menuData}) {
    if (_isButtonDisabled) return; // Prevent further clicks
    _isButtonDisabled = true;
    Future.delayed(const Duration(seconds: 2), () {
      _isButtonDisabled =
      false; // Re-enable the button after the screen is closed
    });

    switch (menuData.slug) {
      case "resource_center":
        if (Get.isRegistered<CommonDocumentController>()) {
          CommonDocumentController controller = Get.find();
          controller.getDocumentList(isRefresh: false, limitedMode: false);
        }
        Get.toNamed(ResourceCenterListPage.routeName);
        break;
      case "infodesk":
        Get.toNamed(InfoFaqDashboard.routeName);
        break;
      case "my_profile":
        if (Get.isRegistered<AccountController>()) {
          AccountController controller = Get.find();
          controller.callDefaultApi();
        }
        dashboardController.changeTabIndex(4);
        //Get.toNamed(AccountPage.routeName);
        break;
      case "leaderboard":
        Get.toNamed(LeaderboardDashboardPage.routeName);
        break;
      case "event_poll":{
        if (Get.isRegistered<PollController>()) {
          Get.delete<PollController>();
        }
        Get.toNamed(PollsPage.routeName,
            arguments: {"item_type": "event", "item_id": ""});
      }
      break;
      case "event_feedback":
        Get.toNamed(FeedbackPage.routeName);
        break;
      case "my_badge":
        // Get.toNamed(QRDashboardPage.routeName);
        dashboardController.changeTabIndex(3);
        break;
      case "networking":
        if (Get.isRegistered<NetworkingController>()) {
          NetworkingController controller = Get.find();
          controller.isLoading(false);
          controller.clearFilterOnTab();
          controller.initApiCall();
        }
        Get.toNamed(NetworkingPage.routeName);
        //dashboardController.changeTabIndex(3);
        break;
      case "exhibitors":
        getHtmlPage(
            title: menuData.label ?? "",
            slug: "expo",

            isExternal: false);
        // if (Get.isRegistered<BootController>()) {
        //   Get.delete<BootController>();
        // }
        // Get.toNamed(BootListPage.routeName);
        break;
      case "speakers":
        Get.toNamed(
          SpeakerListPage.routeName,
        );
        break;
      case "user":
        Get.toNamed(
          SpeakerListPage.routeName,
          arguments: {"role": menuData.slug, "title": menuData.label},
        );
        break;
      case "agenda":
        getHtmlPage(
            title: menuData.label ?? "", slug: "agenda", isExternal: false);
        break;
      case "helpdesk":
        Get.toNamed(HelpDeskDashboard.routeName);
        break;
      case "partners":
        if (Get.isRegistered<SponsorPartnersController>()) {
          SponsorPartnersController controller = Get.find();
          controller.allSponsorsPartnersListApi(requestBody: {
            "limited_mode": false,
          }, isRefresh: true);
        }
        Get.toNamed(SponsorsList.routeName);
        break;
      case "sessions":
        dashboardController.changeTabIndex(1);
        break;
      case "feeds":
        if (Get.isRegistered<EventFeedController>()) {
          EventFeedController controller = Get.find();
          controller.getEventFeed(isLimited: false);
        }
        Get.toNamed(SocialFeedListPage.routeName);
        break;
      case "social_wall":
        if (Get.isRegistered<SocialWallController>()) {
          SocialWallController controller = Get.find();
          controller.getSocialWallUrl();
        }
        Get.to(() => SocialWallPage(
          title: "social_wall".tr,
          showToolbar: true,
        ));
        break;
      case "my_meetings":
        Get.toNamed(MyMeetingList.routeName);
        break;
      case "ai_gallery":
        Get.toNamed(AIPhotoSeachPage.routeName);
        break;
      case "floorplan":
        getHtmlPage(
            title: menuData.label ?? "",
            slug: menuData.slug ?? MyConstant.slugFloorMap,
            isExternal: false);
        break;
      case "winners":
        getHtmlPage(
            title: menuData.label ?? "",
            slug: menuData.slug ?? "winners",
            isExternal: false);
        break;
      case "photobooth":
        getHtmlPage(
            title: menuData.label ?? "",
            slug: MyConstant.slugPhotoBoothWall,
            isExternal: true);
        break;
      case "ai_matches":
        Get.toNamed(AiMatchDashboardPage.routeName);
        break;
      case "briefcase":
        CommonDocumentController controller = Get.find();
        controller.getBriefcaseList(isRefresh: false);
        Get.toNamed(BriefcasePage.routeName);
        break;
      case "near_by_attractions":
        Get.toNamed(NearbyAttractionPage.routeName);
        break;
      case "favourites":
      //open the bookmark  view.
        Get.toNamed(ForYouDashboard.routeName);
        break;
      case "travel_desk":
        Get.toNamed(TravelDeskPage.routeName);
        break;
      case "my_notes":
        if (Get.isRegistered<MyNotesController>()) {
          Get.delete<MyNotesController>();
        }
        Get.toNamed(NotesDashboard.routeName);
        //open the for you section.
        break;
    }
  }
}
