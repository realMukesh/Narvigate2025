/*
class ExportModel {
  Body? body;
  bool? status;
  int? code;
  ExportModel({this.status, this.code, this.body});

  ExportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<String>? headers;
  List<ExportContacts>? contacts;

  Body({this.headers, this.contacts});

  Body.fromJson(Map<String, dynamic> json) {
    headers = json['headers'].cast<String>();
    if (json['contacts'] != null) {
      contacts = <ExportContacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new ExportContacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['headers'] = headers;
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExportContacts {
  String? name;
  String? company;
  String? position;
  String? country;
  String? email;
  String? mobile;
  String? note;

  ExportContacts(
      {this.name,
        this.company,
        this.position,
        this.country,
        this.email,
        this.mobile,this.note
       });

  ExportContacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    company = json['company'];
    position = json['position'];
    country = json['country_code'];
    email = json['email'];
    mobile = json['mobile'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['company'] = company;
    data['position'] = position;
    data['country_code'] = country;
    data['email'] = email;
    data['mobile'] = mobile;
    data['note'] = note;

    return data;
  }
}
*/

class ExportModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  ExportModel({this.status, this.code, this.message, this.body});

  ExportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  List<ExportContacts>? contacts;
  bool? hasNextPage;
  List<String>? headers;

  Body({this.contacts, this.hasNextPage, this.headers});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      contacts = <ExportContacts>[];
      json['items'].forEach((v) {
        contacts!.add(new ExportContacts.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    headers = json['header'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['items'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    data['header'] = this.headers;
    return data;
  }
}

class ExportContacts {
  String? avatar;
  String? shortName;
  String? name;
  String? company;
  String? position;
  String? association;
  String? email;
  String? country;
  String? mobile;
  String? id;
  String? type;
  String? note;

  ExportContacts(
      {this.avatar,
        this.shortName,
        this.name,
        this.company,
        this.position,
        this.association,
        this.email,
        this.country,
        this.mobile,
        this.id,
        this.type,
        this.note});

  ExportContacts.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    shortName = json['short_name'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    association = json['association'];
    email = json['email'];
    country = json['country'];
    mobile = json['mobile'];
    id = json['id'];
    type = json['type'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['company'] = this.company;
    data['position'] = this.position;
    data['association'] = this.association;
    data['email'] = this.email;
    data['country'] = this.country;
    data['mobile'] = this.mobile;
    data['id'] = this.id;
    data['type'] = this.type;
    data['note'] = this.note;
    return data;
  }
}

