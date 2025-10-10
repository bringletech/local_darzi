class Tailor_Outstanding_Balance_Response_Model {
  OutstandingBalanceData? data;
  String? message;
  bool? status;

  Tailor_Outstanding_Balance_Response_Model({this.data, this.message, this.status});

  Tailor_Outstanding_Balance_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OutstandingBalanceData.fromJson(json['data']) : null;
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

class OutstandingBalanceData {
  List<Customers>? customers;
  Pagination? pagination;

  OutstandingBalanceData({this.customers, this.pagination});

  OutstandingBalanceData.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(new Customers.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Customers {
  String? id;
  String? mobileNo;
  String? customerName;
  int? totalOutstandingBalance;
  String? profileUrl;
  List<CompletedOrders>? completedOrders;

  Customers(
      {this.id,
        this.mobileNo,
        this.customerName,
        this.totalOutstandingBalance,
        this.profileUrl,
        this.completedOrders});

  Customers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    customerName = json['customerName'];
    totalOutstandingBalance = json['totalOutstandingBalance'];
    profileUrl = json['profileUrl'];
    if (json['completedOrders'] != null) {
      completedOrders = <CompletedOrders>[];
      json['completedOrders'].forEach((v) {
        completedOrders!.add(new CompletedOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['customerName'] = this.customerName;
    data['totalOutstandingBalance'] = this.totalOutstandingBalance;
    data['profileUrl'] = this.profileUrl;
    if (this.completedOrders != null) {
      data['completedOrders'] =
          this.completedOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompletedOrders {
  String? id;
  String? dressName;
  int? stitchingCost;
  int? advanceReceived;
  int? outstandingBalance;
  String? dueDate;
  String? status;

  CompletedOrders(
      {this.id,
        this.dressName,
        this.stitchingCost,
        this.advanceReceived,
        this.outstandingBalance,
        this.dueDate,
        this.status});

  CompletedOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dressName = json['dressName'];
    stitchingCost = json['stitchingCost'];
    advanceReceived = json['advanceReceived'];
    outstandingBalance = json['outstandingBalance'];
    dueDate = json['dueDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dressName'] = this.dressName;
    data['stitchingCost'] = this.stitchingCost;
    data['advanceReceived'] = this.advanceReceived;
    data['outstandingBalance'] = this.outstandingBalance;
    data['dueDate'] = this.dueDate;
    data['status'] = this.status;
    return data;
  }
}

class Pagination {
  int? totalCount;
  int? totalPages;
  int? currentPage;
  int? limit;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination(
      {this.totalCount,
        this.totalPages,
        this.currentPage,
        this.limit,
        this.hasNextPage,
        this.hasPrevPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    limit = json['limit'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    data['limit'] = this.limit;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    return data;
  }
}
