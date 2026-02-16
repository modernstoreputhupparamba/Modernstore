import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Orders/Get_user_order_Model.dart';

class GetUserOrderApi {
  ApiClient apiClient = ApiClient();

  Future<GetUserOrderModel> getUserOrders() async {
    String path = '/order/user';

    Response response = await apiClient.invokeAPI(path, 'GET', null);

    return GetUserOrderModel.fromJson(jsonDecode(response.body));
  }
}