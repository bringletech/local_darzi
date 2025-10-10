class NotificationResponseModel {
  String? message;
  List<NotificationData>? data;

  NotificationResponseModel({this.message, this.data});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  String? title;
  String? message;
  String? time;
  bool? isViewed;

  NotificationData(
      {this.id, this.title, this.message, this.time, this.isViewed});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    time = json['time'];
    isViewed = json['isViewed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['time'] = this.time;
    data['isViewed'] = this.isViewed;
    return data;
  }
}
