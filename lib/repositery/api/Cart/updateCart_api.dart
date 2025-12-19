import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/repositery/api/api_client.dart';

import '../../model/Cart/updateCart_model.dart';

class UpdateCartApi {
  final ApiClient apiClient;

  UpdateCartApi({required this.apiClient});

  Future<UpdateCartResponse> updateCartQuantity(
      String productId, String type) async {
    final String path = '/cart/user/cartItem/quantity/$type';

    if (productId.isEmpty || productId.length != 24) {
      throw Exception('Invalid product ID');
    }

    final Map<String, dynamic> body = {
      'productId': productId,
    };

    try {
      final http.Response response =
          await apiClient.invokeAPI(path, 'PUT', body);

      return UpdateCartResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Unable to update cart: $e');
    }
  }
}
