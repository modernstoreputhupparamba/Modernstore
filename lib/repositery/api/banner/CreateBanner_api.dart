import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Banner/CreateBanner_model.dart';

class CreatebannerApi {
  final ApiClient apiClient = ApiClient();

  Future<CreateBannerModel> uploadBanner({
    required String title,
    required String category,
    required String type,
    required String categoryId,
    required String link,
    required File imageFile,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    const String path = '/banner/create';

    final Map<String, String> body = {
      'title': title,
      'category': category,
      'type': type,
      'categoryId': categoryId,
      'link': link,
    
    };

    print('Banner Upload Body: $body');

    final Map<String, File> files = {
      'images': imageFile,
    };

    try {
      Response response = await apiClient.invokeAPI(
        path,
        'POST_MULTIPART',
        body,
        files: files,
      );
      print('Banner Upload Response: ${response.statusCode} ${response.body}');
      final jsonData = json.decode(response.body);
      return CreateBannerModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to upload banner: $e');
    }
  }
}
