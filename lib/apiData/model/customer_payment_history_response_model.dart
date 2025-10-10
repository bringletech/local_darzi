class Customer_Payment_History_Response_Model {
  List<Customer_Payment_History_Data>? data;
  String? message;
  bool? status;
  Pagination? pagination;

  Customer_Payment_History_Response_Model(
      {this.data, this.message, this.status, this.pagination});

  Customer_Payment_History_Response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Customer_Payment_History_Data>[];
      json['data'].forEach((v) {
        data!.add(new Customer_Payment_History_Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Customer_Payment_History_Data {
  String? orderId;
  String? dressName;
  int? stitchingCost;
  int? advanceReceived;
  int? outstandingBalance;
  int? receivePaymentCount;
  String? orderDate;

  Customer_Payment_History_Data(
      {this.orderId,
        this.dressName,
        this.stitchingCost,
        this.advanceReceived,
        this.outstandingBalance,
        this.receivePaymentCount,
        this.orderDate});

  Customer_Payment_History_Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    dressName = json['dressName'];
    stitchingCost = json['stitchingCost'];
    advanceReceived = json['advanceReceived'];
    outstandingBalance = json['outstandingBalance'];
    receivePaymentCount = json['receivePaymentCount'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['dressName'] = this.dressName;
    data['stitchingCost'] = this.stitchingCost;
    data['advanceReceived'] = this.advanceReceived;
    data['outstandingBalance'] = this.outstandingBalance;
    data['receivePaymentCount'] = this.receivePaymentCount;
    data['orderDate'] = this.orderDate;
    return data;
  }
}

class Pagination {
  int? totalCount;
  int? totalPages;
  int? currentPage;
  int? limit;
  bool? hasNext;
  bool? hasPrev;

  Pagination(
      {this.totalCount,
        this.totalPages,
        this.currentPage,
        this.limit,
        this.hasNext,
        this.hasPrev});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    limit = json['limit'];
    hasNext = json['hasNext'];
    hasPrev = json['hasPrev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    data['limit'] = this.limit;
    data['hasNext'] = this.hasNext;
    data['hasPrev'] = this.hasPrev;
    return data;
  }
}