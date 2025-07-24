class Customer_Add_To_Favourite_Response_Model {
  String? message;
  bool? status;

  Customer_Add_To_Favourite_Response_Model({this.message, this.status});

  Customer_Add_To_Favourite_Response_Model.fromJson(Map<String, dynamic> json) {
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