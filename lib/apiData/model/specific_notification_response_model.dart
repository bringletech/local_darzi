class SpecificNotificationResponseModel {
  String? message;
  Specific_Notification_Data? data;
  bool? status;

  SpecificNotificationResponseModel({this.message, this.data, this.status});

  SpecificNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Specific_Notification_Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Specific_Notification_Data {
  OrderData? orderData;

  Specific_Notification_Data({this.orderData});

  Specific_Notification_Data.fromJson(Map<String, dynamic> json) {
    orderData = json['orderData'] != null
        ? new OrderData.fromJson(json['orderData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderData != null) {
      data['orderData'] = this.orderData!.toJson();
    }
    return data;
  }
}

class OrderData {
  int? cost;
  String? name;
  String? status;
  int? advance;
  String? dueDate;
  String? dressName;
  String? dressImgUrl;
  int? outstandingBalance;

  OrderData(
      {this.cost,
        this.name,
        this.status,
        this.advance,
        this.dueDate,
        this.dressName,
        this.dressImgUrl,
        this.outstandingBalance});

  OrderData.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    name = json['name'];
    status = json['status'];
    advance = json['advance'];
    dueDate = json['dueDate'];
    dressName = json['dressName'];
    dressImgUrl = json['dressImgUrl'];
    outstandingBalance = json['outstandingBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost'] = this.cost;
    data['name'] = this.name;
    data['status'] = this.status;
    data['advance'] = this.advance;
    data['dueDate'] = this.dueDate;
    data['dressName'] = this.dressName;
    data['dressImgUrl'] = this.dressImgUrl;
    data['outstandingBalance'] = this.outstandingBalance;
    return data;
  }
}