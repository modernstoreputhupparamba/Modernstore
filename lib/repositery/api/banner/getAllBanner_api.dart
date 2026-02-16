// get_all_banner_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/repositery/api/api_client.dart';

import '../../model/Banner/getAllBanner Model.dart';

class GetallbannerApi {
  final ApiClient apiClient = ApiClient();

  Future<GetAllBannerModel> getAllBanners() async {
    const String path = '/banner/get/all';

    try {
      // If your ApiClient automatically adds headers/token, this is enough:
      final http.Response response = await apiClient.invokeAPI(path, 'GET', {});

      // Debug logs (you already have similar ones)
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body) as Map<String, dynamic>;
        return GetAllBannerModel.fromJson(jsonData);
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API Error in GetallbannerApi: $e');
      throw Exception('Network error: $e');
    }
  }
}
