import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Cart/getAllUserCart_model.dart';

class GetallusercartApi {
  ApiClient apiClient = ApiClient();

  Future<GetAllUserCartModel> getGetAllUserCartModel() async {
    String trendingpath = '/cart/user/getAll';
    var body = {};

    Response response = await apiClient.invokeAPI(trendingpath, 'GET', body);

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);

    // ✅ Now pass the parsed map to the model
    return GetAllUserCartModel.fromJson(decodedJson);
  }
}
