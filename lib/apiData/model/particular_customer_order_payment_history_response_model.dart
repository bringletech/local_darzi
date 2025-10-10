class Particular_Customer_Order_Payment_History_Response_Model {
  Specific_Order_Payment_History_Data? data;
  String? message;
  bool? status;

  Particular_Customer_Order_Payment_History_Response_Model(
      {this.data, this.message, this.status});

  Particular_Customer_Order_Payment_History_Response_Model.fromJson(
      Map<String, dynamic> json) {
    data = json['data'] != null ? new Specific_Order_Payment_History_Data.fromJson(json['data']) : null;
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

class Specific_Order_Payment_History_Data {
  String? dressName;
  String? dressImgUrl;
  int? advanceReceived;
  int? stitchingCost;
  int? outstandingBalance;
  List<PaymentHistory>? paymentHistory;
  int? totalAmount;

  Specific_Order_Payment_History_Data(
      {this.dressName,
        this.dressImgUrl,
        this.advanceReceived,
        this.stitchingCost,
        this.outstandingBalance,
        this.paymentHistory,
        this.totalAmount});

  Specific_Order_Payment_History_Data.fromJson(Map<String, dynamic> json) {
    dressName = json['dressName'];
    dressImgUrl = json['dressImgUrl'];
    advanceReceived = json['advanceReceived'];
    stitchingCost = json['stitchingCost'];
    outstandingBalance = json['outstandingBalance'];
    if (json['paymentHistory'] != null) {
      paymentHistory = <PaymentHistory>[];
      json['paymentHistory'].forEach((v) {
        paymentHistory!.add(new PaymentHistory.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dressName'] = this.dressName;
    data['dressImgUrl'] = this.dressImgUrl;
    data['advanceReceived'] = this.advanceReceived;
    data['stitchingCost'] = this.stitchingCost;
    data['outstandingBalance'] = this.outstandingBalance;
    if (this.paymentHistory != null) {
      data['paymentHistory'] =
          this.paymentHistory!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class PaymentHistory {
  String? date;
  int? amount;

  PaymentHistory({this.date, this.amount});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['amount'] = this.amount;
    return data;
  }
}