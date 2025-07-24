class My_Tailor_Details_Respone_Model {
  TailorDetailsData? data;
  String? message;
  bool? status;

  My_Tailor_Details_Respone_Model({this.data, this.message, this.status});

  My_Tailor_Details_Respone_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new TailorDetailsData.fromJson(json['data']) : null;
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

class TailorDetailsData {
  String? id;
  String? mobileNo;
  String? name;
  String? profileUrl;
  double? latitude;
  double? longitude;
  int? totalReviews;
  int? avgRating;
  bool? isFavorite;
  bool? isReview;
  ReviewCategories? reviewCategories;

  TailorDetailsData(
      {this.id,
        this.mobileNo,
        this.name,
        this.profileUrl,
        this.latitude,
        this.longitude,
        this.totalReviews,
        this.avgRating,
        this.isFavorite,
        this.isReview,
        this.reviewCategories});

  TailorDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    profileUrl = json['profileUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    totalReviews = json['totalReviews'];
    avgRating = json['avgRating'];
    isFavorite = json['isFavorite'];
    isReview = json['isReview'];
    reviewCategories = json['reviewCategories'] != null
        ? new ReviewCategories.fromJson(json['reviewCategories'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['profileUrl'] = this.profileUrl;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['totalReviews'] = this.totalReviews;
    data['avgRating'] = this.avgRating;
    data['isFavorite'] = this.isFavorite;
    data['isReview'] = this.isReview;
    if (this.reviewCategories != null) {
      data['reviewCategories'] = this.reviewCategories!.toJson();
    }
    return data;
  }
}

class ReviewCategories {
  int? excellent;
  int? good;
  int? average;
  int? belowAverage;
  int? poor;

  ReviewCategories(
      {this.excellent, this.good, this.average, this.belowAverage, this.poor});

  ReviewCategories.fromJson(Map<String, dynamic> json) {
    excellent = json['excellent'];
    good = json['good'];
    average = json['average'];
    belowAverage = json['belowAverage'];
    poor = json['poor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excellent'] = this.excellent;
    data['good'] = this.good;
    data['average'] = this.average;
    data['belowAverage'] = this.belowAverage;
    data['poor'] = this.poor;
    return data;
  }
}