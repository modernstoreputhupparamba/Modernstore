import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/main.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Categories/getAllForListCategory.dart';

class GetAllForListCategoryApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllForListCategory> getGetAllForListCategory() async {
    String url = '$basePath/category/get/all/list';

    Response response = await apiClient.invokeAPI(
      url,
      'GET',
      null,
    );

    return GetAllForListCategory.fromJson(jsonDecode(response.body));
  }
}
