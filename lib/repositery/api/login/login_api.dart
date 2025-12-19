import 'dart:convert';

import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginapi {
  final ApiClient apiclient = ApiClient();
  final String loginPath = '/auth/login';

  Future<Loginmodel> getLogin({
    required String phoneNumber,
  }) async {
    try {
      final body = {
        "phoneNumber": phoneNumber.trim(),
        "otp": "573201",
      };

      print(' Sending OTP request...');
      print(' Phone: "$phoneNumber"');
      print(' Body: $body');

      final response = await apiclient.invokeAPI(
        loginPath,
        'POST',
        body,
      );

      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final Loginmodel loginmodel = Loginmodel.fromJson(jsonMap);

      print('OTP sent successfully');
      return loginmodel;
    } catch (e) {
      print(' Error in Send OTP API: $e');
      throw Exception("Failed to send OTP: $e");
    }
  }

  Future<Loginmodel> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final body = {
        "phoneNumber": phoneNumber.trim(),
        "otp": otp.trim(),
      };

      print(' Verifying OTP...');
      print(' Phone: "$phoneNumber"');
      print(' OTP: "$otp"');
      print(' Body: $body');

      final response = await apiclient.invokeAPI(
        loginPath,
        'POST',
        body,
      );

      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final Loginmodel loginmodel = Loginmodel.fromJson(jsonMap);

      // Nullable fields from model
      final String? token = loginmodel.accessToken;
      final user = loginmodel.user; // User? (from your model)

      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        // ✅ Save token
        await prefs.setString("token", token);

        if (user != null) {
          // ✅ Phone number (nullable)
          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
            await prefs.setString("phone", user.phoneNumber!);
          }

          // ✅ User ID (nullable)
          if (user.id != null && user.id!.isNotEmpty) {
            await prefs.setString("userId", user.id!);
          }

          // ✅ Role (nullable)
          final String? userRole = user.role;
          if (userRole != null && userRole.isNotEmpty) {
            await prefs.setString('role', userRole);
          }

          // Even if role is null, isAdmin handling is safe
          final bool isAdmin = (user.role ?? '').toLowerCase() == 'admin';
          await prefs.setBool('isAdmin', isAdmin);

          // ✅ Name (nullable)
          if (user.name != null && user.name!.isNotEmpty) {
            await prefs.setString('userName', user.name!);
          }

          print('User role: ${user.role}');
          print('Is Admin: $isAdmin');
          print('userId: ${user.id}');
        } else {
          print(' User object is null in login response.');
        }

        print('Token saved successfully: $token');

        // Debug: read back values
        print('VERIFICATION');
        print('Stored Token: ${prefs.getString("token")}');
        print('Stored Role: ${prefs.getString("role")}');
        print('Stored IsAdmin: ${prefs.getBool("isAdmin")}');
      } else {
        print(' No token received in response.');
      }

      print(' OTP verified successfully');
      return loginmodel;
    } catch (e) {
      print(' Error in Verify OTP API: $e');
      throw Exception("Failed to verify OTP: $e");
    }
  }
}
