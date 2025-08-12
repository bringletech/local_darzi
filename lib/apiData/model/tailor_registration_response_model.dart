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
  bool? showMobileNo;
  String? name;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? latitude;
  String? longitude;
  String? address;
  String? profileUrl;
  String? deviceFcmToken;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? token;

  Tailor(
      {this.id,
        this.mobileNo,
        this.showMobileNo,
        this.name,
        this.street,
        this.city,
        this.state,
        this.postalCode,
        this.country,
        this.latitude,
        this.longitude,
        this.address,
        this.profileUrl,
        this.deviceFcmToken,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.token});

  Tailor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    showMobileNo = json['showMobileNo'];
    name = json['name'];
    street = json['Street'];
    city = json['City'];
    state = json['State'];
    postalCode = json['PostalCode'];
    country = json['Country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    profileUrl = json['profileUrl'];
    deviceFcmToken = json['device_fcm_token'];
    isDeleted = json['isDeleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['showMobileNo'] = this.showMobileNo;
    data['name'] = this.name;
    data['Street'] = this.street;
    data['City'] = this.city;
    data['State'] = this.state;
    data['PostalCode'] = this.postalCode;
    data['Country'] = this.country;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['profileUrl'] = this.profileUrl;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['isDeleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['token'] = this.token;
    return data;
  }
}