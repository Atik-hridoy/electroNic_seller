// Create a new file: lib/features/home/everything_related_products/category/services/get_all_products_service.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import '../model/get_model.dart';

class GetAllProductsService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  Future<GetProductsResponse> getAllProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      // Get the token from storage
      final token = LocalStorage.token;
      
      // Build query parameters
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
        if (categoryId != null) 'categoryId': categoryId,
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
      };

      // Make the API call
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getAllProducts}',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Parse and return the response
      if (response.statusCode == 200) {
        return GetProductsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}