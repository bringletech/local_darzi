class Tailor_Received_Payment_Response_Model {
  ReceivedPaymentData? data;
  String? message;
  bool? status;

  Tailor_Received_Payment_Response_Model({this.data, this.message, this.status});

  Tailor_Received_Payment_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ReceivedPaymentData.fromJson(json['data']) : null;
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

class ReceivedPaymentData {
  List<OrderPayment>? orderPayment;

  ReceivedPaymentData({this.orderPayment});

  ReceivedPaymentData.fromJson(Map<String, dynamic> json) {
    if (json['OrderPayment'] != null) {
      orderPayment = <OrderPayment>[];
      json['OrderPayment'].forEach((v) {
        orderPayment!.add(new OrderPayment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderPayment != null) {
      data['OrderPayment'] = this.orderPayment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderPayment {
  String? amount;
  String? paymentDate;
  String? orderStatus;

  OrderPayment({this.amount, this.paymentDate, this.orderStatus});

  OrderPayment.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    paymentDate = json['paymentDate'];
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['paymentDate'] = this.paymentDate;
    data['orderStatus'] = this.orderStatus;
    return data;
  }
}