class GetCancelled_Order_Response_Model {
  List<CancelledOrderData>? data;
  String? message;
  bool? status;

  GetCancelled_Order_Response_Model({this.data, this.message, this.status});

  GetCancelled_Order_Response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CancelledOrderData>[];
      json['data'].forEach((v) {
        data!.add(new CancelledOrderData.fromJson(v));
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

class CancelledOrderData {
  String? id;
  int? stitchingCost;
  String? dressImgUrl;
  Customer? customer;
  String? dueDate;
  String? status;

  CancelledOrderData(
      {this.id,
        this.stitchingCost,
        this.dressImgUrl,
        this.customer,
        this.dueDate,
        this.status});

  CancelledOrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stitchingCost = json['stitchingCost'];
    dressImgUrl = json['dressImgUrl'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    dueDate = json['dueDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stitchingCost'] = this.stitchingCost;
    data['dressImgUrl'] = this.dressImgUrl;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['dueDate'] = this.dueDate;
    data['status'] = this.status;
    return data;
  }
}

class Customer {
  String? name;

  Customer({this.name});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}