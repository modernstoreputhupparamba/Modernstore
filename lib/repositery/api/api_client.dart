import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modern_grocery/main.dart';
import 'package:modern_grocery/repositery/api/api_exception.dart';
import 'package:modern_grocery/ui/auth_/enter_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  Future<http.Response> invokeAPI(String path, String method, Object? body,
      {Map<String, File>? files}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final String url = basePath + (path.startsWith('/') ? path : '/$path');

    if (kDebugMode) print(' API Request: $method $url');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) print(' Token: ${token ?? "No token"}');

    // Handle Multipart (File Upload) Request for POST or PUT
    if (method.toUpperCase() == 'POST_MULTIPART' ||
        (method.toUpperCase() == 'PUT' && files != null)) {
      try {
        final request = http.MultipartRequest(
            (method.toUpperCase() == 'PUT') ? 'PUT' : 'POST', Uri.parse(url));
        request.headers.addAll(headers);
        request.headers.remove('Content-Type');

        // Add body fields
        if (body is Map<String, String>) {
          request.fields.addAll(body);
        }

        // Add files
        if (files != null) {
          for (var entry in files.entries) {
            request.files.add(
                await http.MultipartFile.fromPath(entry.key, entry.value.path));
          }
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (kDebugMode) {
          print('Status: ${response.statusCode}');
          print('Response: ${response.body}');
        }
        return response;
      } catch (e) {
        throw ApiException('Network error during file upload: $e', 0);
      }
    }
    String? encodedBody;
    if (body != null) {
      encodedBody = body is String ? body : jsonEncode(body);
      if (kDebugMode) print(' Body: $encodedBody');
    }

    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case "POST":
          response = await http.post(Uri.parse(url),
              headers: headers, body: encodedBody);
          break;
        case "PUT":
          response = await http.put(Uri.parse(url),
              headers: headers, body: encodedBody);
          break;
        case "DELETE":
          response = await http.delete(Uri.parse(url),
              headers: headers, body: encodedBody);
          break;
        case "PATCH":
          response = await http.patch(Uri.parse(url),
              headers: headers, body: encodedBody);
          break;
        default:
          response = await http.get(Uri.parse(url), headers: headers);
      }
    } catch (e) {
      if (kDebugMode) print(' Network error on $path: $e');
      throw ApiException('Network error: $e', 0);
    }

    if (kDebugMode) {
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
    if (response.statusCode == 401) {
      log('Unauthorized - redirecting to login');

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => EnterScreen()),
        (route) => false,
      );

      throw ApiException('Unauthorized', 401);
    }

    if (response.statusCode >= 400) {
      log('$path : ${response.statusCode} : ${response.body}');
      throw ApiException(_decodeError(response), response.statusCode);
    }

    return response;
  }

  String _decodeError(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return decoded['message']?.toString() ?? response.body;
    } catch (_) {
      return response.body;
    }
  }
}
