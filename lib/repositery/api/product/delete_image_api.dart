import 'dart:convert';
import 'package:http/http.dart';

import '../api_client.dart';
import '../../model/product/delete_image_model.dart';

class DeleteImageApi {
  ApiClient apiClient = ApiClient();

  Future<DeleteImageModel> deleteImage({
    required String productId,
    required String imageUrl, // Include if you need to tell the server WHICH image to delete
  }) async {
    final String path = '/product/delete-image/$productId';

    final Map<String, dynamic> body = {
      'imageUrl': imageUrl,
    };

    Response response = await apiClient.invokeAPI(path, 'DELETE', body);

    return DeleteImageModel.fromJson(json.decode(response.body));
  }
}