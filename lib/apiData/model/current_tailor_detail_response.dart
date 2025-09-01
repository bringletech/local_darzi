class Current_Tailor_Details_Response {
  Current_Tailor_Data? data;
  String? message;
  bool? status;

  Current_Tailor_Details_Response({this.data, this.message, this.status});

  Current_Tailor_Details_Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Current_Tailor_Data.fromJson(json['data']) : null;
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

class Current_Tailor_Data {
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
  String? deviceFcmToken;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? notificationEnabled;
  List<Customers>? customers;
  SpecificCustomerOrder? order;

  Current_Tailor_Data(
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
        this.deviceFcmToken,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.notificationEnabled,
        this.customers,
        this.order});

  Current_Tailor_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    hideMobileNo = json['hideMobileNo'];
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
    notificationEnabled = json['notificationEnabled'];
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(new Customers.fromJson(v));
      });
    }
    order = json['Order'] != null ? new SpecificCustomerOrder.fromJson(json['Order']) : null;
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
    data['device_fcm_token'] = this.deviceFcmToken;
    data['isDeleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['notificationEnabled'] = this.notificationEnabled;
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['Order'] = this.order!.toJson();
    }
    return data;
  }
}

class Customers {
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
  String? deviceFcmToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Customers(
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
        this.deviceFcmToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Customers.fromJson(Map<String, dynamic> json) {
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
    deviceFcmToken = json['device_fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['device_fcm_token'] = this.deviceFcmToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class SpecificCustomerOrder {
  List<Missed>? missed;
  List<Today>? today;
  List<ThisWeek>? thisWeek;
  List<NextWeek>? nextWeek;
  List<Later>? later;

  SpecificCustomerOrder({this.missed, this.today, this.thisWeek, this.nextWeek, this.later});

  SpecificCustomerOrder.fromJson(Map<String, dynamic> json) {
    if (json['missed'] != null) {
      missed = <Missed>[];
      json['missed'].forEach((v) {
        missed!.add(new Missed.fromJson(v));
      });
    }
    if (json['today'] != null) {
      today = <Today>[];
      json['today'].forEach((v) {
        today!.add(new Today.fromJson(v));
      });
    }
    if (json['this_week'] != null) {
      thisWeek = <ThisWeek>[];
      json['this_week'].forEach((v) {
        thisWeek!.add(new ThisWeek.fromJson(v));
      });
    }
    if (json['next_week'] != null) {
      nextWeek = <NextWeek>[];
      json['next_week'].forEach((v) {
        nextWeek!.add(new NextWeek.fromJson(v));
      });
    }
    if (json['later'] != null) {
      later = <Later>[];
      json['later'].forEach((v) {
        later!.add(new Later.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.missed != null) {
      data['missed'] = this.missed!.map((v) => v.toJson()).toList();
    }
    if (this.today != null) {
      data['today'] = this.today!.map((v) => v.toJson()).toList();
    }
    if (this.thisWeek != null) {
      data['this_week'] = this.thisWeek!.map((v) => v.toJson()).toList();
    }
    if (this.nextWeek != null) {
      data['next_week'] = this.nextWeek!.map((v) => v.toJson()).toList();
    }
    if (this.later != null) {
      data['later'] = this.later!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Missed {
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
  Customer? customer;

  Missed(
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
        this.customer});

  Missed.fromJson(Map<String, dynamic> json) {
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
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
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
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Today {
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
  Customer? customer;

  Today(
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
        this.customer});

  Today.fromJson(Map<String, dynamic> json) {
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
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
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
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? name;
  String? mobileNo;
  String? address;
  String? profileUrl;

  Customer({this.id, this.name, this.mobileNo, this.address, this.profileUrl});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    address = json['address'];
    profileUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['address'] = this.address;
    data['profileUrl'] = this.profileUrl;
    return data;
  }
}

class ThisWeek {
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
  Customer? customer;

  ThisWeek(
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
        this.customer});

  ThisWeek.fromJson(Map<String, dynamic> json) {
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
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
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
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class NextWeek {
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
  Customer? customer;

  NextWeek(
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
        this.customer});

  NextWeek.fromJson(Map<String, dynamic> json) {
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
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
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
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Later {
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
  Customer? customer;

  Later(
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
        this.customer});

  Later.fromJson(Map<String, dynamic> json) {
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
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
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
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}
