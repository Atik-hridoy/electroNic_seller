import 'package:dio/dio.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/util/app_logger.dart';

class AuthSignInService {
  final Dio _dio;

  AuthSignInService() : _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.debug('Sending request to ${options.uri}');
        AppLogger.debug('Headers: ${options.headers}');
        AppLogger.debug('Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.debug('Response from ${response.requestOptions.uri}');
        AppLogger.debug('Status: ${response.statusCode}');
        AppLogger.debug('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        AppLogger.error('Dio Error: ${e.message}');
        AppLogger.error('Error Type: ${e.type}');
        if (e.response != null) {
          AppLogger.error('Status: ${e.response?.statusCode}');
          AppLogger.error('Response: ${e.response?.data}');
        }
        return handler.next(e);
      },
    ));
  }

  Future<Map<String, dynamic>> signInUser({required String email}) async {
    try {
      AppLogger.debug('Attempting to sign in with email: $email', tag: 'AuthSignInService');
      
      final response = await _dio.post(
        AppUrls.signIn,
        data: {'email': email},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      AppLogger.debug('Sign in response: ${response.data}', tag: 'AuthSignInService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'OTP sent successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to send OTP. Status: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      String errorMessage = _getErrorMessage(e);
      AppLogger.error('Sign in failed: $errorMessage', tag: 'AuthSignInService');
      return {
        'success': false,
        'message': errorMessage,
        'errorType': e.type.toString(),
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      AppLogger.error('Unexpected error during sign in: $e', tag: 'AuthSignInService');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return e.response?.data['message'] ?? 'Server error occurred.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error occurred. Please check your connection.';
    }
  }
}