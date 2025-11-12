import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import '../model/seller_rating_model.dart';

class GetSellerRatingService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  /// Get seller rating statistics
  /// This endpoint provides rating breakdown and statistics for the seller
  Future<dio.Response> getSellerRating() async {
    try {
      final token = LocalStorage.token;

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final fullUrl = '${AppUrls.baseUrl}${AppUrls.getSellerRateing}';

      // ===== DEBUG: Print request details =====
      print('\n========== GET SELLER RATING API REQUEST ==========');
      print('URL: $fullUrl');
      print('Token: ${token.substring(0, 20)}...');
      print('==================================================\n');

      AppLogger.info('Fetching seller rating statistics');

      final response = await _dio.get(
        fullUrl,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // ===== DEBUG: Print response details =====
      print('\n========== GET SELLER RATING API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('====================================================\n');

      AppLogger.info('Seller rating statistics fetched successfully');
      return response;
    } on dio.DioException catch (e) {
      AppLogger.error('DioException in getSellerRating: ${e.message}');
      
      print('\n========== GET SELLER RATING API ERROR ==========');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      if (e.response != null) {
        print('Error Status Code: ${e.response?.statusCode}');
        print('Error Response Data: ${e.response?.data}');
      }
      print('================================================\n');
      
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected error in getSellerRating: $e');
      print('Unexpected error in getSellerRating: $e');
      rethrow;
    }
  }
}
