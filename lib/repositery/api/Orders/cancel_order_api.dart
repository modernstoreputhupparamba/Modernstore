import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Orders/cancel_order_model.dart';

class CancelOrderApi {
  final ApiClient apiClient = ApiClient();

  Future<CancelOrderModel> cancelOrder(String orderId, String reason) async {
    String url = '/order/cancel-order/$orderId';
    final body = {"reason": reason};

    Response response = await apiClient.invokeAPI(
      url,
      'PUT',
      body,
    );

    return CancelOrderModel.fromJson(jsonDecode(response.body));
  }
}