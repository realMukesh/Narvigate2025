import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dreamcast/view/contact/model/contact_export_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api_repository/api_service.dart';
import '../../../theme/ui_helper.dart';
import '../../../utils/dialog_constant.dart';
import '../../beforeLogin/globalController/authentication_manager.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../model/contact_list_model.dart';
import '../model/model_contact_filter.dart';
import 'dart:io' show Directory, File, Platform;
import 'package:path_provider/path_provider.dart';

class ContactController extends GetxController {
  late final AuthenticationManager _authenticationManager;
  AuthenticationManager get authenticationManager => _authenticationManager;

  late bool hasNextPage;
  late int _pageNumber;
  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  var isLoading = false.obs;
  var isFavLoading = false.obs;

  final textController = TextEditingController().obs;
  ScrollController scrollController = ScrollController();
  var contactList = <Contacts>[].obs;
  List<Contacts> _searchResult = [];

  var newRequestBody = {};
  var userIdsList = <dynamic>[];
  var exportContactList = <ExportModel>[];
  var filterContactBody = ContactFilterData().obs;
  var selectedFilterIndex = 0.obs;
  var csvPath;

  @override
  void onInit() {
    _authenticationManager = Get.find();
    _pageNumber = 1;
    hasNextPage = false;
    super.onInit();
    getFilter();
    getContactList(requestBody: {
      "page": "1",
      "filters": {
        "search": "",
        "sort": "ASC",
        "type": filterContactBody.value.selectedItem ?? ""
      }
    });
    dependencies();
  }

  void dependencies() {
    Get.lazyPut(() => UserDetailController(), fenix: true);
  }

  Future<void> getContactList({required requestBody}) async {
    newRequestBody = requestBody;
    isFirstLoadRunning(true);
    ContactListModel? model = await apiService.getContactList(requestBody);
    if (model.status! && model.code == 200) {
      contactList.clear();
      contactList.addAll(model.body!.contacts!);
      hasNextPage = model.body?.hasNextPage ?? false;
      _pageNumber = _pageNumber + 1;
      _pageNumber = int.parse(model.body?.request?.page ?? "0");
      _loadMoreContact();
      isFirstLoadRunning(false);
    } else {
      isFirstLoadRunning(false);
      print(model?.code.toString());
    }
  }

  /*load more data*/
  Future<void> _loadMoreContact() async {
    scrollController.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        isLoadMoreRunning(true);
        newRequestBody["page"] = _pageNumber.toString();
        try {
          ContactListModel? model =
              await apiService.getContactList(newRequestBody);
          if (model.status! && model.code == 200) {
            hasNextPage = model.body!.hasNextPage!;
            _pageNumber = _pageNumber + 1;
            contactList.addAll(model.body!.contacts!);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }

  Future<bool?> exportContact({required BuildContext context}) async {
    isLoading(true);
    ExportModel model = await apiService.exportContact();
    print("Export contacts done $model");
    isLoading(false);
    if (model.status! && model.code == 200) {
      exportContactList.clear();
      exportContactList.add(model);
      return true;
    } else {
      return false;
    }
  }

  Future<void> getFilter() async {
    FilterContactModel? model = await apiService.getFilterContact();
    try {
      if (model.status ?? false && model.code == 200) {
        if (model.body != null &&
            model.body?.params != null &&
            model.body!.params!.isNotEmpty) {
          filterContactBody(model.body!.params![0]);
          if (filterContactBody.value.options != null &&
              filterContactBody.value.options!.isNotEmpty) {
            filterContactBody.value.selectedItem =
                filterContactBody.value.options![0].text;
          }
          filterContactBody.refresh();
        }
      }
    } catch (e) {
      filterContactBody(model.body!.params![0]);
      e.toString();
    }
  }

  Future<void> requestPermissionAndSaveContact(
      BuildContext context, Contacts representatives) async {
    // Request permission to access contacts
    // bool permissionGranted = await FlutterContacts.requestPermission();
    bool? permissionGranted =
        await UiHelper.checkAndRequestContactPermissions();

    if (permissionGranted!) {
      // Create a new contact object
      Contact newContact = Contact()
        ..name.first = representatives.name ?? ""
        ..emails = [Email(representatives.email ?? "")]
        ..organizations = [
          Organization(
              company: representatives.company ?? "",
              department: representatives.position ?? "")
        ]
        ..phones = [Phone(representatives.mobile ?? "")];
      try {
        // Save the contact to the phone's contact list
        await newContact.insert();
        UiHelper.showSuccessMsg(context, "Contact saved successfully!");
      } catch (e) {
        UiHelper.showFailureMsg(context, "Failed to save contact!");
      }
    } else {
      PermissionStatus status = await Permission.contacts.status;
      if (Platform.isIOS && status.isDenied) {
        DialogConstant.showPermissionDialog(message: "contact_permission".tr);
      } else if (Platform.isAndroid && status.isPermanentlyDenied) {
        DialogConstant.showPermissionDialog(message: "contact_permission".tr);
      }
      print(status.isDenied);
      print(status.isPermanentlyDenied);
    }
  }

  void generateCsvFile() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    for (var data in exportContactList[0].body?.headers ?? []) {
      row.add(data);
    }
    rows.add(row);
    for (int i = 0; i < exportContactList[0].body!.contacts!.length; i++) {
      ExportContacts contacts = exportContactList[0].body!.contacts![i];

      List<dynamic> row = [];
      row.add(contacts.name ?? "");
      row.add(contacts.email ?? "");
      row.add(contacts.country ?? "");
      row.add(contacts.mobile ?? "");
      row.add(contacts.company ?? "");
      row.add(contacts.position ?? "");
      row.add(contacts.note ?? "");
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Get the directory to store the file
    Directory? directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/Narvigate-2025.csv";

    // Write CSV data to the file
    File file = File(filePath);
    await file.writeAsString(csv);
    XFile xFile = XFile(file.path);
    // Share the file
    await Share.shareXFiles([xFile], text: "Here is your CSV file");
    return;
    /*Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();

    if (directory?.path != null) {
      File f = File("${directory!.path}/${MyConstant.appName}-contact.csv");

      XFile filePath = XFile(directory.path);

      // Write CSV data to file
      await f.writeAsString(csv);
      // Share the file
      await Share.shareXFiles([filePath], text: "Here is your CSV file");

      */ /*if (f.path != null) {
        try {
          var exception = OpenFile.open(f.path);
        } catch (e) {
          print('exception-:$e');
        }
      }*/ /*
    }*/
  }
}
