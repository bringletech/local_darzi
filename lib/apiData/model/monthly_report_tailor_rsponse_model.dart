class Monthly_Sales_Tailor_Response_Model {
  Mothly_Sales_Data? data;
  String? message;
  bool? status;

  Monthly_Sales_Tailor_Response_Model({this.data, this.message, this.status});

  Monthly_Sales_Tailor_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Mothly_Sales_Data.fromJson(json['data']) : null;
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

class Mothly_Sales_Data {
  Metrics? metrics;

  Mothly_Sales_Data({this.metrics});

  Mothly_Sales_Data.fromJson(Map<String, dynamic> json) {
    metrics =
    json['metrics'] != null ? new Metrics.fromJson(json['metrics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metrics != null) {
      data['metrics'] = this.metrics!.toJson();
    }
    return data;
  }
}

class Metrics {
  int? actualEarnings;
  int? totalEstimate;
  int? paymentsReceived;
  int? ordersReceived;
  int? ordersCancelled;
  int? newCustomers;
  int? allCustomers;

  Metrics(
      {this.actualEarnings,
        this.totalEstimate,
        this.paymentsReceived,
        this.ordersReceived,
        this.ordersCancelled,
        this.newCustomers,
        this.allCustomers});

  Metrics.fromJson(Map<String, dynamic> json) {
    actualEarnings = json['actualEarnings'];
    totalEstimate = json['totalEstimate'];
    paymentsReceived = json['paymentsReceived'];
    ordersReceived = json['ordersReceived'];
    ordersCancelled = json['ordersCancelled'];
    newCustomers = json['newCustomers'];
    allCustomers = json['allCustomers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actualEarnings'] = this.actualEarnings;
    data['totalEstimate'] = this.totalEstimate;
    data['paymentsReceived'] = this.paymentsReceived;
    data['ordersReceived'] = this.ordersReceived;
    data['ordersCancelled'] = this.ordersCancelled;
    data['newCustomers'] = this.newCustomers;
    data['allCustomers'] = this.allCustomers;
    return data;
  }
}