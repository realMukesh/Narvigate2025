class NearByAttrectionModel {
  bool? status;
  int? code;
  String? message;
  List<NearByData>? body;

  NearByAttrectionModel({this.status, this.code, this.message, this.body});

  NearByAttrectionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['body'] != null) {
      body = <NearByData>[];
      json['body'].forEach((v) {
        body!.add(new NearByData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearByData {
  String? id;
  String? title;
  MediaFile? mediaFile;
  String? mediaLink;
  String? description;
  Item? item;
  String? favourite;

  NearByData(
      {this.id,
        this.title,
        this.mediaFile,
        this.mediaLink,
        this.description,
        this.item,
        this.favourite});

  NearByData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mediaFile = json['media_file'] != null
        ? new MediaFile.fromJson(json['media_file'])
        : null;
    mediaLink = json['media_link'];
    description = json['description'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.mediaFile != null) {
      data['media_file'] = this.mediaFile!.toJson();
    }
    data['media_link'] = this.mediaLink;
    data['description'] = this.description;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    data['favourite'] = this.favourite;
    return data;
  }
}

class MediaFile {
  String? type;
  String? url;
  String? thumbnail;

  MediaFile({this.type, this.url, this.thumbnail});

  MediaFile.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

class Item {
  String? id;
  String? type;

  Item({this.id, this.type});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}
