import 'package:dio/dio.dart' hide Response;
import 'package:get/get.dart';
import '../../../../../../core/constants/app_urls.dart';
import '../../../../../../core/storage/storage_services.dart';
import '../../../../../../core/util/app_logger.dart';

class ProductBrandService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  /// Fetches all product categories
  Future<Response<dynamic>> getProductBrands() async {
    final url = '${AppUrls.baseUrl}${AppUrls.getProductsBrands}';
    AppLogger.info('Fetching product brands: $url', tag: 'ProductBrandService');
    
    try {
      // Get the authentication token
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;
      
      if (token.isEmpty) {
        throw Exception('No authentication token found. Please log in again.');
      }
      
      // Make the request with headers
      final response = await _dio.get<dynamic>(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      
      // Log successful response
      AppLogger.success(
        '✅ Product brands fetched successfully',
        tag: 'ProductBrandService',
      );
      
      return Response(
        body: response.data,
        statusCode: response.statusCode,
        statusText: response.statusMessage,
      );
    } on DioException catch (e) {
      // Log error response
      if (e.response != null) {
        AppLogger.error(
          '❌ Failed to fetch product brands: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          error: e,
          stackTrace: e.stackTrace,
          tag: 'ProductBrandService',
        );
        // Return the error response if it exists
        return Response(
          body: e.response?.data,
          statusCode: e.response?.statusCode,
          statusText: e.response?.statusMessage,
        );
      } else {
        // If no response is available, rethrow the error
        AppLogger.error(
          '❌ Network error while fetching product brands',
          error: e,
          stackTrace: e.stackTrace,
          tag: 'ProductBrandService',
        );
        rethrow;
      }
    } catch (e, stackTrace) {
      // Handle any other type of error
      AppLogger.error(
        '❌ Unexpected error while fetching product brands',
        error: e,
        stackTrace: stackTrace,
        tag: 'ProductBrandService',
      );
      rethrow;
    }
}

  /// Gets a specific category by ID
  Future<Response<dynamic>> getCategoryById(String categoryId) async {
    final url = '${AppUrls.baseUrl}${AppUrls.getProductsCategories}/$categoryId';
    AppLogger.info('Fetching category by ID: $categoryId', tag: 'ProductCategoryService');
    
    try {
      // Get the authentication token
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;
      
      if (token.isEmpty) {
        throw Exception('No authentication token found. Please log in again.');
      }
      
      final response = await _dio.get<dynamic>(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      
      // Log successful response
      AppLogger.success(
        '✅ Category $categoryId fetched successfully',
        tag: 'ProductCategoryService',
      );
      
      return Response(
        body: response.data,
        statusCode: response.statusCode,
        statusText: response.statusMessage,
      );
    } on DioException catch (e) {
      // Log error response
      if (e.response != null) {
        AppLogger.error(
          '❌ Failed to fetch category $categoryId: ${e.response?.statusCode} - ${e.response?.statusMessage}',
          error: e,
          stackTrace: e.stackTrace,
          tag: 'ProductCategoryService',
        );
        return Response(
          body: e.response?.data,
          statusCode: e.response?.statusCode,
          statusText: e.response?.statusMessage,
        );
      }
  
      // Log network error
      AppLogger.error(
        '❌ Network error while fetching category $categoryId',
        error: e,
        stackTrace: e.stackTrace,
        tag: 'ProductCategoryService',
      );
      rethrow;
    }
  }
}
