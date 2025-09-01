class Customer_Register_Response_Model {
  String? message;
  Customer_Data? customer;
  bool? status;

  Customer_Register_Response_Model({this.message, this.customer, this.status});

  Customer_Register_Response_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    customer = json['customer'] != null
        ? new Customer_Data.fromJson(json['customer'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Customer_Data {
  String? id;
  String? mobileNo;
  String? name;
  String? type;
  String? deviceFcmToken;
  String? token;

  Customer_Data(
      {this.id, this.mobileNo,  this.name, this.type, this.deviceFcmToken, this.token});

  Customer_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    type = json['type'];
    deviceFcmToken = json['device_fcm_token'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['type'] = this.type;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['token'] = this.token;
    return data;
  }
}