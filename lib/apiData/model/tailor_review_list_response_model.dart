class Get_Customer_Tailor_Reviews_Response_Model {
  List<ReviewListData>? data;
  String? message;
  bool? status;

  Get_Customer_Tailor_Reviews_Response_Model({this.data, this.message, this.status});

  Get_Customer_Tailor_Reviews_Response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReviewListData>[];
      json['data'].forEach((v) {
        data!.add(new ReviewListData.fromJson(v));
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

class ReviewListData {
  String? review;
  int? rating;
  List<String>? images;
  Customer? customer;
  String? reviewTime;

  ReviewListData({this.review, this.rating, this.images, this.customer, this.reviewTime});

  ReviewListData.fromJson(Map<String, dynamic> json) {
    review = json['review'];
    rating = json['rating'];
    images = json['images'].cast<String>();
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    reviewTime = json['reviewTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['images'] = this.images;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['reviewTime'] = this.reviewTime;
    return data;
  }
}

class Customer {
  String? name;
  String? mobileNo;
  String? profileUrl;

  Customer({this.name, this.mobileNo, this.profileUrl});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobileNo'];
    profileUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['profileUrl'] = this.profileUrl;
    return data;
  }
}