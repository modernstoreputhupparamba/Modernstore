import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../api_client.dart';
import '../../model/product/updateProduct_model.dart';

class UpdateProductApi {
  ApiClient apiClient = ApiClient();

  Future<UpdateProductModel> updateProduct({
    required String productId,
    required String productName,
    required String productSubName,
    required String categoryId,
    required String productDescription,
    required String price,
    required String discountPercentage,
    required String unit,
    dynamic imageFile, // Can be File, String, or List containing File and Strings
    required List<String> selectableQuantities
  }) async {
    final String path = '/product/update/$productId';

    final Map<String, String> body = {
      'name': productName,
      'subName':productSubName,
      'basePrice': price,
      'discountPercentage': discountPercentage,
      'unit': unit,
      'description': productDescription,
      'categoryId': categoryId,
      // 'selectableQuantities': jsonEncode(selectableQuantities),
    };
// Add quantities
  for (int i = 0; i < selectableQuantities.length; i++) {
    body['selectableQuantities[$i]'] = selectableQuantities[i];
  }

    final Map<String, File> files = {};
    
    if (imageFile is List) {
      int stringIndex = 0;
      for (var item in imageFile) {
        if (item is File) {
          files['images'] = item; 
        } else if (item is String) {
          // Send existing images under the 'images' field in the body
          body['images[$stringIndex]'] = item;
          stringIndex++;
        }
      }
    } else if (imageFile is File) {
      files['images'] = imageFile;
    } else if (imageFile is String) {
      body['images[0]'] = imageFile;
    }

    Response response = await apiClient.invokeAPI(path, 'PUT', body,
        files: files.isNotEmpty ? files : null);

    return UpdateProductModel.fromJson(json.decode(response.body));
  }
}
