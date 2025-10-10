class Re_Open_Cancelled_Order_Response_Model {
  Re_Order_Dress_Data? data;
  String? message;
  bool? status;

  Re_Open_Cancelled_Order_Response_Model({this.data, this.message, this.status});

  Re_Open_Cancelled_Order_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Re_Order_Dress_Data.fromJson(json['data']) : null;
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

class Re_Order_Dress_Data {
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
  String? createdAt;
  String? updatedAt;
  String? customerId;
  String? tailorId;

  Re_Order_Dress_Data(
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
        this.createdAt,
        this.updatedAt,
        this.customerId,
        this.tailorId});

  Re_Order_Dress_Data.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    customerId = json['customerId'];
    tailorId = json['tailorId'];
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['customerId'] = this.customerId;
    data['tailorId'] = this.tailorId;
    return data;
  }
}