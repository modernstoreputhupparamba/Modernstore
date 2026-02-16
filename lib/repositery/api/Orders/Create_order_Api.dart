
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/repositery/api/api_client.dart';

class CreateOrderResponse {
  final bool success;
  final String message;
  final dynamic data;

  CreateOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}


class CreateOrderApi {
  final ApiClient apiClient;

  CreateOrderApi({required this.apiClient});

  /// 🔹 OLD NAME (optional, for consistency with your setup)
  Future<CreateOrderResponse> getCreateOrderModel({

    required String shippingAddress,
    required String paymentMethod,
    required int deliveryCharge,
  }) {
    return createOrder(

      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      deliveryCharge: deliveryCharge,
    );
  }

  /// 🔹 Real implementation
  Future<CreateOrderResponse> createOrder({

    required String shippingAddress,
    required String paymentMethod,
    required int deliveryCharge,
  }) async {
    const String path = '/order';

    // ✅ validations
  

    if (shippingAddress.isEmpty) {
      throw Exception('Shipping address is required');
    }

    if (paymentMethod.isEmpty) {
      throw Exception('Payment method is required');
    }

    if (deliveryCharge < 0) {
      throw Exception('Delivery charge cannot be negative');
    }

    final Map<String, dynamic> body = {
    
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'deliveryCharge': deliveryCharge,
    };

    try {
      final http.Response response =
          await apiClient.invokeAPI(path, 'POST', body);

      final statusCode = response.statusCode;
      final Map<String, dynamic> jsonBody =
          json.decode(response.body) as Map<String, dynamic>;

      if (statusCode >= 201 && statusCode < 300) {
        return CreateOrderResponse.fromJson(jsonBody);
      } else {
        final message =
            jsonBody['message'] ?? 'Failed to create order. Please try again.';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Unable to create order: $e');
    }
  }
}
