class DeleteImageModel {
  bool? success;
  String? message;

  DeleteImageModel({this.success, this.message});

  DeleteImageModel.fromJson(Map<String, dynamic> json) {
    if (json["success"] is bool) {
      success = json["success"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
  }
}