class Order_Status_Change_Model {
  String? message;
  bool? status;

  Order_Status_Change_Model({this.message, this.status});

  Order_Status_Change_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}