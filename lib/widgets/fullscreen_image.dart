import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';

class FullImageView extends StatefulWidget {
  String? imgUrl;
  bool? showNotification;
  bool? showDownload;
  FullImageView(
      {super.key,
      required this.imgUrl,
      this.showNotification,
      this.showDownload});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  var progressLoading = false.obs;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  //final _dio = Dio.Dio();

  @override
  void initState() {
    super.initState();

    /// pdf download initialization
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(requestAlertPermission: true);

    const initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin!.initialize(initSettings);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Center(child: circularImage()),
            GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: widget.showDownload != null
            ? FloatingActionButton.small(
                onPressed: () async {
                  saveNetworkImage(widget.imgUrl ?? "");
                  //_download;
                },
                child: Obx(() => progressLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorPrimary,
                        ),
                      )
                    : const Icon(
                        Icons.download,
                        color: colorPrimary,
                      )))
            : null,
      ),
    );
  }

  ///the the image in gallery
  saveNetworkImage(String url) async {
    _requestPermission();
    downloadAndSaveImage(url);
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
      var res = {"isSuccess": result.isSuccess, "filePath": picturesPath};
      if (widget.showNotification == true) {
        await _showNotification(res);
      }
    }
    progressLoading(false);
  }

  Widget circularImage() {
    return SizedBox(
        height: 500,
        width: 500,
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: CachedNetworkImage(
            maxHeightDiskCache: 900,
            imageUrl: widget.imgUrl ?? "",
            imageBuilder: (context, imageProvider) => Container(
              height: context.height * 0.20,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ));
  }

/*
  */
/*used for the common image to download the img*/ /*

  Future<void> _download() async {
    progressLoading(true);
    final isPermissionStatusGranted = await _requestPermission();

    if (Platform.isAndroid) {
      String? filePath = await _getDownloadDirectory();

      if (isPermissionStatusGranted) {
        final savePath = path.join('${filePath ?? ""}/image.png');
        print("path-::::$savePath");
        await _startDownload(savePath, widget.imgUrl);
      } else {
        print("please check permission");
      }
    } else {
      final dir = await _getDownloadDirectoryIos();
      final hasExisted = dir?.existsSync() ?? false;
      if (!hasExisted) {
        await dir?.create();
      }
      if (isPermissionStatusGranted && dir != null) {
        final savePath = path.join('${dir.path}/image.png');
        await _startDownload(savePath, widget.imgUrl);
      } else {
        print("please check permission");
      }
    }
  }

  Future<String?> _getDownloadDirectory() async {
    try {
      String directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      return directory;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Directory?> _getDownloadDirectoryIos() async {
    try {
      Directory? directory = await getApplicationSupportDirectory();
      return directory;
    } catch (e) {
      return await getApplicationSupportDirectory();
    }
  }

  Future<void> _startDownload(String savePath, String file) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      var dio = Dio();
      final response = await dio.download(
        file,
        savePath,
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      progressLoading(false);
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }
*/

  /// local notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('1', 'channel name',
        // 'channel description',
        priority: Priority.high,
        importance: Importance.max);

    const platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    // print("${platform.iOS!.subtitle}" + "platform information");

    await flutterLocalNotificationsPlugin!.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      UiHelper.showSuccessMsg(null, "${obj['error']}");
    }
  }

  Future<bool> _requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      statuses = await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
    return true;
  }
}
