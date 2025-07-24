class Customer_Favourites_Response_Model {
  List<Customer_Favourite_Data>? data;
  String? message;
  bool? status;

  Customer_Favourites_Response_Model({this.data, this.message, this.status});

  Customer_Favourites_Response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Customer_Favourite_Data>[];
      json['data'].forEach((v) {
        data!.add(new Customer_Favourite_Data.fromJson(v));
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

class Customer_Favourite_Data {
  Favourite_Tailor? tailor;

  Customer_Favourite_Data({this.tailor});

  Customer_Favourite_Data.fromJson(Map<String, dynamic> json) {
    tailor =
    json['tailor'] != null ? new Favourite_Tailor.fromJson(json['tailor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tailor != null) {
      data['tailor'] = this.tailor!.toJson();
    }
    return data;
  }
}

class Favourite_Tailor {
  String? id;
  String? profileUrl;
  String? name;
  String? address;

  Favourite_Tailor({this.id,this.profileUrl, this.name, this.address});

  Favourite_Tailor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileUrl = json['profileUrl'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profileUrl'] = this.profileUrl;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}