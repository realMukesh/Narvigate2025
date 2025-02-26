
class LeaderBoardModel {
  bool? status;
  int? code;
  String? message;
  LeaderBoardData? body;

  LeaderBoardModel({
    this.status,
    this.code,
    this.message,
    this.body,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? null : LeaderBoardData.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "body": body?.toJson(),
  };
}

class LeaderBoardData {
  My? my;
  dynamic term;
  List<Users>? users;
  List<Users>? top3;
  List<Criteria>? criteria=[];
  bool? status;
  String? text;

  LeaderBoardData({this.my, this.users, this.top3, this.criteria,this.term,this.status,this.text});

  LeaderBoardData.fromJson(Map<String, dynamic> json) {
    my = json['my'] != null ? new My.fromJson(json['my']) : null;
    term = json['term'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    if (json['top3'] != null) {
      top3 = <Users>[];
      json['top3'].forEach((v) {
        top3!.add(new Users.fromJson(v));
      });
    }
    if (json['criteria'] != null) {
      criteria = <Criteria>[];
      json['criteria'].forEach((v) {
        criteria!.add(new Criteria.fromJson(v));
      });
    }
    status = json['status'];
    text=json['text'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (my != null) {
      data['my'] = my!.toJson();
    }
    if (term != null) {
      data['term'] = term!.toJson();
    }
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (top3 != null) {
      data['top3'] = top3!.map((v) => v.toJson()).toList();
    }
    if (criteria != null) {
      data['criteria'] = criteria!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['text']=text;
    return data;
  }
}

class My {
  dynamic user;
  List<Points>? points=[];
  My({this.user, this.points});

  My.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(new Points.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  dynamic company;
  dynamic position;
  dynamic avatar;
  String? shortName;
  String? point;
  String? myRank;

  User(
      {this.id,
        this.name,
        this.company,
        this.position,
        this.avatar,
        this.shortName,
        this.point,
        this.myRank});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    shortName = json['short_name'];
    point = json['point'];
    myRank = json['my_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['short_name'] = shortName;
    data['point'] = point;
    data['my_rank'] = myRank;
    return data;
  }
}

class Points {
  String? action;
  String? name;
  dynamic point;
  int? multiplier;

  Points({this.action, this.name, this.point, this.multiplier});

  Points.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    name = json['name'];
    point = json['point'];
    multiplier = json['multiplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = action;
    data['name'] = name;
    data['point'] = point;
    data['multiplier'] = multiplier;
    return data;
  }
}

class Users {
  String? id;
  String? name;
  String? company;
  String? position;
  String? avatar;
  String? shortName;
  String? point;
  String? tIMESTAMP;
  String? myRank;

  Users(
      {this.id,
        this.name,
        this.company,
        this.position,
        this.avatar,
        this.shortName,
        this.point,
        this.tIMESTAMP,
        this.myRank});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    company = json['company'];
    position = json['position'];
    avatar = json['avatar'];
    shortName = json['short_name'];
    point = json['point'];
    tIMESTAMP = json['TIMESTAMP'];
    myRank = json['my_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['company'] = company;
    data['position'] = position;
    data['avatar'] = avatar;
    data['short_name'] = shortName;
    data['point'] = point;
    data['TIMESTAMP'] = tIMESTAMP;
    data['my_rank'] = myRank;
    return data;
  }
}

class Criteria {
  dynamic point;
  bool? multiple;
  String? name;
  bool? status;
  bool? uniqueActionId;
  bool? uniqueSubActionId;
  int? limit;

  Criteria({this.point, this.multiple, this.name, this.status, this.uniqueActionId, this.uniqueSubActionId, this.limit});

  Criteria.fromJson(Map<String, dynamic> json) {
    point = json['point'];
    multiple = json['multiple'];
    name = json['name'];
    status = json['status'];
    uniqueActionId = json['unique_action_id'];
    uniqueSubActionId = json['unique_sub_action_id'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['point'] = point;
    data['multiple'] = multiple;
    data['name'] = name;
    data['status'] = status;
    data['unique_action_id'] = uniqueActionId;
    data['unique_sub_action_id'] = uniqueSubActionId;
    data['limit'] = limit;
    return data;
  }
}
