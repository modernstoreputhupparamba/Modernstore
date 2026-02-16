import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Inventory/getAllnventory.dart';

class GetAllInventoryApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllnventory> getGetAllnventory() async {
    const String path = '/inventory/getAll';
    Response response = await apiClient.invokeAPI(
      path,
      'GET',
      null,
    );

    return GetAllnventory.fromJson(jsonDecode(response.body));
  }
}
