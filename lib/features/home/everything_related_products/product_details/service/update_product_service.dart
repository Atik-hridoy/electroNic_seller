import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';

class UpdateProductService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  Future<Map<String, dynamic>> updateProduct({
    required String productId,
    required Map<String, dynamic> productData,
    List<File>? newImages,
  }) async {
    const String tag = 'UpdateProductService';
    final String endpoint = '${AppUrls.baseUrl}${AppUrls.updateProduct}$productId';
    
    try {
      // Get the token from storage
      final token = LocalStorage.token;
      
      // Log API request
      AppLogger.apiRequest(
        method: 'PATCH',
        endpoint: endpoint,
        body: productData,
      );
      
      FormData formData;
      
      if (newImages != null && newImages.isNotEmpty) {
        // If there are new images, use multipart/form-data
        Map<String, dynamic> fields = {};
        
        // Add all product data as fields
        productData.forEach((key, value) {
          if (value != null) {
            if (value is List) {
              fields[key] = jsonEncode(value);
            } else {
              fields[key] = value.toString();
            }
          }
        });
        
        List<MultipartFile> imageFiles = [];
        for (var image in newImages) {
          imageFiles.add(
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          );
        }
        
        formData = FormData.fromMap({
          ...fields,
          'images': imageFiles,
        });
        
        AppLogger.debug('Uploading ${imageFiles.length} new images', tag: tag);
      } else {
        // No new images, just send JSON data
        formData = FormData.fromMap(productData);
      }
      
      // Make the API call with timing
      final startTime = DateTime.now();
      final response = await _dio.patch(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      final duration = DateTime.now().difference(startTime);

      // Log API response
      AppLogger.apiResponse(
        method: 'PATCH',
        endpoint: endpoint,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
        duration: duration,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.success(
          'Product updated successfully',
          tag: tag,
        );
        return {
          'success': true,
          'message': 'Product updated successfully',
          'data': response.data,
        };
      } else {
        final errorMsg = 'Failed to update product: ${response.statusCode}';
        AppLogger.error(errorMsg, tag: tag, error: response.data);
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      final errorMsg = 'DioError updating product: ${e.message}';
      AppLogger.error(
        errorMsg,
        tag: tag,
        error: e,
        stackTrace: e.stackTrace,
      );
      if (e.response != null) {
        AppLogger.debug(
          'Error response: ${e.response?.data}',
          tag: tag,
        );
      }
      throw Exception(errorMsg);
    } catch (e, stackTrace) {
      final errorMsg = 'Unexpected error: $e';
      AppLogger.error(
        errorMsg,
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception(errorMsg);
    }
  }
}
