class Get_Current_Customer_Response_Model {
  Data? data;
  String? message;
  bool? status;

  Get_Current_Customer_Response_Model({this.data, this.message, this.status});

  Get_Current_Customer_Response_Model.fromJson(Map<String, dynamic> json) {
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
  Null? otp;
  bool? isOtpVerified;
  String? deviceFcmToken;
  String? createdAt;
  String? updatedAt;
  List<CustomerOrder>? order;
  List<CustomerFavorite>? favorite;

  Data(
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
        this.otp,
        this.isOtpVerified,
        this.deviceFcmToken,
        this.createdAt,
        this.updatedAt,
        this.order,
        this.favorite});

  Data.fromJson(Map<String, dynamic> json) {
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
    otp = json['otp'];
    isOtpVerified = json['isOtpVerified'];
    deviceFcmToken = json['device_fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['Order'] != null) {
      order = <CustomerOrder>[];
      json['Order'].forEach((v) {
        order!.add(new CustomerOrder.fromJson(v));
      });
    }
    if (json['Favorite'] != null) {
      favorite = <CustomerFavorite>[];
      json['Favorite'].forEach((v) {
        favorite!.add(new CustomerFavorite.fromJson(v));
      });
    }
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
    data['otp'] = this.otp;
    data['isOtpVerified'] = this.isOtpVerified;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.order != null) {
      data['Order'] = this.order!.map((v) => v.toJson()).toList();
    }
    if (this.favorite != null) {
      data['Favorite'] = this.favorite!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerOrder {
  String? id;
  String? mobileNo;
  String? name;
  String? dressImgUrl;
  String? dressName;
  String? dueDate;
  String? measurementUnit;
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
  int? stitchingCost;
  int? advanceReceived;
  int? outstandingBalance;
  String? notes;
  bool? isPaymentDone;
  String? status;
  String? cancelledReason;
  String? createdAt;
  String? updatedAt;
  String? customerId;
  String? tailorId;
  Tailor? tailor;

  CustomerOrder(
      {this.id,
        this.mobileNo,
        this.name,
        this.dressImgUrl,
        this.dressName,
        this.dueDate,
        this.measurementUnit,
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
        this.stitchingCost,
        this.advanceReceived,
        this.outstandingBalance,
        this.notes,
        this.isPaymentDone,
        this.status,
        this.cancelledReason,
        this.createdAt,
        this.updatedAt,
        this.customerId,
        this.tailorId,
        this.tailor});

  CustomerOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    dressImgUrl = json['dressImgUrl'];
    dressName = json['dressName'];
    dueDate = json['dueDate'];
    measurementUnit = json['measurementUnit'];
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
    stitchingCost = json['stitchingCost'];
    advanceReceived = json['advanceReceived'];
    outstandingBalance = json['outstandingBalance'];
    notes = json['notes'];
    isPaymentDone = json['isPaymentDone'];
    status = json['status'];
    cancelledReason = json['cancelledReason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    customerId = json['customerId'];
    tailorId = json['tailorId'];
    tailor =
    json['tailor'] != null ? new Tailor.fromJson(json['tailor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['dressImgUrl'] = this.dressImgUrl;
    data['dressName'] = this.dressName;
    data['dueDate'] = this.dueDate;
    data['measurementUnit'] = this.measurementUnit;
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
    data['stitchingCost'] = this.stitchingCost;
    data['advanceReceived'] = this.advanceReceived;
    data['outstandingBalance'] = this.outstandingBalance;
    data['notes'] = this.notes;
    data['isPaymentDone'] = this.isPaymentDone;
    data['status'] = this.status;
    data['cancelledReason'] = this.cancelledReason;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['customerId'] = this.customerId;
    data['tailorId'] = this.tailorId;
    if (this.tailor != null) {
      data['tailor'] = this.tailor!.toJson();
    }
    return data;
  }
}

class Tailor {
  String? id;
  String? mobileNo;
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
  Null? otp;
  bool? isOtpVerified;
  String? deviceFcmToken;
  String? createdAt;
  String? updatedAt;

  Tailor(
      {this.id,
        this.mobileNo,
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
        this.createdAt,
        this.updatedAt});

  Tailor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CustomerFavorite {
  String? id;
  String? customerId;
  String? tailorId;
  String? createdAt;
  String? updatedAt;

  CustomerFavorite(
      {this.id,
        this.customerId,
        this.tailorId,
        this.createdAt,
        this.updatedAt});

  CustomerFavorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    tailorId = json['tailorId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['tailorId'] = this.tailorId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}