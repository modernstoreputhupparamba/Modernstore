import 'dart:convert';

import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';

import '../../model/Dashboard/dashboard_model.dart';

class DashboardApi {
  ApiClient apiClient = ApiClient();

  Future<DashboardModel> getDashboardData() async {
    // Assuming your backend endpoint for dashboard stats is '/dashboard/stats'
    // Please adjust if it's different.
    String path = '/dashboard/overview';

    Response response = await apiClient.invokeAPI(path, 'GET', null);
    return DashboardModel.fromJson(jsonDecode(response.body));
  }
}