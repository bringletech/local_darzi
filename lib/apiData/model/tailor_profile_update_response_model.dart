class Tailor_Profile_Update_Response_Model {
  Tailor_Update_Data? data;
  String? message;
  bool? status;

  Tailor_Profile_Update_Response_Model({this.data, this.message, this.status});

  Tailor_Profile_Update_Response_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Tailor_Update_Data.fromJson(json['data']) : null;
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

class Tailor_Update_Data {
  String? name;
  String? mobileNo;
  String? profileUrl;
  String? street;
  String? city;
  String? state;
  String? address;
  double? latitude;
  double? longitude;
  String? country;
  String? postalCode;

  Tailor_Update_Data(
      {this.name,
        this.mobileNo,
        this.profileUrl,
        this.street,
        this.city,
        this.state,
        this.address,
        this.latitude,
        this.longitude,
        this.country,
        this.postalCode});

  Tailor_Update_Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobileNo'];
    profileUrl = json['profileUrl'];
    street = json['Street'];
    city = json['City'];
    state = json['State'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    country = json['Country'];
    postalCode = json['PostalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['profileUrl'] = this.profileUrl;
    data['Street'] = this.street;
    data['City'] = this.city;
    data['State'] = this.state;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['Country'] = this.country;
    data['PostalCode'] = this.postalCode;
    return data;
  }
}