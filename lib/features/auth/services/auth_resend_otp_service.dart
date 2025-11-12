import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/util/app_logger.dart';

class AuthResendOtpService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  /// Resend OTP to the user's email
  /// This endpoint sends a new OTP code to the provided email address
  Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    try {
      final fullUrl = '${AppUrls.baseUrl}${AppUrls.resendOtp}';

      // ===== DEBUG: Print request details =====
      print('\n========== RESEND OTP API REQUEST ==========');
      print('URL: $fullUrl');
      print('Email: $email');
      print('==========================================\n');

      AppLogger.info('Sending resend OTP request for email: $email');

      final response = await _dio.post(
        fullUrl,
        data: {
          'email': email,
        },
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // ===== DEBUG: Print response details =====
      print('\n========== RESEND OTP API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('===========================================\n');

      AppLogger.info('Resend OTP response received');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      AppLogger.error('DioException in resendOtp: ${e.message}');
      
      print('\n========== RESEND OTP API ERROR ==========');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      if (e.response != null) {
        print('Error Status Code: ${e.response?.statusCode}');
        print('Error Response Data: ${e.response?.data}');
      }
      print('========================================\n');
      
      // Return error response if available, otherwise throw
      if (e.response?.data != null) {
        return e.response!.data as Map<String, dynamic>;
      }
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected error in resendOtp: $e');
      print('Unexpected error in resendOtp: $e');
      rethrow;
    }
  }
}
