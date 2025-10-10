class Customer_Update_Response_Model {
  Customer_Update_Data? data;
  String? message;
  bool? status;

  Customer_Update_Response_Model({this.data, this.message, this.status});

  Customer_Update_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Customer_Update_Data.fromJson(json['data']) : null;
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

class Customer_Update_Data {
  String? id;
  String? mobileNo;
  String? name;
  String? address;
  String? profileUrl;
  String? neck;
  String? bust;
  String? underBust;
  String? waist;
  String? hips;
  String? neckToAboveKnee;
  String? armLength;
  String? shoulderSeam;
  String? armHole;
  String? bicep;
  String? foreArm;
  String? wrist;
  String? shoulderToWaist;
  String? bottomLength;
  String? ankle;
  String? measurementUnit;
  String? measurementnotes;
  bool? isActive;
  bool? isDeleted;
  String? otp;
  bool? isOtpVerified;
  String? deviceFcmToken;
  String? createdAt;
  String? updatedAt;

  Customer_Update_Data(
      {this.id,
        this.mobileNo,
        this.name,
        this.address,
        this.profileUrl,
        this.neck,
        this.bust,
        this.underBust,
        this.waist,
        this.hips,
        this.neckToAboveKnee,
        this.armLength,
        this.shoulderSeam,
        this.armHole,
        this.bicep,
        this.foreArm,
        this.wrist,
        this.shoulderToWaist,
        this.bottomLength,
        this.ankle,
        this.measurementUnit,
        this.measurementnotes,
        this.isActive,
        this.isDeleted,
        this.otp,
        this.isOtpVerified,
        this.deviceFcmToken,
        this.createdAt,
        this.updatedAt,
       });

  Customer_Update_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    address = json['address'];
    profileUrl = json['profileUrl'];
    neck = json['neck'];
    bust = json['Bust'];
    underBust = json['underBust'];
    waist = json['waist'];
    hips = json['hips'];
    neckToAboveKnee = json['neckToAboveKnee'];
    armLength = json['armLength'];
    shoulderSeam = json['shoulderSeam'];
    armHole = json['armHole'];
    bicep = json['bicep'];
    foreArm = json['foreArm'];
    wrist = json['wrist'];
    shoulderToWaist = json['shoulderToWaist'];
    bottomLength = json['bottomLength'];
    ankle = json['ankle'];
    measurementUnit = json['measurementUnit'];
    measurementnotes = json['measurementnotes'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    otp = json['otp'];
    isOtpVerified = json['isOtpVerified'];
    deviceFcmToken = json['device_fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['address'] = this.address;
    data['profileUrl'] = this.profileUrl;
    data['neck'] = this.neck;
    data['Bust'] = this.bust;
    data['underBust'] = this.underBust;
    data['waist'] = this.waist;
    data['hips'] = this.hips;
    data['neckToAboveKnee'] = this.neckToAboveKnee;
    data['armLength'] = this.armLength;
    data['shoulderSeam'] = this.shoulderSeam;
    data['armHole'] = this.armHole;
    data['bicep'] = this.bicep;
    data['foreArm'] = this.foreArm;
    data['wrist'] = this.wrist;
    data['shoulderToWaist'] = this.shoulderToWaist;
    data['bottomLength'] = this.bottomLength;
    data['ankle'] = this.ankle;
    data['measurementUnit'] = this.measurementUnit;
    data['measurementnotes'] = this.measurementnotes;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['otp'] = this.otp;
    data['isOtpVerified'] = this.isOtpVerified;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}