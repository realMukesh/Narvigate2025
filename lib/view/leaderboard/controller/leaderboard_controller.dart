import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';
import '../../../api_repository/app_url.dart';
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

  Future<void> getLeaderboard({required bool isRefresh}) async {
    isFirstLoadRunning(true);
    var response = await apiService
        .dynamicPostRequest(body: {"page_id": 1}, url: AppUrl.leaderBoardApi);
    LeaderBoardModel? model = LeaderBoardModel.fromJson(json.decode(response));
    isFirstLoadRunning(false);
    if (model!.status! && model!.code == 200) {
      leaderBoardData(model.body);
    }
    loading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getLeaderboard(isRefresh: false);
    _tabController = TabController(vsync: this, length: 3);
    if (Get.arguments != null && Get.arguments["tab_index"] != null) {
      _tabController.index = Get.arguments["tab_index"];
      selectedTabIndex.value = Get.arguments["tab_index"];
      loading(true);
    }
  }
}
