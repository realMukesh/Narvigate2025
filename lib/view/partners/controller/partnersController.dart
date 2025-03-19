import 'package:dreamcast/model/common_model.dart';
import 'package:dreamcast/view/partners/model/homeSponsorsPartnersListModel.dart';
import 'package:dreamcast/view/partners/model/AllSponsorsPartnersListModel.dart';
import 'package:get/get.dart';
import '../../../api_repository/api_service.dart';

class SponsorPartnersController extends GetxController {
  var isLoading = false.obs;
  var isMoreData = false.obs;

  @override
  void onInit() {
    homeSponsorsPartnersListApi(
        requestBody: {"limited_mode": true}, isRefresh: false);
    super.onInit();
  }

  var sponsorsLoader = false.obs;
  List<Items> homeSponsorsList = <Items>[].obs;

  ///*********** Home Sponsors Partners list Api **************///
  Future<void> homeSponsorsPartnersListApi(
      {required requestBody, required bool isRefresh}) async {
    if (isRefresh) {
      sponsorsLoader(true);
    }
    HomeSponsorsPartnerListModel? model =
        await apiService.homeSponsorsPartnersListApi(requestBody);
    sponsorsLoader(false);
    if (model.status! && model.code == 200) {
      isMoreData(model.body?.hasNextPage ?? false);
      homeSponsorsList.clear();
      homeSponsorsList.addAll(model.body?.items ?? []);
      update();
    }
  }

  List<PartnerData> allSponsorsList = <PartnerData>[].obs;

  ///*********** Home Sponsors Partners list Api **************///
  Future<void> allSponsorsPartnersListApi(
      {required requestBody, required bool isRefresh}) async {
    if (isRefresh) {
      sponsorsLoader(true);
    }
    AllSponsorsPartnerListModel? model =
        await apiService.allSponsorsPartnersListApi(requestBody);
    sponsorsLoader(false);
    if (model.status! && model.code == 200) {
      allSponsorsList.clear();
      allSponsorsList.addAll(model.body ?? []);
      update();
    }
  }

  ///*********** Home Sponsors Partners details Api **************///
  Future<void> sponsorsPartnersDetailsApi(
      {required String sponsorId, required bool isRefresh}) async {

    var requestBody = {
      "sponsor_id": sponsorId,
    };
    // if (isRefresh) {
    //   sponsorsLoader(true);
    // }
    CommonModel? model =
        await apiService.sponsorsPartnersDetails(requestBody);
    // sponsorsLoader(false);
    // if (model.status! && model.code == 200) {
    //   allSponsorsList.clear();
    //   allSponsorsList.addAll(model.body ?? []);
    //   update();
    // }
  }
}
