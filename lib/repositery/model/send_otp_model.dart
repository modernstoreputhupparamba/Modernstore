class SendOtpModel {
  final bool? success;
  final String? message;

  SendOtpModel({this.success, this.message});

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}