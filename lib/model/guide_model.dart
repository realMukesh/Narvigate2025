class IFrameModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  IFrameModel({this.status, this.code, this.message, this.body});

  IFrameModel.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  MessageData? messageData;
  String? webview;

  Body({this.status, this.messageData, this.webview});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messageData = json['message'] != null
        ? new MessageData.fromJson(json['message'])
        : null;
    webview = json['webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.messageData != null) {
      data['message'] = this.messageData!.toJson();
    }
    data['webview'] = this.webview;
    return data;
  }
}

class MessageData {
  String? title;
  String? body;

  MessageData({this.title, this.body});

  MessageData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

/*class IFrameModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  IFrameModel({this.body,this.status, this.code, this.message});

  IFrameModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  Guides? guide;
  String? webview;
  bool? status;
  Body({this.guide,this.webview,this.status});

  Body.fromJson(Map<String, dynamic> json) {
    guide =
    json['guide'] != null ? new Guides.fromJson(json['guide']) : null;
    webview = json['webview'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (guide != null) {
      data['guide'] = guide!.toJson();
    }
    data['webview'] = webview;
    data['status'] = status;
    return data;
  }
}

class Guides {
  String? label;
  String? mediaUrl;
  String? mediaType;

  Guides(
      {
        this.label,
        this.mediaUrl,
        this.mediaType});

  Guides.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = label;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;

    return data;
  }
}
 */