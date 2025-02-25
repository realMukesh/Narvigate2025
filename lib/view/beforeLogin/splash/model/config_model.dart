class ConfigModel {
  bool? status;
  int? code;
  String? message;
  Body? body;

  ConfigModel({this.status, this.code, this.message, this.body});

  ConfigModel.fromJson(Map<String, dynamic> json) {
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
  QuickLinks? quickLinks;
  Config? config;
  Meta? meta;
  Pages? pages;
  Iam? iam;
  Flutter? flutter;
  LinkedInDetail? linkedInDetail;

  Body(
      {this.config,
      this.meta,
      this.pages,
      this.iam,
      this.flutter,
      this.quickLinks,
      this.linkedInDetail});

  Body.fromJson(Map<String, dynamic> json) {
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    pages = json['pages'] != null ? new Pages.fromJson(json['pages']) : null;
    iam = json['iam'] != null ? new Iam.fromJson(json['iam']) : null;
    flutter =
        json['flutter'] != null ? new Flutter.fromJson(json['flutter']) : null;
    quickLinks =
        json['theme'] != null ? new QuickLinks.fromJson(json['theme']) : null;
    linkedInDetail = json['social_login'] != null
        ? new LinkedInDetail.fromJson(json['social_login'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.pages != null) {
      data['pages'] = this.pages!.toJson();
    }
    if (this.iam != null) {
      data['iam'] = this.iam!.toJson();
    }
    if (this.flutter != null) {
      data['flutter'] = this.flutter!.toJson();
    }
    if (this.quickLinks != null) {
      data['theme'] = this.quickLinks!.toJson();
    }
    if (this.linkedInDetail != null) {
      data['social_login'] = this.linkedInDetail;
    }
    return data;
  }
}

class Config {
  Firebase? firebase;
  Node? node;
  Analytic? analytic;

  Config({this.firebase, this.node, this.analytic});

  Config.fromJson(Map<String, dynamic> json) {
    firebase = json['firebase'] != null
        ? new Firebase.fromJson(json['firebase'])
        : null;
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
    analytic = json['analytic'] != null
        ? new Analytic.fromJson(json['analytic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.firebase != null) {
      data['firebase'] = this.firebase!.toJson();
    }
    if (this.node != null) {
      data['node'] = this.node!.toJson();
    }
    if (this.analytic != null) {
      data['analytic'] = this.analytic!.toJson();
    }

    return data;
  }
}

class Firebase {
  Configs? configs;
  String? name;
  String? messaging;
  Topics? topics;

  Firebase({this.configs, this.name, this.messaging, this.topics});

  Firebase.fromJson(Map<String, dynamic> json) {
    configs =
        json['configs'] != null ? new Configs.fromJson(json['configs']) : null;
    name = json['name'];
    messaging = json['messaging'];
    topics =
        json['topics'] != null ? new Topics.fromJson(json['topics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.configs != null) {
      data['configs'] = this.configs!.toJson();
    }
    data['name'] = this.name;
    data['messaging'] = this.messaging;
    if (this.topics != null) {
      data['topics'] = this.topics!.toJson();
    }
    return data;
  }
}

class Configs {
  String? apiKey;
  String? authDomain;
  String? projectId;
  String? databaseURL;
  String? storageBucket;
  String? messagingSenderId;
  String? appId;
  String? measurementId;

  Configs(
      {this.apiKey,
      this.authDomain,
      this.projectId,
      this.databaseURL,
      this.storageBucket,
      this.messagingSenderId,
      this.appId,
      this.measurementId});

  Configs.fromJson(Map<String, dynamic> json) {
    apiKey = json['apiKey'];
    authDomain = json['authDomain'];
    projectId = json['projectId'];
    databaseURL = json['databaseURL'];
    storageBucket = json['storageBucket'];
    messagingSenderId = json['messagingSenderId'];
    appId = json['appId'];
    measurementId = json['measurementId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiKey'] = this.apiKey;
    data['authDomain'] = this.authDomain;
    data['projectId'] = this.projectId;
    data['databaseURL'] = this.databaseURL;
    data['storageBucket'] = this.storageBucket;
    data['messagingSenderId'] = this.messagingSenderId;
    data['appId'] = this.appId;
    data['measurementId'] = this.measurementId;
    return data;
  }
}

class Topics {
  String? all;
  String? user;
  String? representative;

  Topics({this.all, this.user, this.representative});

  Topics.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    user = json['user'];
    representative = json['representative'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['user'] = this.user;
    data['representative'] = this.representative;
    return data;
  }
}

class Node {
  String? url;
  String? port;

  Node({this.url, this.port});

  Node.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    port = json['port'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['port'] = this.port;
    return data;
  }
}

class Analytic {
  String? google;
  String? facebook;

  Analytic({this.google, this.facebook});

  Analytic.fromJson(Map<String, dynamic> json) {
    google = json['google'];
    facebook = json['facebook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google'] = this.google;
    data['facebook'] = this.facebook;
    return data;
  }
}

class Default {
  Video? video;
  Video? audio;

  Default({this.video, this.audio});

  Default.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    audio = json['audio'] != null ? new Video.fromJson(json['audio']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    if (this.audio != null) {
      data['audio'] = this.audio!.toJson();
    }
    return data;
  }
}

class Video {
  bool? status;
  String? path;

  Video({this.status, this.path});

  Video.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['path'] = this.path;
    return data;
  }
}

class Meta {
  String? title;
  String? favicon;
  Logos? logos;
  Backgrounds? backgrounds;

  Meta({this.title, this.favicon, this.logos, this.backgrounds});

  Meta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    favicon = json['favicon'];
    logos = json['logo'] != null ? new Logos.fromJson(json['logo']) : null;
    backgrounds = json['backgrounds'] != null
        ? new Backgrounds.fromJson(json['backgrounds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['favicon'] = this.favicon;
    if (this.logos != null) {
      data['logo'] = this.logos!.toJson();
    }
    if (this.backgrounds != null) {
      data['backgrounds'] = this.backgrounds!.toJson();
    }
    return data;
  }
}

class Logos {
  String? icon;
  String? url;

  Logos({this.icon, this.url});

  Logos.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}

class Backgrounds {
  String? loginBg;
  String? signinByOtp;
  String? forgotPassword;
  String? resetPassword;
  String? signup;

  Backgrounds(
      {this.loginBg,
      this.signinByOtp,
      this.forgotPassword,
      this.resetPassword,
      this.signup});

  Backgrounds.fromJson(Map<String, dynamic> json) {
    loginBg = json['signin'];
    signinByOtp = json['signin_by_otp'];
    forgotPassword = json['forgot_password'];
    resetPassword = json['reset_password'];
    signup = json['signup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['signin'] = this.loginBg;
    data['signin_by_otp'] = this.signinByOtp;
    data['forgot_password'] = this.forgotPassword;
    data['reset_password'] = this.resetPassword;
    data['signup'] = this.signup;
    return data;
  }
}

class Pages {
  List<Signin>? signin;
  List<Signin>? signinByOtp;
  List<Signin>? forgotPassword;
  Signup? signup;

  Pages({this.signin, this.signinByOtp, this.forgotPassword});

  Pages.fromJson(Map<String, dynamic> json) {
    signup =
        json['signup'] != null ? new Signup.fromJson(json['signup']) : null;
    if (json['signin'] != null) {
      signin = <Signin>[];
      json['signin'].forEach((v) {
        signin!.add(new Signin.fromJson(v));
      });
    }
    if (json['signin_by_otp'] != null) {
      signinByOtp = <Signin>[];
      json['signin_by_otp'].forEach((v) {
        signinByOtp!.add(new Signin.fromJson(v));
      });
    }
    if (json['forgot_password'] != null) {
      forgotPassword = <Signin>[];
      json['forgot_password'].forEach((v) {
        forgotPassword!.add(new Signin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.signup != null) {
      data['signup'] = this.signup!.toJson();
    }
    if (this.signin != null) {
      data['signin'] = this.signin!.map((v) => v.toJson()).toList();
    }
    if (this.signinByOtp != null) {
      data['signin_by_otp'] = this.signinByOtp!.map((v) => v.toJson()).toList();
    }
    if (this.forgotPassword != null) {
      data['forgot_password'] =
          this.forgotPassword!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? value;
  String? text;

  Options({this.value, this.text});

  Options.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}

class Signin {
  int? step;
  String? name;
  String? validationAs;
  String? placeholder;
  String? label;
  String? type;
  String? value;
  String? rules;

  Signin(
      {this.step,
      this.name,
      this.validationAs,
      this.placeholder,
      this.label,
      this.type,
      this.value,
      this.rules});

  Signin.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    name = json['name'];
    validationAs = json['validation_as'];
    placeholder = json['placeholder'];
    label = json['label'];
    type = json['type'];
    value = json['value'];
    rules = json['rules'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = this.step;
    data['name'] = this.name;
    data['validation_as'] = this.validationAs;
    data['placeholder'] = this.placeholder;
    data['label'] = this.label;
    data['type'] = this.type;
    data['value'] = this.value;
    data['rules'] = this.rules;
    return data;
  }
}

class Signup {
  String? type;
  String? url;
  String? whatsApp;
  // List<SignupField>? fields;

  Signup({
    this.type,
    this.url,
    /*this.fields*/
  });

  Signup.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    whatsApp = json['whatsapp'];
    url = json['url'];
    /*if (json['fields'] != null) {
      fields = <SignupField>[];
      json['fields'].forEach((v) {
        fields!.add(new SignupField.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['whatsapp'] = this.whatsApp;
    data['url'] = this.url;
    /* if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class SignupField {
  int? step;
  String? label;
  String? name;
  String? type;
  String? placeholder;
  String? value;
  String? rules;
  String? errorLabel;
  int? size;
  bool? crop;
  int? cropWidth;
  int? cropHeight;
  int? aspectRatio;
  List<String>? accept;
  String? poster;
  bool? readonly;
  List<Options>? options;

  SignupField(
      {this.step,
      this.label,
      this.name,
      this.type,
      this.placeholder,
      this.value,
      this.rules,
      this.errorLabel,
      this.size,
      this.crop,
      this.cropWidth,
      this.cropHeight,
      this.aspectRatio,
      this.accept,
      this.poster,
      this.readonly,
      this.options});

  SignupField.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    label = json['label'];
    name = json['name'];
    type = json['type'];
    placeholder = json['placeholder'];
    value = json['value'];
    rules = json['rules'];
    errorLabel = json['error_label'];
    size = json['size'];
    crop = json['crop'];
    cropWidth = json['cropWidth'];
    cropHeight = json['cropHeight'];
    aspectRatio = json['aspectRatio'];
    accept = json['accept'].cast<String>();
    poster = json['poster'];
    readonly = json['readonly'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = this.step;
    data['label'] = this.label;
    data['name'] = this.name;
    data['type'] = this.type;
    data['placeholder'] = this.placeholder;
    data['value'] = this.value;
    data['rules'] = this.rules;
    data['error_label'] = this.errorLabel;
    data['size'] = this.size;
    data['crop'] = this.crop;
    data['cropWidth'] = this.cropWidth;
    data['cropHeight'] = this.cropHeight;
    data['aspectRatio'] = this.aspectRatio;
    data['accept'] = this.accept;
    data['poster'] = this.poster;
    data['readonly'] = this.readonly;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Iam {
  int? status;
  bool? isExhibitor;
  int? hasProfileUpdate;
  String? id;
  String? name;
  String? shortName;
  String? company;
  String? position;
  dynamic avatar;
  String? role;
  String? vendor;
  String? timezone;
  String? parentId;
  String? token;
  String? sso;

  Iam(
      {this.status,
      this.isExhibitor,
      this.hasProfileUpdate,
      this.id,
      this.name,
      this.shortName,
      this.company,
      this.position,
      this.avatar,
      this.role,
      this.vendor,
      this.timezone,
      this.parentId,
      this.token,
      this.sso});

  Iam.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isExhibitor = json['is_exhibitor'];
    hasProfileUpdate = json['has_profile_update'];
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    role = json['role'];
    vendor = json['vendor'];
    timezone = json['timezone'];
    parentId = json['parent_id'];
    token = json['token'];
    sso = json['sso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_exhibitor'] = this.isExhibitor;
    data['has_profile_update'] = this.hasProfileUpdate;
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['company'] = this.company;
    data['position'] = this.position;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['vendor'] = this.vendor;
    data['timezone'] = this.timezone;
    data['parent_id'] = this.parentId;
    data['token'] = this.token;
    data['sso'] = this.sso;
    return data;
  }
}

class Flutter {
  String? version;
  bool? forceDownload;
  String? updateMessage;
  String? playStoreUrl;
  String? appStoreUrl;

  Flutter({this.version, this.forceDownload, this.updateMessage});

  Flutter.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    forceDownload = json['force_download'];
    updateMessage = json['update_message'];
    playStoreUrl = json['play_store_url'];
    appStoreUrl = json['app_store_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['force_download'] = this.forceDownload;
    data['update_message'] = this.updateMessage;
    data['play_store_url'] = this.playStoreUrl;
    data['app_store_url'] = this.appStoreUrl;
    return data;
  }
}

class QuickLinks {
  PrivacyPolicy? privacyPolicy;
  PrivacyPolicy? termsOfUse;
  PrivacyPolicy? cookiePolicy;
  PrivacyPolicy? visitorTermsConditions;

  QuickLinks(
      {this.privacyPolicy,
      this.termsOfUse,
      this.cookiePolicy,
      this.visitorTermsConditions});

  QuickLinks.fromJson(Map<String, dynamic> json) {
    privacyPolicy = json['privacy_policy'] != null
        ? new PrivacyPolicy.fromJson(json['privacy_policy'])
        : null;
    termsOfUse = json['terms_of_use'] != null
        ? new PrivacyPolicy.fromJson(json['terms_of_use'])
        : null;
    cookiePolicy = json['cookie_policy'] != null
        ? new PrivacyPolicy.fromJson(json['cookie_policy'])
        : null;
    visitorTermsConditions = json['visitor_terms_conditions'] != null
        ? new PrivacyPolicy.fromJson(json['visitor_terms_conditions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.privacyPolicy != null) {
      data['privacy_policy'] = this.privacyPolicy!.toJson();
    }
    if (this.termsOfUse != null) {
      data['terms_of_use'] = this.termsOfUse!.toJson();
    }
    if (this.cookiePolicy != null) {
      data['cookie_policy'] = this.cookiePolicy!.toJson();
    }
    if (this.visitorTermsConditions != null) {
      data['visitor_terms_conditions'] = this.visitorTermsConditions!.toJson();
    }
    return data;
  }
}

class PrivacyPolicy {
  String? label;
  bool? status;
  String? url;

  PrivacyPolicy({this.label, this.status, this.url});

  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}

class LinkedInDetail {
  String? clientId;
  String? clientSecret;
  String? redirectUrl;

  LinkedInDetail({this.clientId, this.clientSecret, this.redirectUrl});

  LinkedInDetail.fromJson(Map<String, dynamic> json) {
    clientSecret = json['client_secret'];
    clientId = json['client_id'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_secret'] = this.clientSecret;
    data['client_id'] = this.clientId;
    data['redirect_url'] = this.redirectUrl;
    return data;
  }
}
