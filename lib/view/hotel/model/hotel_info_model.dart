class InfoDashboardModel {
  Head? head;
  List<DashboardInfoData>? body;

  InfoDashboardModel({this.head, this.body});

  InfoDashboardModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    if (json['body'] != null) {
      body = <DashboardInfoData>[];
      json['body'].forEach((v) {
        body!.add(new DashboardInfoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (head != null) {
      data['head'] = head!.toJson();
    }
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Head {
  bool? status;
  int? code;
  String? message;

  Head({this.status, this.code, this.message});

  Head.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class DashboardInfoData {
  String? type;
  String? name;
  List<Data>? data;

  DashboardInfoData({this.type, this.name, this.data});

  DashboardInfoData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['name'] = name;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? departureFrom;
  String? departureLabel;
  String? departureDate;
  String? destination;
  String? returnDate;
  String? pnrNumber;
  String? airline;
  dynamic ticket;
  String? hotelName;
  String? hotelCheckinDate;
  String? hotelCheckoutDate;
  String? roomNumber;
  String? bookedFor;
  dynamic visaNumber;
  String? visaValidUpto;
  String? travelDateTime;
  Data(
      {this.departureFrom,this.departureLabel,
        this.departureDate,
        this.destination,
        this.returnDate,
        this.pnrNumber,
        this.airline,
        this.ticket,this.hotelName,
        this.hotelCheckinDate,
        this.hotelCheckoutDate,
        this.roomNumber,
        this.bookedFor,
        this.visaNumber,
        this.visaValidUpto,
        this.travelDateTime});

  Data.fromJson(Map<String, dynamic> json) {
    departureFrom = json['departure_from'];
    departureLabel = json['is_return'];
    departureDate = json['departure_date'];
    destination = json['destination'];
    returnDate = json['return_date'];
    pnrNumber = json['pnr_number'];
    airline = json['airline'];
    ticket = json['ticket'];
    hotelName = json['hotel_name'];
    hotelCheckinDate = json['hotel_checkin_date'];
    hotelCheckoutDate = json['hotel_checkout_date'];
    roomNumber = json['room_number'];
    bookedFor = json['booked_for'];
    visaNumber = json['visa_number'];
    visaValidUpto = json['visa_valid_upto'];
    travelDateTime = json['travel_date_and_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_return']=departureLabel;
    data['departure_from'] = departureFrom;
    data['departure_date'] = departureDate;
    data['destination'] = destination;
    data['return_date'] = returnDate;
    data['pnr_number'] = pnrNumber;
    data['airline'] = airline;
    data['ticket'] = ticket;
    data['hotel_name'] = hotelName;
    data['hotel_checkin_date'] = hotelCheckinDate;
    data['hotel_checkout_date'] = hotelCheckoutDate;
    data['room_number'] = roomNumber;
    data['booked_for'] = bookedFor;
    data['visa_number'] = visaNumber;
    data['visa_valid_upto'] = visaValidUpto;
    data['travel_date_and_time'] = travelDateTime;
    return data;
  }
}