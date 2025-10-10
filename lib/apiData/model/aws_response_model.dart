class AwsResponseModel {
  String? presignedUrl;
  String? objectUrl;
  String? fileName;

  AwsResponseModel({this.presignedUrl, this.objectUrl, this.fileName});

  AwsResponseModel.fromJson(Map<String, dynamic> json) {
    presignedUrl = json['presignedUrl'];
    objectUrl = json['objectUrl'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['presignedUrl'] = this.presignedUrl;
    data['objectUrl'] = this.objectUrl;
    data['fileName'] = this.fileName;
    return data;
  }
}