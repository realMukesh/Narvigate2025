class GalleryModel {
  bool? status;
  int? code;
  String? message;
  Gallery? body;

  GalleryModel({this.status, this.code, this.message, this.body});

  GalleryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Gallery.fromJson(json['body']) : null;
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

class Gallery {
  List<Briefcases>? briefcases;
  bool? hasNextPage;
  Request? request;
  int? totalItems;

  Gallery({this.briefcases, this.hasNextPage, this.request, this.totalItems});

  Gallery.fromJson(Map<String, dynamic> json) {
    if (json['briefcases'] != null) {
      briefcases = <Briefcases>[];
      json['briefcases'].forEach((v) {
        briefcases!.add(new Briefcases.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.briefcases != null) {
      data['briefcases'] = this.briefcases!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = this.hasNextPage;
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    data['totalItems'] = this.totalItems;
    return data;
  }
}

class Briefcases {
  String? id;
  String? name;
  String? assetType;
  String? mediaType;
  String? media;
  String? videoPath;
  int? status;
  String? displayOrder;
  String? created;
  String? modified;

  Briefcases(
      {this.id,
        this.name,
        this.assetType,
        this.mediaType,
        this.media,
        this.videoPath,
        this.status,
        this.displayOrder,
        this.created,
        this.modified});

  Briefcases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    assetType = json['asset_type'];
    mediaType = json['media_type'];
    media = json['media'];
    videoPath = json['video_path'];
    status = json['status'];
    displayOrder = json['display_order'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['asset_type'] = this.assetType;
    data['media_type'] = this.mediaType;
    data['media'] = this.media;
    data['video_path'] = this.videoPath;
    data['status'] = this.status;
    data['display_order'] = this.displayOrder;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}

class Request {
  int? page;
  String? type;
  String? text;

  Request({this.page, this.type, this.text});

  Request.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    type = json['type'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['type'] = this.type;
    data['text'] = this.text;
    return data;
  }
}
