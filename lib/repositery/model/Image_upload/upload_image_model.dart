class UploadImageModel {
  bool? success;
  String? message;
  UploadData? data; // Renamed for clarity

  UploadImageModel({this.success, this.message, this.data});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    data = json["data"] != null ? UploadData.fromJson(json["data"]) : null;
  }
}

class UploadData {
  String? filename;
  String? path;
  String? url; // This is the key field
  String? mimetype;
  int? size;

  UploadData({this.filename, this.path, this.url, this.mimetype, this.size});

  UploadData.fromJson(Map<String, dynamic> json) {
    filename = json["filename"];
    path = json["path"];
    url = json["url"]; // Mapping the URL from JSON
    mimetype = json["mimetype"];
    size = json["size"];
  }
}