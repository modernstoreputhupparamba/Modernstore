import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Wishlist/getToWishlist_model.dart';

class GettowishlistApi {
  ApiClient apiClient = ApiClient();

  Future<GetToWishlistModel> getGetToWishlistModel() async {
    String tendingpath = '/wishlist/get';

    var body = {};

    Response response = await apiClient.invokeAPI(tendingpath, 'GET', body);

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    return GetToWishlistModel.fromJson(jsonResponse);
  }
}
