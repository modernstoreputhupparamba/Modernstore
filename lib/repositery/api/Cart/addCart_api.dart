import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/repositery/api/api_client.dart';

class AddToCartResponse {
  final bool success;
  final String message;
  final dynamic data;

  AddToCartResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

class AddCartApi {
  final ApiClient apiClient;

  AddCartApi({required this.apiClient});

  /// 🔹 OLD NAME expected by ApiClient / generator
  /// This keeps the framework happy and simply forwards to the real method.
  Future<AddToCartResponse> getAddCartModel(
      String productId, int quantity) {
    return addToCart(productId, quantity);
  }

  /// 🔹 Your real implementation
  Future<AddToCartResponse> addToCart(String productId, int quantity) async {
    const String path = '/cart/user/addToCart';

    if (productId.isEmpty || productId.length != 24) {
      throw Exception('Invalid product ID');
    }

    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    final Map<String, dynamic> body = {
      'productId': productId,
      'qnt': quantity,
    };

    try {
      final http.Response response =
          await apiClient.invokeAPI(path, 'POST', body);

      final statusCode = response.statusCode;
      final Map<String, dynamic> jsonBody =
          json.decode(response.body) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        return AddToCartResponse.fromJson(jsonBody);
      } else {
        final message =
            jsonBody['message'] ?? 'Failed to add to cart. Please try again.';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Unable to add to cart: $e');
    }
  }
}
