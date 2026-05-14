import 'dart:convert';
import 'package:http/http.dart';
import '../api_client.dart';
import '../../model/Cart/remove_cart_item_model.dart';

class RemoveCartItemApi {
  ApiClient apiClient = ApiClient();

  Future<RemoveCartItemModel> removeCartItem(String productId) async {
    String path = 'cart/user/cartItem/remove';
    var body = {"productId": productId};
    
    Response response = await apiClient.invokeAPI(path, 'DELETE', body);
    return RemoveCartItemModel.fromJson(jsonDecode(response.body));
  }
}