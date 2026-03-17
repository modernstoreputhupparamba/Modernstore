class DeleteProductModel {
  bool? success;
  String? message;

  DeleteProductModel({this.success, this.message});

  DeleteProductModel.fromJson(Map<String, dynamic> json) {
    if (json["success"] is bool) {
      success = json["success"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
  }
}