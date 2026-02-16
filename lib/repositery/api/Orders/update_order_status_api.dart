import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';

class UpdateOrderStatusApi {
  final ApiClient apiClient = ApiClient();

  Future<void> updateOrderStatus(String orderId, String status) async {
    final String endpoint = '/order/$orderId/status';
    final body = jsonEncode({
      // "orderId": orderId,
      "status": status,
    });

    try {
      Response response = await apiClient.invokeAPI(endpoint, 'PUT', body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to update order status: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}