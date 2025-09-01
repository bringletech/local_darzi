class Get_All_Tailors_response_Model {
  List<Data>? data;
  String? message;
  bool? status;

  Get_All_Tailors_response_Model({this.data, this.message, this.status});

  Get_All_Tailors_response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? id;
  String? mobileNo;
  bool? hideMobileNo;
  String? name;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  double? latitude;
  double? longitude;
  String? address;
  String? profileUrl;
  String? otp;
  bool? isOtpVerified;
  String? deviceFcmToken;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? totalReviews;
  double? avgRating;

  Data(
      {this.id,
        this.mobileNo,
        this.hideMobileNo,
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
        this.otp,
        this.isOtpVerified,
        this.deviceFcmToken,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.totalReviews,
        this.avgRating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    hideMobileNo = json['hideMobileNo'];
    name = json['name'];
    street = json['Street'];
    city = json['City'];
    state = json['State'];
    postalCode = json['PostalCode'];
    country = json['Country'];
    latitude = (json['latitude'] != null) ? json['latitude'].toDouble() : null;
    longitude = (json['longitude'] != null) ? json['longitude'].toDouble() : null;
    address = json['address'];
    profileUrl = json['profileUrl'];
    otp = json['otp'];
    isOtpVerified = json['isOtpVerified'];
    deviceFcmToken = json['device_fcm_token'];
    isDeleted = json['isDeleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalReviews = json['totalReviews'];

    /// 👇 This line is key to fixing the crash
    avgRating = (json['avgRating'] != null) ? json['avgRating'].toDouble() : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['hideMobileNo'] = this.hideMobileNo;
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
    data['otp'] = this.otp;
    data['isOtpVerified'] = this.isOtpVerified;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['isDeleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['totalReviews'] = this.totalReviews;
    data['avgRating'] = this.avgRating;
    return data;
  }
}