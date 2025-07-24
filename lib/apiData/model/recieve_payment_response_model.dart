class Receive_Payment_Response_Model {
  PaymentData? data;
  String? message;
  bool? status;

  Receive_Payment_Response_Model({this.data, this.message, this.status});

  Receive_Payment_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentData.fromJson(json['data']) : null;
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

class PaymentData {
  PaymentOrder? order;
  int? remainingBalance;
  bool? isPaymentDone;
  String? status;

  PaymentData({this.order, this.remainingBalance, this.isPaymentDone, this.status});

  PaymentData.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new PaymentOrder.fromJson(json['order']) : null;
    remainingBalance = json['remainingBalance'];
    isPaymentDone = json['isPaymentDone'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    data['remainingBalance'] = this.remainingBalance;
    data['isPaymentDone'] = this.isPaymentDone;
    data['status'] = this.status;
    return data;
  }
}

class PaymentOrder {
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
  List<OrderPayment>? orderPayment;
  Customer? customer;

  PaymentOrder(
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
        this.tailorId,
        this.orderPayment,
        this.customer});

  PaymentOrder.fromJson(Map<String, dynamic> json) {
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
    if (json['OrderPayment'] != null) {
      orderPayment = <OrderPayment>[];
      json['OrderPayment'].forEach((v) {
        orderPayment!.add(new OrderPayment.fromJson(v));
      });
    }
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['customerId'] = this.customerId;
    data['tailorId'] = this.tailorId;
    if (this.orderPayment != null) {
      data['OrderPayment'] = this.orderPayment!.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class OrderPayment {
  String? id;
  int? amount;
  String? orderStatus;
  String? orderId;
  String? paymentDate;
  String? createdAt;
  String? updatedAt;

  OrderPayment(
      {this.id,
        this.amount,
        this.orderStatus,
        this.orderId,
        this.paymentDate,
        this.createdAt,
        this.updatedAt});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    orderStatus = json['orderStatus'];
    orderId = json['orderId'];
    paymentDate = json['paymentDate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['orderStatus'] = this.orderStatus;
    data['orderId'] = this.orderId;
    data['paymentDate'] = this.paymentDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Customer {
  String? deviceFcmToken;

  Customer({this.deviceFcmToken});

  Customer.fromJson(Map<String, dynamic> json) {
    deviceFcmToken = json['device_fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_fcm_token'] = this.deviceFcmToken;
    return data;
  }
}