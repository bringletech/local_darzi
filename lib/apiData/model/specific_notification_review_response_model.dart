class Specific_Notification_Review_Response_Model {
  String? message;
  Specific_Tailor_Review_Data? data;

  Specific_Notification_Review_Response_Model({this.message, this.data});

  Specific_Notification_Review_Response_Model.fromJson(
      Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Specific_Tailor_Review_Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Specific_Tailor_Review_Data {
  ReviewCategories? reviewCategories;
  List<AllReviews>? allReviews;
  Tailoraccount? tailoraccount;

  Specific_Tailor_Review_Data({this.reviewCategories, this.allReviews, this.tailoraccount});

  Specific_Tailor_Review_Data.fromJson(Map<String, dynamic> json) {
    reviewCategories = json['reviewCategories'] != null
        ? new ReviewCategories.fromJson(json['reviewCategories'])
        : null;
    if (json['allReviews'] != null) {
      allReviews = <AllReviews>[];
      json['allReviews'].forEach((v) {
        allReviews!.add(new AllReviews.fromJson(v));
      });
    }
    tailoraccount = json['tailoraccount'] != null
        ? new Tailoraccount.fromJson(json['tailoraccount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviewCategories != null) {
      data['reviewCategories'] = this.reviewCategories!.toJson();
    }
    if (this.allReviews != null) {
      data['allReviews'] = this.allReviews!.map((v) => v.toJson()).toList();
    }
    if (this.tailoraccount != null) {
      data['tailoraccount'] = this.tailoraccount!.toJson();
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
  int? avgRating;

  ReviewCategories(
      {this.excellent,
        this.good,
        this.average,
        this.belowAverage,
        this.poor,
        this.avgRating});

  ReviewCategories.fromJson(Map<String, dynamic> json) {
    excellent = json['excellent'];
    good = json['good'];
    average = json['average'];
    belowAverage = json['belowAverage'];
    poor = json['poor'];
    avgRating = json['avgRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excellent'] = this.excellent;
    data['good'] = this.good;
    data['average'] = this.average;
    data['belowAverage'] = this.belowAverage;
    data['poor'] = this.poor;
    data['avgRating'] = this.avgRating;
    return data;
  }
}

class AllReviews {
  String? review;
  int? rating;
  List<String>? images;
  String? customerName;
  String? customerProfileUrl;
  String? reviewTime;

  AllReviews(
      {this.review,
        this.rating,
        this.images,
        this.customerName,
        this.customerProfileUrl,
        this.reviewTime
      });

  AllReviews.fromJson(Map<String, dynamic> json) {
    review = json['review'];
    rating = json['rating'];
    images = json['images'].cast<String>();
    customerName = json['customerName'];
    customerProfileUrl = json['customerProfileUrl'];
    reviewTime = json['reviewTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['images'] = this.images;
    data['customerName'] = this.customerName;
    data['customerProfileUrl'] = this.customerProfileUrl;
    data['reviewTime'] = this.reviewTime;
    return data;
  }
}

class Tailoraccount {
  String? profileUrl;
  String? name;

  Tailoraccount({this.profileUrl, this.name});

  Tailoraccount.fromJson(Map<String, dynamic> json) {
    profileUrl = json['profileUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileUrl'] = this.profileUrl;
    data['name'] = this.name;
    return data;
  }
}