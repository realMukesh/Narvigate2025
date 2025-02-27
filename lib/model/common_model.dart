class CommonModel {
  bool? status;
  int? code;
  String? message;
  dynamic body ;

  CommonModel({this.status, this.code, this.message, this.body});

  CommonModel.fromJson(Map<String, dynamic> json) {
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
    if (body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }

}
class Body {
  String? email;
  String? message;
  String? mobile;

  Body({this.email,this.message,this.mobile});

  Body.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    message = json['message'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['message'] = this.message;
    data['mobile'] = this.mobile;

    return data;
  }
}
