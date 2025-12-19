class UpdateCartResponse {
  final bool success;
  final String message;
  final dynamic data;

  UpdateCartResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdateCartResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}