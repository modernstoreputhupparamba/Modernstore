import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';

import '../../model/user/edit_user_profile_model.dart';

class EditUserProfileApi {
  final ApiClient apiClient = ApiClient();

  Future<EditUserProfileModel> updateProfile(Map<String, dynamic> body, {File? imageFile}) async {
    const String url = '/user/update-profile';

    if (imageFile != null) {
      final stringBody = body.map((key, value) => MapEntry(key, value.toString()));
      Response response = await apiClient.invokeAPI(
        url,
        'PUT',
        stringBody,
        files: {'profileImage': imageFile},
      );
      return EditUserProfileModel.fromJson(jsonDecode(response.body));
    }

    Response response = await apiClient.invokeAPI(
      url,
      'PUT',
      body,
    );

    return EditUserProfileModel.fromJson(jsonDecode(response.body));
  }
}