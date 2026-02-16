import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/user/addDeliveryAddress.dart';

class AddDeliveryAddressApi {
  ApiClient apiClient = ApiClient();

  Future<AddDeliveryAddress> getaddDeliveryAddress(
      Map<String, dynamic> deliverydata) async {
    String url = '/user/add-delivery-address';

    try {
      final body = jsonEncode(deliverydata);

// var body = {
//       "address": "Root-sys, SkyMall, Edarikkode, Kottakkal",
//       "city": "Edarikkode",
//       "pincode": "123456",
//       "latitude": "1.00000000000000",
//       "longitude": "2.0000000000000"
//     };

      Response response = await apiClient.invokeAPI(
        url,
        'POST',
        body,
      );

      print('adddelivery addresssss   $body');

      return AddDeliveryAddress.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to add AddDeliveryAddress: $e');
    }
  }
}
