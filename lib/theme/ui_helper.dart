import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/meeting/model/timeslot_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../view/meeting/model/create_time_slot.dart';
import 'app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UiHelper {
  AuthenticationManager controller = Get.find();


  static String getShortName(String fullName) {
    // Split the full name into parts by space
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first letter of the first two parts
    String initials = nameParts
        .where((part) => part.isNotEmpty) // Filter out empty parts
        .take(2) // Take the first two non-empty parts
        .map((part) => part[0].toUpperCase()) // Get the first letter and make it uppercase
        .join(); // Combine them into a string

    return initials;
  }

  static String getChatDateTime({date, timezone}) {
    if (date.toString().isEmpty && date == null) {
      return "";
    }
    tz.initializeTimeZones();
    DateTime parseDate =
    DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(date.toString(), true);
    final pacificTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    var inputDate = tz.TZDateTime.from(parseDate, pacificTimeZone);
    var outputFormat = DateFormat('MMM dd, HH:mm aa');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String getAllowDateFormat({date, timezone}) {
    if (date.isEmpty) {
      return "";
    }
    tz.initializeTimeZones();
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(date, true);
    final pacificTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    var inputDate = tz.TZDateTime.from(parseDate, pacificTimeZone);
    //var inputDate = DateTime.parse(parseDate.toString()).toLocal();
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String getSlotsDate({date, timezone}) {
    if (date.isEmpty) {
      return "";
    }
    tz.initializeTimeZones();
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(date, true);
    final pacificTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    var inputDate = tz.TZDateTime.from(parseDate, pacificTimeZone);
    //var inputDate = DateTime.parse(parseDate.toString()).toLocal();
    var outputFormat = DateFormat('dd MMM');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static List<CreatedSlots> createTimeslotMeeting({
    required startDate,
    required endDate,
    required duration,
    required gap,
    required timezone,
  }) {
    tz.initializeTimeZones();

    List<CreatedSlots> timeSlots = [];
    final location = tz.getLocation(timezone ?? "Asia/Kolkata");

    DateTime startDateTime = DateTime.parse(startDate.toString()).toUtc();
    DateTime endDateTime = DateTime.parse(endDate.toString()).toUtc();

    DateTime convertedStartDate = tz.TZDateTime.from(startDateTime, location);
    DateTime convertedEndDate = tz.TZDateTime.from(endDateTime, location);

    Duration slotDuration = Duration(minutes: duration);
    Duration slotGap = Duration(minutes: gap);

    // Get the current time in the target timezone to compare against
    DateTime currentTime = tz.TZDateTime.now(location);

    while (convertedStartDate.isBefore(convertedEndDate)) {
      // Skip the time slot if it's in the past
      if (convertedStartDate.isBefore(currentTime)) {
        convertedStartDate = convertedStartDate.add(slotDuration + slotGap);
        continue;
      }

      var utcDateTimeFormat =
          "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(convertedStartDate.toUtc())}+00:00";

      timeSlots.add(CreatedSlots(
        time: /*DateFormat.Hm()*/DateFormat('hh:mm a').format(convertedStartDate),
        dateTime: utcDateTimeFormat,
        status: false,
      ));

      convertedStartDate = convertedStartDate.add(slotDuration + slotGap);
    }

    return timeSlots;
  }

  static List<MeetingSlots> filterMeetingSlotDate(
      String timezone, List<MeetingSlots> slotDateList) {
    List<MeetingSlots> newSlotDate = [];

    var mCurrentDate = UiHelper.getCurrentDate(timezone: timezone);
    for (var slotData in slotDateList) {
      DateTime startDate = DateTime.parse(UiHelper.getFormattedDateForCompare(
          date: slotData.endDatetime, timezone: timezone));

      DateTime dt1 = DateTime.parse(mCurrentDate);
      if (dt1.isBefore(startDate)) {
        newSlotDate.add(slotData);
        print("DT1 is before DT2");
      } else {
        print("DT1 is After DT2");
      }
    }
    return newSlotDate;
  }

  ///show date time both in 27 sep 12:30 PM format
  static String displayCommonDateTime({date, timezone, String? dateFormat}) {
    if (date.toString().isEmpty && date == null) {
      return "";
    }
    // Initialize time zones
    tz.initializeTimeZones();
    DateTime parseDate;
    try {
      if (date.toString().contains('T') && date.toString().contains('Z')) {
        // ISO 8601 format (e.g., 2024-09-27T07:00:00Z)
        parseDate = DateTime.parse(date);
      } else if (date.toString().contains('.') &&
          date.toString().contains('Z')) {
        // Format with milliseconds (e.g., 2024-10-04 08:58:58.000Z)
        parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parseUtc(date.toString());
      } else {
        // Default fallback format
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      }
    } catch (e) {
      print(e.toString());
      // Return empty string if parsing fails
      return "";
    }
    // Get the specified time zone or default to "Asia/Kolkata"
    final targetTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    // Convert to the specified time zone
    var inputDate = tz.TZDateTime.from(parseDate, targetTimeZone);
    // Define output format
    var outputFormat = DateFormat(dateFormat ?? 'dd MMM, yyyy | hh:mm aa');
    String outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String displayCommonDateTimeTh({date, timezone, String? dateFormat}) {
    if (date.toString().isEmpty || date == null) {
      return "";
    }

    // Initialize time zones
    tz.initializeTimeZones();
    DateTime parseDate;

    try {
      if (date.toString().contains('T') && date.toString().contains('Z')) {
        // ISO 8601 format (e.g., 2024-09-27T07:00:00Z)
        parseDate = DateTime.parse(date);
      } else if (date.toString().contains('.') &&
          date.toString().contains('Z')) {
        // Format with milliseconds (e.g., 2024-10-04 08:58:58.000Z)
        parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parseUtc(date.toString());
      } else {
        // Default fallback format
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      }
    } catch (e) {
      print(e.toString());
      // Return empty string if parsing fails
      return "";
    }

    // Get the specified time zone or default to "Asia/Kolkata"
    final targetTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    // Convert to the specified time zone
    var inputDate = tz.TZDateTime.from(parseDate, targetTimeZone);

    // Add suffix to the day
    String addDaySuffix(int day) {
      if (day >= 11 && day <= 13) return "${day}th";
      switch (day % 10) {
        case 1:
          return "${day}st";
        case 2:
          return "${day}nd";
        case 3:
          return "${day}rd";
        default:
          return "${day}th";
      }
    }

    // Extract day with suffix
    String dayWithSuffix = addDaySuffix(inputDate.day);

    // Define the date format
    var outputFormat = DateFormat(dateFormat ?? 'dd MMM, yyyy | hh:mm a');
    String formattedDate = outputFormat.format(inputDate);

    // Replace the day in the formatted date with the day and suffix
    return formattedDate.replaceFirst(
      RegExp(r'^\d{2}'),
      dayWithSuffix,
    );
  }

  static String displayDatetimeSuffix(
      {startDate, endDate, timezone}) {
    String datetime =
        '${UiHelper.displayCommonDateTimeTh(date: startDate, dateFormat: 'dd MMM, yyyy', timezone: timezone)} | '
        '${UiHelper.displayCommonDateTime(date: startDate, dateFormat: 'hh:mm a', timezone: timezone)} - '
        '${UiHelper.displayCommonDateTime(date: endDate, dateFormat: 'hh:mm a', timezone: timezone)}';
    return datetime;
  }

  static String displayDatetimeSuffixEventFeed(
      {startDate, timezone}) {
    String datetime =
        '${UiHelper.displayCommonDateTimeTh(date: startDate, dateFormat: 'dd MMM, yyyy', timezone: timezone)} | '
        '${UiHelper.displayCommonDateTime(date: startDate, dateFormat: 'hh:mm a', timezone: timezone)}';
        //'${UiHelper.displayCommonDateTime(date: endDate, dateFormat: 'hh:mm a', timezone: timezone)}';
    return datetime;
  }

  ///show date time both in 27 sep format
  static String displayDateFormat({date, timezone}) {
    print("@@ datetime ${date.toString()}");
    if (date.toString().isEmpty && date == null) {
      return "";
    }
    // Initialize time zones
    tz.initializeTimeZones();
    DateTime parseDate;
    try {
      if (date.toString().contains('T') && date.toString().contains('Z')) {
        // ISO 8601 format (e.g., 2024-09-27T07:00:00Z)
        parseDate = DateTime.parse(date);
      } else if (date.toString().contains('.') &&
          date.toString().contains('Z')) {
        // Format with milliseconds (e.g., 2024-10-04 08:58:58.000Z)
        parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parseUtc(date.toString());
      } else {
        // Default fallback format
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      }
    } catch (e) {
      // Return empty string if parsing fails
      print(e.toString());
      return "";
    }
    // Get the specified time zone or default to "Asia/Kolkata"
    final targetTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    // Convert to the specified time zone
    var inputDate = tz.TZDateTime.from(parseDate, targetTimeZone);
    // Define output format
    var outputFormat = DateFormat('dd MMM');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String displayDateFormat2({date, timezone}) {
    print("@@ datetime ${date.toString()}");
    if (date.toString().isEmpty || date == null) {
      return "";
    }
    // Initialize time zones
    tz.initializeTimeZones();
    DateTime parseDate;
    try {
      if (date.toString().contains('T') && date.toString().contains('Z')) {
        // ISO 8601 format (e.g., 2024-09-27T07:00:00Z)
        parseDate = DateTime.parse(date);
      } else if (date.toString().contains('.') && date.toString().contains('Z')) {
        // Format with milliseconds (e.g., 2024-10-04 08:58:58.000Z)
        parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parseUtc(date.toString());
      } else {
        // Default fallback format
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      }
    } catch (e) {
      // Return empty string if parsing fails
      print(e.toString());
      return "";
    }
    // Get the specified time zone or default to "Asia/Kolkata"
    final targetTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    // Convert to the specified time zone
    var inputDate = tz.TZDateTime.from(parseDate, targetTimeZone);

    // Define a function to get the ordinal suffix
    String getOrdinalSuffix(int day) {
      if (day >= 11 && day <= 13) {
        return "th";
      }
      switch (day % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    }

    // Get the day with the suffix
    var day = inputDate.day;
    var suffix = getOrdinalSuffix(day);

    // Define output format for month
    var monthFormat = DateFormat('MMM');
    var formattedDate = "$day$suffix ${monthFormat.format(inputDate)}";

    return formattedDate;
  }


  ///show date time both in 12:30 PM format
  static String displayTimeFormat({date, timezone}) {
    if (date.toString().isEmpty && date == null) {
      return "";
    }
    // Initialize time zones
    tz.initializeTimeZones();
    DateTime parseDate;
    try {
      if (date.toString().contains('T') && date.toString().contains('Z')) {
        // ISO 8601 format (e.g., 2024-09-27T07:00:00Z)
        parseDate = DateTime.parse(date);
      } else if (date.toString().contains('.') &&
          date.toString().contains('Z')) {
        // Format with milliseconds (e.g., 2024-10-04 08:58:58.000Z)
        parseDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parseUtc(date.toString());
      } else {
        // Default fallback format
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
      }
    } catch (e) {
      // Return empty string if parsing fails
      print(e.toString());
      return "";
    }
    // Get the specified time zone or default to "Asia/Kolkata"
    final targetTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    // Convert to the specified time zone
    var inputDate = tz.TZDateTime.from(parseDate, targetTimeZone);
    // Define output format
    var outputFormat = DateFormat('hh:mm aa');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  //* Limits given string, adds '..' if necessary
  static String shortenName(String nameRaw,
      {int nameLimit = 10, bool addDots = false}) {
    //* Limiting val should not be gt input length (.substring range issue)
    final max = nameLimit < nameRaw.length ? nameLimit : nameRaw.length;
    //* Get short name
    final name = nameRaw.substring(0, max);
    //* Return with '..' if input string was sliced
    if (addDots && nameRaw.length > max) return '$name..';
    return name;
  }

  ///used for the compare the date in meeting section
  static String getFormattedDateForCompare({date, timezone}) {
    if (date.isEmpty) {
      return "";
    }
    tz.initializeTimeZones();

    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ'").parse(date, true);
    final pacificTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    var inputDate = tz.TZDateTime.from(parseDate, pacificTimeZone);
    var outputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  ///get the current date to used in meeting and chat created time
  static String getCurrentDate({timezone}) {
    tz.initializeTimeZones();

    final pacificTimeZone = tz.getLocation(timezone ?? "Asia/Kolkata");
    var inputDate = tz.TZDateTime.from(DateTime.now(), pacificTimeZone);
    var outputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String getSocialIcon(type) {
    switch (type) {
      case "facebook":
        return "assets/svg/fb_icon.svg";
      case "twitter":
        return "assets/svg/twitter_icon.svg";
      case "instagram":
        return "assets/svg/insta_icon.svg";
      case "linkedin":
        return "assets/svg/linked_icon.svg";
      case "google":
        return "assets/svg/google_icon.svg";
      case "youtube":
        return "assets/svg/youtube_icon.svg";
      case "website":
        return "assets/svg/website_icon.svg";
    }
    return "assets/svg/website.svg";
  }

  static String getLikeIcon(type) {
    switch (type) {
      case "like":
        return "assets/icons/like_icons.png";
      case "love":
        return "assets/icons/heart_icon.png";
      case "care":
        return "assets/icons/emoji_like_1.png";
      case "haha":
        return "assets/icons/emoji_like_2.png";
      case "wow":
        return "assets/icons/emoji_like_3.png";
      case "sad":
        return "assets/icons/emoji_like_4.png";
      case "angry":
        return "assets/icons/emoji_like_5.png";
        break;
      case "":
        return "assets/icons/like_icon.png";
        break;
    }
    return "assets/icons/like_icon.png";
  }

  static String? getYoutubeThumbnail(String videoUrl) {
    final Uri uri = Uri.parse(videoUrl);
    if (uri == null) {
      return null;
    }
    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }

  static Future<void> inAppWebView(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> inAppBrowserView(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> inPlatformDefault(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  // Format the countdown to display leading zero
  static String formatCountdown(int time) {
    return time
        .toString()
        .padLeft(2, '0'); // Pad with '0' if number is less than 10
  }


  static bool isNumber(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  static bool isEmail(String string) {
    // Null or empty string is invalid
    if (string.isEmpty) {
      return true;
    }
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static Widget getPhotoBoothImage({imageUrl}) {
    return CachedNetworkImage(
      maxHeightDiskCache: 500,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Center(
        child: Image.asset(
          ImageConstant.imagePlaceholder,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        ImageConstant.imagePlaceholder,
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget getProductImage({imageUrl}) {
    return CachedNetworkImage(
      maxHeightDiskCache: 500,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/icons/products.png",
        color: colorLightGray,
      ),
    );
  }

  static Widget getExhibitorDetailsImage({imageUrl}) {
    return imageUrl != null && imageUrl.toString().isNotEmpty
        ? CachedNetworkImage(
            maxHeightDiskCache: 500,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/icons/exhibitors_home.png",
              color: grayColorLight,
            ),
          )
        : Image.asset(
            "assets/icons/exhibitors_home.png",
            color: grayColorLight,
          );
  }

  static Widget getExhibitorImage({imageUrl}) {
    return imageUrl != null && imageUrl.toString().isNotEmpty
        ? CachedNetworkImage(
            maxHeightDiskCache: 500,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/icons/exhibitors_home.png",
              color: grayColorLight,
            ),
          )
        : Image.asset(
            "assets/icons/exhibitors_home.png",
            color: grayColorLight,
          );
  }

  static bool showingInternet = false;

  static Future<bool> isNoInternet() async {
    if (showingInternet) {
      return false;
    }
    if (!await InternetConnectionChecker().hasConnection) {
      showNetworkSnackBar();
      return true;
    }
    return false;
  }

  static void showNetworkSnackBar() {
    Get.closeCurrentSnackbar();
    showingInternet = true;
    Get.rawSnackbar(
      // 'Network issue', 'Please check your network issue.',
      isDismissible: false,
      duration: const Duration(days: 1),
      mainButton: TextButton(
        onPressed: () {
          showingInternet = false;
          Get.back();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 14,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      borderRadius: 40, // Rounded corners
      messageText: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline,
              color: Colors.white, size: 30), // Icon on the left
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: 'Network issue',
                  color: Colors.white,
                  fontSize: 16,
                ),
                SizedBox(height: 2),
                CustomTextView(
                  text: 'Please check your network issue.',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void showFailureMsg(BuildContext? context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      description: RichText(
          text: TextSpan(
        text: message ?? "",
        style: TextStyle(color: white, fontSize: 14.fSize),
      )),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 350),
      icon: const Icon(Icons.error_outline, color: white, size: 30),
      showIcon: true, // show or hide the icon
      backgroundColor: black,
      primaryColor: black,
      // foregroundColor: black,
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(100),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) {
          print("'wehfbwuefbwuefb");
        },
      ),
    );
  }

  static Future<bool> isInternetWorking(BuildContext context) async {
    try {
      // Check connectivity (WiFi, Mobile Data, etc.)
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showFailureMsg(context, "Internet not working. Please check your network connection and try again");
        return false; // No network available
      }

      // Verify internet access with a simple HTTP request
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet is working
      }
    } catch (e) {
      // Handle errors (e.g., no internet access)
      showFailureMsg(context, "Internet not working. Please check your network connection and try again");
      return false;
    }
    return false; // Default to no internet
  }



  static void showFailureMsgTop(BuildContext? context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      description: RichText(
          text: TextSpan(
        text: message ?? "",
        style: TextStyle(color: white, fontSize: 14.fSize),
      )),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 350),
      icon: const Icon(Icons.error_outline, color: white, size: 30),
      showIcon: true, // show or hide the icon
      backgroundColor: black,
      primaryColor: black,
      // foregroundColor: black,
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(100),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) {
          print("'wehfbwuefbwuefb");
        },
      ),
    );
  }

  static void showSuccessMsg(BuildContext? context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      description: RichText(
          text: TextSpan(
        text: message ?? "",
        style: TextStyle(color: white, fontSize: 14.fSize),
      )),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 350),
      icon: const Icon(Icons.check_circle_outline, color: white, size: 30),
      showIcon: true, // show or hide the icon
      backgroundColor: black,
      primaryColor: black,
      // foregroundColor: black,
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(100),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) {
          print("'wehfbwuefbwuefb");
        },
      ),
    );
  }

  static String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')} minutes';
  }

  static bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 7) {
      return false;
    }
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static bool isMobileValid(String phone) {
    if (phone.isEmpty || phone == null) {
      return false;
    } else if (!isValidPhoneNumber(phone)) {
      return false;
    } else {
      return true;
    }
  }

  static Color getColorByHexCode(String code) {
    if (code.isNotEmpty) {
      return Color(int.parse("0xFF${code.replaceAll("#", "")}"));
    }
    return colorPrimary;
  }


  ///********** Checking Camera Permission ***********///
  static Future<bool?> checkAndRequestCameraPermissions() async {
    PermissionStatus permissionStatus;
    late Permission permission;
    permission = Permission.camera;
    permissionStatus = await permission.request();
    if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus newPermissionStatus = await permission.request();
      if (newPermissionStatus == PermissionStatus.denied) {
        /// Permission denied
        return false;
      }
      if (newPermissionStatus == PermissionStatus.permanentlyDenied) {
        /// Permission denied
        return false;
      } else {
        /// Permission accepted
        return true;
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      /// Permission denied
      return false;
    } else {
      /// Permission accepted
      return true;
    }
  }

  ///********** Checking Contact Permission ***********///
  static Future<bool?> checkAndRequestContactPermissions() async {
    PermissionStatus permissionStatus;
    late Permission permission;
    permission = Permission.contacts;
    permissionStatus = await permission.request();
    if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus newPermissionStatus = await permission.request();
      if (newPermissionStatus == PermissionStatus.denied) {
        /// Permission denied
        return false;
      }
      if (newPermissionStatus == PermissionStatus.permanentlyDenied) {
        /// Permission denied
        return false;
      } else {
        /// Permission accepted
        return true;
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      /// Permission denied
      return false;
    } else {
      /// Permission accepted
      return true;
    }
  }


  ///social media validation
  static bool isValidLinkedInUrl(String url) {
    final RegExp regex = RegExp(
      r'^(https?:\/\/)(www\.)?linkedin\.com\/(in\/[a-zA-Z0-9-]+\/?|company\/[a-zA-Z0-9-]+\/?)$',
    );
    return regex.hasMatch(url);
  }

  static bool isValidLinkedInUrlNew(String url) {
    // Null or empty string is invalid
    if (url.isEmpty) {
      return false;
    }
    final regex = RegExp(
      r'^https:\/\/(www\.)?linkedin\.com\/in\/[a-zA-Z0-9-]{3,100}\/?$',
    );
    return regex.hasMatch(url);
  }

  static bool isValidTwitterUrl(String url) {
    final RegExp regex = RegExp(
      r'^https?:\/\/(www\.)?twitter\.com\/[A-Za-z0-9_]{1,15}\/?$',
    );
    return regex.hasMatch(url);
  }

  static bool isValidFacebookUrl(String url) {
    final RegExp regex = RegExp(
      r'^https?:\/\/(www\.)?facebook\.com\/([a-zA-Z0-9.\-_]{1,50}|profile\.php\?id=\d{5,20})\/?$',
    );
    return regex.hasMatch(url);
  }

  static bool isValidWebsiteUrl(String url) {
    if (url == null || url.isEmpty) {
      return true;
    }
    final RegExp regex = RegExp(
      r'^(https?:\/\/)' // Match 'http://' or 'https://'
      r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // Match domain (e.g., 'example.com')
      r'(:\d{2,5})?' // Optionally match a port (e.g., ':8080')
      r'(\/[a-zA-Z0-9@:%_+.~#?&//=]*)?$', // Optionally match a path or query string
    );
    return regex.hasMatch(url);
  }

  static bool webSiteValidator(String url) {
    // Basic regex pattern for website URL validation
    String pattern = r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(url)) {
      return false;
    } else {
      return true;
    }
  }
}
