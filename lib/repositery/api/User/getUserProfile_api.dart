import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/user/getUserProfile.dart';

class GetUserProfileApi {
  final ApiClient apiClient = ApiClient();

  Future<GetUserProfile> getGetUserProfile() async {
    const String endpoint = '/user/profile';

    try {
      // GET request — no body needed
      Response response = await apiClient.invokeAPI(endpoint, 'GET', null);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return GetUserProfile.fromJson(jsonMap);
      } else {
        throw Exception(
            'Failed to load user profile (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ GetUserProfile API Error: $e');
      rethrow;
    }
  }
}
