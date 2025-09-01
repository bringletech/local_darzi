class Tailor_Registration_Response_Model {
  String? message;
  Tailor? tailor;
  bool? status;

  Tailor_Registration_Response_Model({this.message, this.tailor, this.status});

  Tailor_Registration_Response_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tailor =
    json['tailor'] != null ? new Tailor.fromJson(json['tailor']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.tailor != null) {
      data['tailor'] = this.tailor!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Tailor {
  String? id;
  String? mobileNo;
  String? name;
  String? type;
  String? deviceFcmToken;
  String? token;
  bool? hideMobileNo;

  Tailor(
      {this.id,
        this.mobileNo,
        this.name,
        this.type,
        this.deviceFcmToken,
        this.token,
        this.hideMobileNo});

  Tailor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    type = json['type'];
    deviceFcmToken = json['device_fcm_token'];
    token = json['token'];
    hideMobileNo = json['hideMobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['type'] = this.type;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['token'] = this.token;
    data['hideMobileNo'] = this.hideMobileNo;
    return data;
  }
}