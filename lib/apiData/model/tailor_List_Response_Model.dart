class Tailor_List_Response_Model {
  List<Tailors>? data;
  Pagination? pagination;
  String? message;
  bool? status;

  Tailor_List_Response_Model(
      {this.data, this.pagination, this.message, this.status});

  Tailor_List_Response_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Tailors>[];
      json['data'].forEach((v) {
        data!.add(new Tailors.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Tailors {
  String? id;
  String? name;
  String? mobileNo;
  String? address;
  String? profileUrl;
  int? totalRatingBY;
  int? avgRating;

  Tailors(
      {this.id,
        this.name,
        this.mobileNo,
        this.address,
        this.profileUrl,
        this.totalRatingBY,
        this.avgRating});

  Tailors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    address = json['address'];
    profileUrl = json['profileUrl'];
    totalRatingBY = json['totalRatingBY'];
    avgRating = json['avgRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobileNo'] = this.mobileNo;
    data['address'] = this.address;
    data['profileUrl'] = this.profileUrl;
    data['totalRatingBY'] = this.totalRatingBY;
    data['avgRating'] = this.avgRating;
    return data;
  }
}

class Pagination {
  int? currentPage;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? totalPages;
  int? totalTailors;

  Pagination(
      {this.currentPage,
        this.hasNextPage,
        this.hasPreviousPage,
        this.totalPages,
        this.totalTailors});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
    totalPages = json['totalPages'];
    totalTailors = json['totalTailors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    data['totalPages'] = this.totalPages;
    data['totalTailors'] = this.totalTailors;
    return data;
  }
}