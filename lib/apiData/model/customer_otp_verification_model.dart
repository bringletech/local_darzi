class Customer_Otp_Verification_Model {
  Data? data;
  String? message;
  bool? status;

  Customer_Otp_Verification_Model({this.data, this.message, this.status});

  Customer_Otp_Verification_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? id;
  String? mobileNo;
  String? name;
  String? profileUrl;
  String? address;
  String? accessToken;
  String? type;

  Data(
      {this.id,
        this.mobileNo,
        this.name,
        this.profileUrl,
        this.address,
        this.accessToken,
        this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    profileUrl = json['profileUrl'];
    address = json['address'];
    accessToken = json['accessToken'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['profileUrl'] = this.profileUrl;
    data['address'] = this.address;
    data['accessToken'] = this.accessToken;
    data['type'] = this.type;
    return data;
  }
}