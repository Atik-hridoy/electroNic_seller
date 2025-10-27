import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/storage/storage_services.dart';
import '../models/add_product_model.dart';

class AddProductService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  Future<dio.Response> addProduct({
    required AddProductModel product,
    required List<File> images,
  }) async {
    try {
      // ✅ Convert product model to Map safely
      final productData = product.toJson();

      // ✅ Create FormData from the model
      final formData = dio.FormData.fromMap(
        productData,
        dio.ListFormat.multiCompatible,
      );

      // ✅ Add image files
      for (var i = 0; i < images.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await dio.MultipartFile.fromFile(
              images[i].path,
              filename: 'product_image_$i${path.extension(images[i].path)}',
            ),
          ),
        );
      }

      // ✅ Auth token from local storage
      final token = LocalStorage.token;

      // ✅ Make POST request
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.addProduct}',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      // ✅ Handle known Dio exceptions
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // ✅ Handle unknown exceptions
      throw Exception('Unexpected error: $e');
    }
  }
}
