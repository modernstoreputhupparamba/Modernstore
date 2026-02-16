import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Wishlist/addToWishlist_model.dart';

class AddToWishlistApi {
  final ApiClient apiClient = ApiClient();

  Future<AddToWishlistMode> getAddToWishlistMode(String productId) async {
    String trendingpath = '/wishlist/add';
    Map<String, dynamic> body = {"productId": productId};

    Response response = await apiClient.invokeAPI(
      trendingpath,
      'POST',
      jsonEncode(body),
    );

    return AddToWishlistMode.fromJson(jsonDecode(response.body));
  }
}
