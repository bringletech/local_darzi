class GetPaymentDoneListResponseModel {
  List<PaymentDoneData>? data;
  String? message;
  bool? status;

  GetPaymentDoneListResponseModel({this.data, this.message, this.status});

  GetPaymentDoneListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentDoneData>[];
      json['data'].forEach((v) {
        data!.add(new PaymentDoneData.fromJson(v));
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

class PaymentDoneData {
  String? id;
  int? stitchingCost;
  String? dressImgUrl;
  String? customerName;
  String? dueDate;
  String? status;

  PaymentDoneData(
      {this.id,
        this.stitchingCost,
        this.dressImgUrl,
        this.customerName,
        this.dueDate,
        this.status});

  PaymentDoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stitchingCost = json['stitchingCost'];
    dressImgUrl = json['dressImgUrl'];
    customerName = json['customerName'];
    dueDate = json['dueDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stitchingCost'] = this.stitchingCost;
    data['dressImgUrl'] = this.dressImgUrl;
    data['customerName'] = this.customerName;
    data['dueDate'] = this.dueDate;
    data['status'] = this.status;
    return data;
  }
}