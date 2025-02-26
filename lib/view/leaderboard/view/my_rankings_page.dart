import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../routes/my_constant.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/loading.dart';
import '../../dashboard/showLoadingPage.dart';
import '../controller/leaderboard_controller.dart';
import '../model/leaderboard_model.dart';

class MyRankingPage extends StatefulWidget {
  const MyRankingPage({Key? key}) : super(key: key);

  @override
  State<MyRankingPage> createState() => _MyRankingPageState();
}

class _MyRankingPageState extends State<MyRankingPage> {
  final LeaderboardController controller = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var pointsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: GetX<LeaderboardController>(builder: (controller) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: controller.isFirstLoadRunning.value
                  ? const Center(child: Loading())
                  : RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: Colors.white,
                      backgroundColor: colorPrimary,
                      strokeWidth: 2.0,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            controller.getLeaderboard(isRefresh: true);
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          buildTopRankWidget(),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(child: buildListView(context))
                        ],
                      )),
            ),
          ],
        );
      }),
    );
  }

  buildTopRankWidget() {
    var topRankList = controller.leaderBoardData.value.top3 ?? [];

    return topRankList.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: topRankList.length,
            options: CarouselOptions(
                autoPlay: true,
                //aspectRatio: 16 / 10,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.35,
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: true),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return FittedBox(
                child: Container(
                    height: 210,
                    width: 146,
                    decoration: BoxDecoration(
                        color: topRankList[index].myRank == "1"
                            ? colorPrimary
                            : colorLightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        topRankList[index].myRank == "1"
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        topRankList[index].myRank == "1"
                            ? SvgPicture.asset(
                                "assets/svg/crown_icon.svg",
                                height: 35,
                              )
                            : Container(
                                margin: const EdgeInsets.all(2),
                                width: context.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: const BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: AutoCustomTextView(
                                    text: '#${topRankList[index].myRank}',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: colorSecondary,
                                    maxLines: 1,
                                  ),
                                )),
                        SizedBox(
                          height: topRankList[index].myRank == "1" ? 15 : 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, bottom: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              avtarTopBuild(
                                  size: 100.adaptSize,
                                  shortName: topRankList[index].shortName ?? "",
                                  url: topRankList[index].avatar ?? ""),
                              const SizedBox(
                                height: 9,
                              ),
                              Flexible(
                                  child: AutoCustomTextView(
                                text: '${topRankList[index].name}',
                                textAlign: TextAlign.center,
                                //fontSize: 16,
                                color: topRankList[index].myRank == "1"
                                    ? white
                                    : colorPrimaryDark,
                                maxLines: 1,
                              )),
                              const SizedBox(
                                height: 5,
                              ),
                              AutoCustomTextView(
                                text: '${topRankList[index].point}',
                                textAlign: TextAlign.center,
                                fontSize:
                                    topRankList[index].myRank == "1" ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: topRankList[index].myRank == "1"
                                    ? white
                                    : colorPrimary,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          )
        : const SizedBox();
  }

  Widget buildListView(BuildContext context) {
    pointsList.clear();
    pointsList.addAll(controller.leaderBoardData.value.users ?? []);
    var myLeaderboard = controller.leaderBoardData.value.my?.user;
    Users users = Users(
        myRank: myLeaderboard.myRank ?? "",
        name: "You",
        shortName: myLeaderboard.shortName,
        avatar: myLeaderboard.avatar,
        point: myLeaderboard.point);
    pointsList.insert(0, users);

    return Skeletonizer(
        enabled: controller.isFirstLoadRunning.value,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (BuildContext context, int index) {
            return index == 0
                ? const SizedBox()
                : const Divider(
                    height: 3,
                  );
          },
          itemCount: pointsList.length,
          itemBuilder: (context, index) {
            Users users = pointsList[0];
            return Container(
              decoration: BoxDecoration(
                  color: index == 0 ? colorLightGray : white,
                  borderRadius: BorderRadius.circular(index == 0 ? 10 : 0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: AutoSizeText(
                                '#${users.myRank ?? ""}',
                                maxFontSize: 20,
                                minFontSize: 8,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: colorSecondary,
                                    fontFamily: MyConstant.currentFont),
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            avtarBuild(
                                shortName: users.shortName ?? "",
                                url: users.avatar ?? ""),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                text: users.name ?? "",
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w500,
                                color:
                                    index == 0 ? colorPrimary : colorSecondary,
                                fontSize: 18,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            CustomTextView(
                              color: colorPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              text: users.point ?? "",
                            ),
                            // const CustomTextView(text: "Points"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget avtarBuild({url, shortName}) {
    return url.isNotEmpty
        ? FittedBox(
            fit: BoxFit
                .cover, // the picture will acquire all of the parent space.
            child: SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(backgroundImage: NetworkImage(url))),
          )
        : Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: colorPrimaryDark,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName,
              color: white,
              textAlign: TextAlign.center,
            )),
          );
  }

  Widget avtarTopBuild({url, shortName, size}) {
    return Container(
      height: size,
      width: size,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: colorPrimaryDark),
      child: url?.toString().isNotEmpty ?? false
          ? CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Center(
                child: CustomTextView(
                  text: shortName ?? "",
                  fontSize: 18,
                  color: white,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Center(
              child: CustomTextView(
                text: shortName ?? "",
                fontSize: 18,
                color: white,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
