import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import '../model/single_product_model.dart';

class GetSingleProductService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  Future<SingleProductResponse> getSingleProduct(String productId) async {
    const String tag = 'GetSingleProductService';
    final String endpoint = '${AppUrls.baseUrl}${AppUrls.getSingleProduct}$productId';
    
    try {
      // Get the token from storage
      final token = LocalStorage.token;
      
      // Build headers
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Log API request
      AppLogger.apiRequest(
        method: 'GET',
        endpoint: endpoint,
        headers: headers,
      );
      
      // Make the API call with timing
      final startTime = DateTime.now();
      final response = await _dio.get(
        endpoint,
        options: Options(headers: headers),
      );
      final duration = DateTime.now().difference(startTime);

      // Log API response
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: endpoint,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
        duration: duration,
      );

      // Parse and return the response
      if (response.statusCode == 200) {
        final productResponse = SingleProductResponse.fromJson(response.data);
        AppLogger.success(
          'Successfully loaded product: ${productResponse.data.name}',
          tag: tag,
        );
        return productResponse;
      } else {
        final errorMsg = 'Failed to load product: ${response.statusCode}';
        AppLogger.error(errorMsg, tag: tag, error: response.data);
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      final errorMsg = 'DioError fetching product: ${e.message}';
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
