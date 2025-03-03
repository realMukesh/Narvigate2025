import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/dialog_constant.dart';
import 'package:dreamcast/view/photobooth/model/myPhotoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';
import '../../../api_repository/api_service.dart';
import '../../../model/common_model.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../../widgets/customTextView.dart';
import '../model/photoListModel.dart';
import '../view/camera_screen.dart';

class PhotoBoothController extends GetxController {
  late final AuthenticationManager _authManager;
  var loading = false.obs;
  final ImagePicker _picker = ImagePicker();
  var photoList = [].obs;
  var videoList = <String>[].obs;
  var totalPhotos = 0.obs;
  late bool hasNextPage;
  int pageNumber = 0;
  var isFirstLoadRunning = false.obs;
  var isFirstLoadVideoRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  var isLoadMoreVideoRunning = false.obs;
  var progressLoading = false.obs;
  var downloadPosition = 0.obs;
  var user_id = "";
  List<CameraDescription> cameras = [];

  var isMyPhotos = false.obs;
  var isMyVideo = false.obs;
  var totalPage = 0.obs;
  var selectedTabIndex = 1.obs;

  var uploadPhotoEnable = false.obs;

  var isCameraPermissionDenied = false.obs;
  var isCameraInitialized = false.obs;

  var isAiSearchVisible = true.obs;

  ScrollController scrollController = ScrollController();
  ScrollController scrollVideoController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _authManager = Get.find();
    user_id = _authManager.getUserId() ?? "";
    getAllPhotos(body: {"page": "1"}, isRefresh: false);
    getAvailableCameras();
  }

  ///load photos first time
  Future<void> getAllPhotos({required dynamic body, required isRefresh}) async {
    try {
      if (!isRefresh) {
        isFirstLoadRunning(true);
      }
      PhotoListModel? model = await apiService.getAiPhotoList(body);
      isFirstLoadRunning(false);
      if (model.status! && model.code == 200) {
        isMyPhotos(false);
        uploadPhotoEnable(
            model.body?.actionUploadEnable.toString() == "1" ? true : false);
        totalPhotos.value = model.body?.total ?? 0;
        photoList.clear();

        hasNextPage = model.body!.hasNextPage!;
        pageNumber = 2;
        photoList.addAll(model.body!.gallery!);

        _loadMorePhotos();
        update();
        isFirstLoadRunning(false);
      } else {
        isFirstLoadRunning(false);
        update();
      }
    } catch (e) {
      isFirstLoadRunning(false);
    } finally {
      isFirstLoadRunning(false);
    }
  }

  ///add pagination for _loadMorePhotos
  Future<void> _loadMorePhotos() async {
    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isAiSearchVisible(false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isAiSearchVisible(true);
      }

      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          PhotoListModel? model = await apiService
              .getAiPhotoList({"page": pageNumber});
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            pageNumber = pageNumber + 1;
            photoList.addAll(model.body!.gallery!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  ///load video first time
  Future<void> getAllVideo({required dynamic body, required isRefresh}) async {
    try {
      if (!isRefresh) {
        isFirstLoadVideoRunning(true);
      }
      PhotoListModel? model = await apiService.getAiPhotoList(body);
      isFirstLoadVideoRunning(false);
      if (model.status! && model.code == 200) {
        isMyPhotos(false);
        uploadPhotoEnable(
            model.body?.actionUploadEnable.toString() == "1" ? true : false);
        totalPhotos.value = model.body?.total ?? 0;
        videoList.clear();

        hasNextPage = model.body!.hasNextPage!;
        pageNumber = 2;
        videoList.addAll(model.body!.gallery!);
        _loadMoreVideo();
        update();
        isFirstLoadVideoRunning(false);
      } else {
        isFirstLoadVideoRunning(false);
        update();
      }
    } catch (e) {
      isFirstLoadVideoRunning(false);
    } finally {
      isFirstLoadVideoRunning(false);
    }
  }

  ///add pagination for _loadMorePhotos
  Future<void> _loadMoreVideo() async {
    scrollVideoController.addListener(() async {
      if (scrollVideoController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isAiSearchVisible(false);
      }
      if (scrollVideoController.position.userScrollDirection ==
          ScrollDirection.forward) {
        isAiSearchVisible(true);
      }

      if (hasNextPage == true &&
          isFirstLoadVideoRunning.value == false &&
          isLoadMoreVideoRunning.value == false &&
          scrollVideoController.position.maxScrollExtent ==
              scrollVideoController.position.pixels) {
        isLoadMoreVideoRunning(true);
        try {
          PhotoListModel? model = await apiService.getAiPhotoList({
            "page": pageNumber,
            "type": "video",
          });
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            pageNumber = pageNumber + 1;
            videoList.addAll(model.body!.gallery!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreVideoRunning(false);
      }
    });
  }

  void onTabChanged(int index) {
    // tabIndex.value = index;
    if (index == 0) {
      // If on the Images tab, fetch images
      getAllPhotos(body: {"page": 1}, isRefresh: false);
    } else if (index == 1) {
      // If on the Videos tab, fetch videos
      getAllVideo(body: {"page": 1, "type": "video"}, isRefresh: false);
    }
  }

  ///search the image by image.
  Future<void> searchAiImage({
    BuildContext? context,
    required String userId,
    required File imageFile,
  }) async {
    isMyPhotos(true);
    var formData = <String, String>{};
    formData["type"] = "file";
    isFirstLoadRunning(true);
    MyPhotoModel? responseModel =
        await apiService.searchAiPhoto(formData, imageFile.path.toString());
    isFirstLoadRunning(false);
    if (responseModel?.status ?? false) {
      photoList.clear();
      photoList.addAll(responseModel?.body ?? []);
      totalPhotos.value = photoList.length;
      photoList.refresh();
    } else {
      photoList.clear();
      totalPhotos(0);
      photoList.refresh();
      UiHelper.showFailureMsg(context, responseModel?.message ?? "Hello");
    }
  }

  ///upload the image on server
  Future<void> storeImageToServer({
    BuildContext? context,
    required String userId,
    required File imageFile,
  }) async {
    loading(true);
    CommonModel? loginResponseModel =
        await apiService.uploadImage(userId, imageFile.path.toString());
    loading(false);
    getAllPhotos(body: {"page": "1"}, isRefresh: true);
  }

  getAvailableCameras() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  ///the the image in gallery
  saveNetworkImage(String url) async {
    _requestPermission();
    downloadAndSaveImage(url);
  }

  ///search the image from camera
  imgFromCamera(isSearch) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    debugPrint("@@ camera status ${status.isDenied}");
    if (status.isPermanentlyDenied /*|| status.isDenied*/) {
      // If permission is denied or permanently denied
      DialogConstant.showPermissionDialog();
    } else {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (pickedFile != null) {
        if (isSearch) {
          searchAiImage(imageFile: File(pickedFile.path), userId: user_id);
        } else {
          storeImageToServer(imageFile: File(pickedFile.path), userId: user_id);
        }
      }
    }
  }

  ///search the image from native camera
  searchFromCamera() async {
    var result = await Get.to(CameraScreen());
    if (result != null) {
      searchAiImage(imageFile: File(result), userId: user_id);
    }
  }

  imgFromGallery(isSearch) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      // If permission is denied or permanently denied
      DialogConstant.showPermissionDialog();
    }
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      if (isSearch) {
        searchAiImage(imageFile: File(pickedFile.path), userId: user_id);
      } else {
        storeImageToServer(imageFile: File(pickedFile.path), userId: user_id);
      }
    }
  }

  _requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
  }

  // ******* Camera permission *******//
  Future<void> checkPermissionStatus(isSearch) async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      isCameraPermissionDenied(true);
    } else {
      isCameraPermissionDenied(false);
    }
  }

  void showPicker(BuildContext context, isSearch) {
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                isSearch
                    ? const SizedBox()
                    : ListTile(
                        leading: const Icon(
                          Icons.photo_library,
                          color: colorSecondary,
                        ),
                        title: CustomTextView(
                          text: "photo".tr,
                          textAlign: TextAlign.start,
                        ),
                        onTap: () {
                          imgFromGallery(isSearch);
                          Navigator.of(bc).pop();
                        }),
                ListTile(
                  leading:
                      const Icon(Icons.photo_camera, color: colorSecondary),
                  title: CustomTextView(
                      text: "camera".tr, textAlign: TextAlign.start),
                  onTap: () {
                    Navigator.of(bc).pop();
                    imgFromCamera(isSearch);
                  },
                ),
              ],
            ),
          );
        });
  }

  ///download the image from url and save it in gallery.
  downloadAndSaveImage(String url) async {
    progressLoading(true);
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    String name = url.split('/').last;
    String picturesPath = name;
    final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: picturesPath,
        androidRelativePath: "picture_imc_ai_gallery".tr,
        androidExistNotSave: true);
    if (result != null && result.isSuccess) {
      UiHelper.showSuccessMsg(null, "image_saved_in_gallery".tr);
    }
    progressLoading(false);
  }
}
