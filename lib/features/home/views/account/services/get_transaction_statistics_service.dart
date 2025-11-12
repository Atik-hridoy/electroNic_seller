import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';

class GetTransactionStatisticsService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  /// Get monthly transaction statistics
  /// This endpoint provides transaction updates and statistics for the seller
  Future<dio.Response> getMonthlyTransactionStatistics() async {
    try {
      final token = LocalStorage.token;

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final fullUrl = '${AppUrls.baseUrl}${AppUrls.getMonthlyTransactionStatistics}';

      // ===== DEBUG: Print request details =====
      print('\n========== GET TRANSACTION STATISTICS API REQUEST ==========');
      print('URL: $fullUrl');
      print('Token: ${token.substring(0, 20)}...');
      print('===========================================================\n');

      AppLogger.info('Fetching monthly transaction statistics');

      final response = await _dio.get(
        fullUrl,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('\n========== GET TRANSACTION STATISTICS API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('============================================================\n');

      AppLogger.success('Transaction statistics fetched successfully: ${response.statusCode}');
      return response;
    } on dio.DioException catch (e) {
      print('\n========== GET TRANSACTION STATISTICS API ERROR ==========');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Error Type: ${e.type}');
      print('Response Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('=========================================================\n');

      AppLogger.error('DioException while fetching transaction statistics: ${e.message}');
      if (e.response != null) {
        AppLogger.error('Response data: ${e.response?.data}');
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('\n========== GET TRANSACTION STATISTICS UNEXPECTED ERROR ==========');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('================================================================\n');

      AppLogger.error('Unexpected error while fetching transaction statistics: $e');
      throw Exception('Failed to fetch transaction statistics: $e');
    }
  }
}
