class Tailor_Review_Response_Model {
  String? message;
  Tailor_Review_Data? data;
  bool? status;

  Tailor_Review_Response_Model({this.message, this.data, this.status});

  Tailor_Review_Response_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Tailor_Review_Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Tailor_Review_Data {
  String? id;
  List<String>? images;
  int? rating;
  String? review;
  String? tailorId;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  String? orderId;
  int? imageCount;

  Tailor_Review_Data(
      {this.id,
        this.images,
        this.rating,
        this.review,
        this.tailorId,
        this.customerId,
        this.createdAt,
        this.updatedAt,
        this.orderId,
        this.imageCount});

  Tailor_Review_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    images = json['images'].cast<String>();
    rating = json['rating'];
    review = json['review'];
    tailorId = json['tailorId'];
    customerId = json['customerId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderId = json['orderId'];
    imageCount = json['imageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['tailorId'] = this.tailorId;
    data['customerId'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['orderId'] = this.orderId;
    data['imageCount'] = this.imageCount;
    return data;
  }
}