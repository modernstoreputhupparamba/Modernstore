import 'dart:convert';

import 'package:http/http.dart';

import '../api_client.dart';

class AddInventoryApi {
  ApiClient apiClient = ApiClient();

  Future<void> addInventory({
    required String productId,
    required int quantity,
  }) async {
    const String path = '/inventory/addStocks';

    final Map<String, dynamic> body = {
      'productId': productId,
      'stockQnt': quantity,
    };

    Response response = await apiClient.invokeAPI(path, 'POST', body);

    if (response.statusCode >= 400) {
      throw Exception('Failed to add stock: ${response.body}');
    }
  }
}