import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../api_client.dart';

class CreateProductApi {
    ApiClient apiClient = ApiClient();

  Future<void> uploadProduct({
    required String productName,
    required String categoryId,
    required String productDescription,
    required String productDetails,
    required String price,
    required String discountPercentage,
    required String unit,
    required File imageFile,
  }) async {
   
        const String path = '/product/create';

    final Map<String, String> body = {
      'name': productName,
      'basePrice': price,
      'discountPercentage': discountPercentage,
      'unit': unit,
      'description': productDescription,
      'details': productDetails,
      'categoryId': categoryId,
    };

    Response response = await apiClient.invokeAPI(path, 'POST_MULTIPART', body, files: {'images': imageFile});

    final data = json.decode(response.body);

    // The ApiClient now handles non-2xx status codes, so we only check for success here.
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('🎉 Product Created: ${data['data'] ?? 'No data returned'}');
    } else {
      // This part is now mostly handled by ApiClient, but can be a fallback.
      throw Exception('❌ Failed to create product: ${data['message'] ?? 'Unknown error'}');
    }
  }
}
