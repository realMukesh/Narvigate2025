import 'package:get/get.dart';

import '../../../widgets/az_listview/src/az_common.dart';

/*
class ContactListModel {
  Body? body;
  bool? status;
  int? code;
  ContactListModel({this.status, this.code, this.body});

  ContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  List<Contacts>? contacts;
  bool? hasNextPage;
  Request? request;

  Body({this.contacts, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Contacts extends ISuspensionBean {
  String? id;
  String? iam;
  String? type;
  User? user;

  Contacts({this.id, this.iam, this.user,this.type});

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iam = json['iam'];
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iam'] = this.iam;
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  @override
  String getSuspensionTag() {
    throw UnimplementedError();
  }
}

class User {
  var isLoading=false.obs;
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  String? avatar;
  String? role;
  String? timezone;
  String? type;
  dynamic accessType;
  String? mobile;
  String? email;


  User(
      {this.id,
        this.name,
        this.email,
        this.shortName,
        this.company,
        this.position,
        this.avatar,
        this.role,
        this.timezone,
        this.accessType,this.type, this.mobile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    timezone = json['timezone'];
    type = json['type'];
    accessType = json['access_type'];
    mobile = json['mobile'];
    email = json['email'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    data['type'] = this.type;
    data['access_type'] = this.accessType;
    data['mobile'] = this.mobile;
    data['email'] = this.email;

    return data;
  }
}

class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}
*/

class ContactListModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  ContactListModel({this.status, this.code, this.message, this.body});

  ContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  List<Contacts>? contacts;
  bool? hasNextPage;
  Request? request;

  Body({this.contacts, this.hasNextPage, this.request});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      contacts = <Contacts>[];
      json['items'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.contacts != null) {
      data['items'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Contacts {
  String? avatar;
  String? shortName;
  String? name;
  String? company;
  String? association;
  String? position;
  String? email;
  String? mobile;
  String? id;
  String? type;
  String? role;

  Contacts(
      {this.avatar,
        this.shortName,
        this.name,
        this.company,
        this.association,
        this.position,
        this.email,
        this.mobile,
        this.id,
        this.role,
        this.type});

  Contacts.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    shortName = json['short_name'];
    name = json['name'];
    company = json['company'];
    association = json['association'];
    position = json['position'];
    email = json['email'];
    mobile = json['mobile'];
    id = json['id'];
    type = json['type'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['company'] = this.company;
    data['association'] = this.association;
    data['position'] = this.position;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['id'] = this.id;
    data['type'] = this.type;
    data['role'] = this.role;
    return data;
  }
}

class Request {
  String? search;
  dynamic page;
  String? sort;

  Request({this.search, this.page, this.sort});

  Request.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    page = json['page'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search'] = this.search;
    data['page'] = this.page;
    data['sort'] = this.sort;
    return data;
  }
}