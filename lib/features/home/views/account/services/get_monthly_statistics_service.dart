import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';

class GetMonthlyStatisticsService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  /// Get monthly statistics with month and year parameters
  /// Month should be the full month name (e.g., "January", "February")
  /// Year should be a 4-digit year (e.g., 2024, 2025)
  Future<dio.Response> getMonthlyStatistics({
    required String month,
    required int year,
  }) async {
    try {
      final token = LocalStorage.token;

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Build query parameters
      final queryParameters = <String, dynamic>{
        'month': month,
        'year': year,
      };

      final fullUrl = '${AppUrls.baseUrl}${AppUrls.getMonthlyStatistics}';

      // ===== DEBUG: Print request details =====
      print('\n========== GET MONTHLY STATISTICS API REQUEST ==========');
      print('URL: $fullUrl');
      print('Query Parameters: $queryParameters');
      print('Token: ${token.substring(0, 20)}...');
      print('=======================================================\n');

      AppLogger.info('Fetching monthly statistics for $month $year');

      final response = await _dio.get(
        fullUrl,
        queryParameters: queryParameters,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('\n========== GET MONTHLY STATISTICS API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('========================================================\n');

      AppLogger.success('Monthly statistics fetched successfully: ${response.statusCode}');
      return response;
    } on dio.DioException catch (e) {
      print('\n========== GET MONTHLY STATISTICS API ERROR ==========');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Error Type: ${e.type}');
      print('Response Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('=====================================================\n');

      AppLogger.error('DioException while fetching monthly statistics: ${e.message}');
      if (e.response != null) {
        AppLogger.error('Response data: ${e.response?.data}');
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('\n========== GET MONTHLY STATISTICS UNEXPECTED ERROR ==========');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('============================================================\n');

      AppLogger.error('Unexpected error while fetching monthly statistics: $e');
      throw Exception('Failed to fetch monthly statistics: $e');
    }
  }
}
