import 'dart:convert';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/send_otp_model.dart';

class SendOtpApi {
  final ApiClient apiClient = ApiClient();

  Future<SendOtpModel> sendOtp(String phoneNumber) async {
    final body = {
      "phoneNumber": phoneNumber,
    };

    final response = await apiClient.invokeAPI('auth/send-otp', 'POST', body);

    return SendOtpModel.fromJson(jsonDecode(response.body));
  }
}
