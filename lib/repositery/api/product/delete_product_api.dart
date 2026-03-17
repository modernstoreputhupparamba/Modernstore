import 'dart:convert';
import 'package:http/http.dart';

import '../api_client.dart';
import '../../model/product/delete_product_model.dart';

class DeleteProductApi {
  ApiClient apiClient = ApiClient();

  Future<DeleteProductModel> deleteProduct({
    required String productId,
  }) async {
    final String path = '/product/delete/$productId';

    // No body needed for a standard DELETE by ID
    Response response = await apiClient.invokeAPI(path, 'DELETE', null);

    return DeleteProductModel.fromJson(json.decode(response.body));
  }
}