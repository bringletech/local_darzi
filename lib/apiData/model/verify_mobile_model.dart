class Mobile_Verify_Model {
  String? message;
  bool? status;

  Mobile_Verify_Model({this.message, this.status});

  Mobile_Verify_Model.fromJson(Map<String, dynamic> json) {
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
