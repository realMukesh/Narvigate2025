import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  final List<String> tabList = [
    "Leaderboard",
    "Criteria",
    "My Points",
  ];

  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTabIndex(0);
  }


}