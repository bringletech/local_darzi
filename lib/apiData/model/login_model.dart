class LoginResponseModel {
  String? message;
  int? otp;
  bool? status;

  LoginResponseModel({this.message, this.otp, this.status});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    otp = json['otp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['otp'] = this.otp;
    data['status'] = this.status;
    return data;
  }
}