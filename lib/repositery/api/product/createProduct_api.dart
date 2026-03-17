import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../api_client.dart';

class CreateProductApi {
    ApiClient apiClient = ApiClient();

 Future<void> uploadProduct({
  required String productName,
  required String productSubName,
  required String categoryId,
  required String productDescription,
  required String productDetails,
  required String price,
  required String discountPercentage,
  required String unit,
  required File imageFile,
  required List<String> selectableQuantities,
}) async {

  const String path = '/product/create';

  final Map<String, String> body = {
    'name': productName,
    'subName': productSubName,
    'basePrice': price,
    'discountPercentage': discountPercentage,
    'unit': unit,
    'description': productDescription,
    'details': productDetails,
    'categoryId': categoryId,
  };

  // Add quantities
  for (int i = 0; i < selectableQuantities.length; i++) {
    body['selectableQuantities[$i]'] = selectableQuantities[i];
  }

  try {
    Response response = await apiClient.invokeAPI(
      path,
      'POST_MULTIPART',
      body,
      files: {'images': imageFile},
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('🎉 Product Created');
    } else {
      throw Exception(data['message']);
    }
  } on ClientException catch (e) {
    throw Exception('Network Error: ${e.message}');
  }
}
}
