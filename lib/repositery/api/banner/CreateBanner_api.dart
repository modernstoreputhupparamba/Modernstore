import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/model/Banner/CreateBanner_model.dart';

class CreateBannerApi {
  final ApiClient _apiClient;

  CreateBannerApi({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<CreateBannerModel> uploadBanner({
    required File imageFile,
    required String type,
    String? title,
    String? category,
    String? categoryId,
    String? productId,
    String? link,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    const String path = '/banner/create';

    // ✅ Validate required combinations before API call
    if (type == "product" && (productId == null || productId.isEmpty)) {
      throw Exception("Product ID is required for product type banner");
    }

    if (type == "category" && (categoryId == null || categoryId.isEmpty)) {
      throw Exception("Category ID is required for category type banner");
    }

    if (!imageFile.existsSync()) {
      throw Exception("Image file does not exist");
    }

    final Map<String, String> body = {
      'type': type,
      if (title != null && title.isNotEmpty) 'title': title,
      if (category != null && category.isNotEmpty) 'category': category,
      if (categoryId != null && categoryId.isNotEmpty)
        'categoryId': categoryId,
      if (productId != null && productId.isNotEmpty)
        'productId': productId,
      if (link != null && link.isNotEmpty) 'link': link,
    };

    final Map<String, File> files = {
      'images': imageFile,
    };

    try {
      debugPrint("🚀 Banner Upload Request: $body");

      final Response response = await _apiClient.invokeAPI(
        path,
        'POST_MULTIPART',
        body,
        files: files,
      );

      debugPrint("📥 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body) as Map<String, dynamic>;

        _sanitizeResponse(jsonData);

        return CreateBannerModel.fromJson(jsonData);
      }

      throw Exception(
        "Upload failed [${response.statusCode}]: ${response.body}",
      );
    } catch (e) {
      throw Exception("Banner upload failed: $e");
    }
  }

  /// Cleans null string values from backend response
  void _sanitizeResponse(Map<String, dynamic> jsonData) {
    if (jsonData['banner'] != null && jsonData['banner'] is Map) {
      final banner = jsonData['banner'];

      banner['link'] ??= '';
      banner['productId'] ??= '';
      banner['categoryId'] ??= '';
    }
  }
}
