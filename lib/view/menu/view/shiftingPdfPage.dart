import 'dart:convert';
import 'dart:io';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/view/menu/controller/shiftingController.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/toolbarTitle.dart';
import 'package:path/path.dart' as path;

class ShifingPdfPage extends StatefulWidget {
  var shiftingList;
  ShifingPdfPage({Key? key, this.shiftingList}) : super(key: key);

  @override
  State<ShifingPdfPage> createState() => _ShifingPdfPageState();
}

class _ShifingPdfPageState extends State<ShifingPdfPage> {
  var dataLoaded = false.obs;
  ShiftingController shiftController = Get.find();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey2 = GlobalKey();

  final Dio _dio = Dio();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ToolbarTitle(
          title: "sight_seeing".tr,
          color: Colors.black,
        ),
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 0)),
        elevation: 0,
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      backgroundColor: white,
      body: GetX<ShiftingController>(builder: (shiftController){
        return Container(
          padding: const EdgeInsets.all(6),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top:60),
                  child: buildTabBody()
              ),
              SizedBox(height: 50,child: buildTabLayout(),),
              shiftController.loading.value?const Loading():const SizedBox(),
            ],
          ),
        );
      },),
    /*  floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            shiftController.downloadPath = shiftController
                .shiftingList[shiftController.tabIndex.value].webview;
            if (shiftController.tabIndex == 0) {
              shiftController.downloadFileName = "sightseeingDay1";
            } else {
              shiftController.downloadFileName = "sightseeingDay2";
            }
            Platform.isAndroid ? _download() : _downloadForIos();
          },
          child: Obx(() => dataLoaded.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.download,
                  color: white,
                ))),*/
    );
  }
  
  Widget buildTabLayout(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: shiftController.shiftingList.length,
        itemBuilder: (context,index){
      return InkWell(
        onTap: (){
          shiftController.tabIndex(index);
          shiftController.loading(true);
          Future.delayed(const Duration(seconds: 3), () {
            shiftController.loading(false);
          });
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: shiftController.tabIndex.value==index?colorLightGray:Colors.transparent
          ),
          height: 50,
          child: Center(child: CustomTextView(text:"Option ${index+1}")),
        ),
      );
    });
  }

  Widget buildTabBody() {
    var data=shiftController.shiftingList[shiftController.tabIndex.value];
    shiftController.pdfUrl(data.webview);
    return Stack(
      children: [
        SfPdfViewer.network(
          shiftController.pdfUrl.value,
          key: _pdfViewerKey,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: bottomWidget(),
        )
      ],
    );
  }

  Widget bottomWidget() {
    var data=shiftController.shiftingList[shiftController.tabIndex.value];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(12),
            height: 100,
            decoration: const BoxDecoration(
                color: grayColorLight,
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        shiftController.shiftingList[shiftController.tabIndex.value].isInterested="1";
                        shiftController.refresh();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(data.isInterested=="1"?Icons.radio_button_checked:Icons.radio_button_off,color: white,),
                      ),
                    ),
                    CustomTextView(text: "interested".tr,color: white,)
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: (){
                            shiftController.shiftingList[shiftController.tabIndex.value].isInterested="0";
                            shiftController.refresh();
                            setState(() {});
                          },
                          child: Icon(data.isInterested=="0"?Icons.radio_button_checked:Icons.radio_button_off,color: white,)),
                    ),
                    CustomTextView(text: "not_interested".tr,color: white,)
                  ],
                ),
                const SizedBox(width: 6,),
                SizedBox(
                  width: 80,
                  child: MaterialButton(
                      animationDuration: const Duration(seconds: 1),
                      color: colorLightGray,
                      hoverColor: colorSecondary,
                      splashColor: colorSecondary,
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        var requestBody = {
                          "interested": data.isInterested,
                          "interested_date": data.status??"",
                        };
                        shiftController.saveShftingData(requestBody);
                      },
                      child: CustomTextView(
                        text: "submit".tr,
                        color: colorSecondary,
                        fontSize: 12,
                      )),
                )
              ],
            ),
          );
        });

  }

  Future<void> _download() async {
    dataLoaded(true);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    String? filePath = await _getDownloadDirectory();
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();
    final savePath = path.join(directory?.path ?? "",
        "${shiftController.downloadFileName ?? "exl2024"}.pdf");
    await _startDownload(savePath, shiftController.downloadPath);
  }

  Future<void> _downloadForIos() async {
    dataLoaded(true);
    final dir = await _getDownloadDirectoryIos();
    final isPermissionStatusGranted =
        await _requestPermission(Permission.storage);

    final hasExisted = dir?.existsSync() ?? false;
    if (!hasExisted) {
      await dir?.create();
    }
    if (isPermissionStatusGranted && dir != null) {
      final savePath = path.join(
          dir.path, "${shiftController.downloadFileName ?? "exl2024"}" ".pdf");
      await _startDownload(savePath, shiftController.downloadPath);
    } else {
      print("please check permission");
    }
  }

  Future<void> _startDownload(String savePath, String file) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(
        file,
        savePath,
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      dataLoaded(false);
      //UiHelper.showSnakbarSucess(null,"Pdf Downloaded in your app folder");
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
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
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();
      return directory;
    } catch (e) {
      return await getExternalStorageDirectory();
    }
  }

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
        isSuccess ? 'success'.tr : 'failure'.tr,
        isSuccess
            ? "file_uploaded_success".tr
            : "file_upload_error".tr,
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification
  Future<void> _onSelectNotification(String json) async {
    print(json);
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      UiHelper.showSuccessMsg(null, "${obj['error']}");
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
