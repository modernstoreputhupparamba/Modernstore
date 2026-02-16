import 'dart:io';
import 'package:http/http.dart';
import '../../api/api_client.dart';

class EditCategoryApi {
  ApiClient apiClient = ApiClient();

  Future<void> updateCategory({
    required String categoryId,
    required String categoryName,
    File? imageFile, // Image is optional for updates
  }) async {
    final String path = '/category/update/$categoryId';

    final Map<String, String> body = {
      'name': categoryName,
    };

    Map<String, File>? files;
    if (imageFile != null) {
      files = {'image': imageFile};
    }
    await apiClient.invokeAPI(path, 'PUT', body, files: files);
  }
}