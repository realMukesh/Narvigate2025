import 'dart:convert';
import 'package:dreamcast/api_repository/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/galleryModel.dart';

class GalleryController extends GetxController {
  ScrollController imageScrollController = ScrollController();
  ScrollController videoScrollController = ScrollController();
  var imageList = <Briefcases>[].obs;
  late bool hasNextPage;
  late int _pageNumber;
  late int _videoPageNumber;
  var videoList = <Briefcases>[].obs;
  var isLoading = false.obs;
  var isLoadMoreRunning = false.obs;
  var tabIndex = 0.obs; // Track the current tab index

  @override
  void onInit() {
    getImageList(type: 'image'); // Fetch images initially
    super.onInit();
  }

  Future<void> getImageList({type: 'image'}) async {
    isLoading(true);
    _pageNumber = 1;
    _videoPageNumber = 1;
    GalleryModel? model = await apiService.getGalleryList(page: _pageNumber, type: type, text: "");
    if (model.status! && model.code == 200) {
      imageList.clear();
      imageList.addAll(model.body!.briefcases!);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      _loadMoreImages();
      isLoading(false);
      update();
    } else {
      isLoading(false);
      update();
    }
  }

  /*add pagination for image.json*/
  Future<void> _loadMoreImages() async {
    imageScrollController.addListener(() async {
      if (hasNextPage == true &&
          isLoading.value == false &&
          isLoadMoreRunning.value == false &&
          imageScrollController.position.maxScrollExtent ==
              imageScrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          GalleryModel? model = await apiService.getGalleryList(page: _pageNumber, type: "image", text: "");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            imageList.addAll(model.body!.briefcases!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  Future<void> getVideoList({type: String}) async {
    isLoading(true);
    _videoPageNumber = 1;
    GalleryModel? model = await apiService.getGalleryList(page: _videoPageNumber, type: type, text: "");
    isLoading(false);
    if (model.status! && model.code == 200) {
      videoList.clear();
      videoList.addAll(model.body!.briefcases!);
      videoList.refresh();
      hasNextPage = model.body?.hasNextPage ?? false;
      _videoPageNumber = _videoPageNumber + 1;
      _loadMoreVideos();
      isLoading(false);
      update();
    } else {
      isLoading(false);
      update();
    }
  }

  /*add pagination for video.json*/
  Future<void> _loadMoreVideos() async {
    imageScrollController.addListener(() async {
      if (hasNextPage == true &&
          isLoading.value == false &&
          isLoadMoreRunning.value == false &&
          imageScrollController.position.maxScrollExtent ==
              imageScrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          GalleryModel? model = await apiService.getGalleryList(page: _videoPageNumber, type: "youtube", text: "");
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _videoPageNumber = _videoPageNumber + 1;
            videoList.addAll(model.body!.briefcases!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  void openVideo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  // Call this method when the tab changes
  void onTabChanged(int index) {
    tabIndex.value = index;
    if (index == 0) {
      // If on the Images tab, fetch images
      getImageList(type: 'image');
    } else if (index == 1) {
      // If on the Videos tab, fetch videos
      getVideoList(type: 'youtube');
    }
  }
}
