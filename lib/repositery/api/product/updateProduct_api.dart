import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../api_client.dart';
import '../../model/product/updateProduct_model.dart';

class UpdateProductApi {
  ApiClient apiClient = ApiClient();

  Future<UpdateProductModel> updateProduct({
    required String productId,
    required String productName,
    required String categoryId,
    required String productDescription,
    required String price,
    required String discountPercentage,
    required String unit,
    File? imageFile, // Image is optional for updates
  }) async {
    final String path = '/product/update/$productId';

    final Map<String, String> body = {
      'name': productName,
      'basePrice': price,
      'discountPercentage': discountPercentage,
      'unit': unit,
      'description': productDescription,
      'categoryId': categoryId,
    };

    // Use a map for optional files
    final Map<String, File> files = {};
    if (imageFile != null) {
      files['images'] = imageFile;
    }

    Response response = await apiClient.invokeAPI(path, 'PUT', body, files: files.isNotEmpty ? files : null);

    return UpdateProductModel.fromJson(json.decode(response.body));
  }
}