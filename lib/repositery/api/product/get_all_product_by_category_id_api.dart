import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';

import '../../model/product/get_all_product_by_category_id_model.dart';

class GetAllProductByCategoryIdApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllProductByCategoryIdModel> getProductsByCategoryId(String id) async {
    String path = '/product/get/category/items/$id';
    Response response = await apiClient.invokeAPI(path, 'GET', {});
    return GetAllProductByCategoryIdModel.fromJson(jsonDecode(response.body));
  }
}