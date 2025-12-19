import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Orders/getAllOrders_model.dart';

class GetAllOrdersApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllOrdersModel> getAllOrders() async {
    String path = '/order/';

    Response response = await apiClient.invokeAPI(path, 'GET', null);

    return GetAllOrdersModel.fromJson(jsonDecode(response.body));
  }
}