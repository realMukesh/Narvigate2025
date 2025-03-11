import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../model/leaderboard_model.dart';

class LeaderboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  var leaderBoardData = LeaderBoardData().obs;
  var actionName = [];
  late TabController _tabController;

  TabController get tabController => _tabController;
  final selectedTabIndex = 0.obs;

  Future<void> getLeaderboard() async {
    isFirstLoadRunning(true);
    LeaderBoardModel? model =
        await apiService.getLeaderboard(body: {"page_id": 1});
    isFirstLoadRunning(false);
    if (model!.status! && model!.code == 200) {
      leaderBoardData(model.body);
    }
    loading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getLeaderboard();
    _tabController = TabController(vsync: this, length: 3);
    if (Get.arguments != null && Get.arguments["tab_index"] != null) {
      _tabController.index = Get.arguments["tab_index"];
      selectedTabIndex.value = Get.arguments["tab_index"];
      loading(true);

    }
  }
}
