import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/main.dart';
import 'package:modern_grocery/repositery/model/Image_upload/upload_image_model.dart';

class UploadImageApi {
  Future<UploadImageModel> uploadImage(File imageFile) async {
    final uri = Uri.parse(
      '$basePath/media/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    // 🔑 MUST MATCH POSTMAN KEY
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );

    // ❌ DO NOT set Content-Type manually
    // request.headers['Content-Type'] = 'multipart/form-data';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UploadImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Upload failed: ${response.body}');
    }
  }
}
