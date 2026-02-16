import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/product/getAllProduct.dart';

class GetallproductApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllProduct> getGetAllProduct(String query) async {
    String path = '/product/all';

    if (query.isNotEmpty) {
      path += '?search=$query';
    }

    var body = {};
    Response response = await apiClient.invokeAPI(path, 'GET', body);

    return GetAllProduct.fromJson(jsonDecode(response.body));
  }
}
