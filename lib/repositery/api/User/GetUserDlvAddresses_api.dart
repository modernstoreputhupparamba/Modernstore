import 'dart:convert';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/user/getUserDlvAddresses.dart';

class GetUserDeliveryAddressesApi {
  final ApiClient apiClient = ApiClient();

  Future<GetUserDlvAddresses> getGetUserDlvAddresses() async {
    const String endpoint = '/user/get-delivery-addresses';

    try {
      // GET request — no body needed
      Response response = await apiClient.invokeAPI(endpoint, 'GET', null);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return GetUserDlvAddresses.fromJson(jsonMap);
      } else {
        throw Exception(
            'Failed to load delivery addresses (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('❌ GetUserDeliveryAddresses API Error: $e');
      rethrow;
    }
  }
}
