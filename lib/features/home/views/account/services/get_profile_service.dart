import 'package:dio/dio.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';

import '../model/get_profile_model.dart';

class GetProfileService {
  final Dio _dio;

  GetProfileService() : _dio = Dio(_createDioOptions()) {
    _setupInterceptors();
  }

  static BaseOptions _createDioOptions() {
    return BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          await LocalStorage.getAllPrefData();
          final token = LocalStorage.token;
          
          if (token.isEmpty) {
            AppLogger.warning('No authentication token found in storage');
          } else {
            options.headers['Authorization'] = 'Bearer $token';
            AppLogger.debug('Added Authorization header with token');
          }
          
          AppLogger.debug('Making ${options.method} request to ${options.uri}');
          return handler.next(options);
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error in request interceptor',
            error: e,
            stackTrace: stackTrace,
          );
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Request setup failed: $e',
              stackTrace: stackTrace,
            ),
          );
        }
      },
      onError: (error, handler) {
        AppLogger.error(
          'Dio Error: ${error.message}',
          error: error,
          stackTrace: error.stackTrace,
        );
        
        if (error.response?.statusCode == 403) {
          AppLogger.error('Authentication failed. Token might be invalid or expired.');
          // You might want to add token refresh logic here
        }
        
        return handler.next(error);
      },
    ));
  }

  Future<GetProfileModel?> getProfile() async {
    try {
      AppLogger.debug('Fetching profile data from ${AppUrls.getProfile}');
      final response = await _dio.get(
        AppUrls.getProfile,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          validateStatus: (status) => status == 200,
        ),
      );

      if (response.statusCode == 200) {
        AppLogger.debug('Successfully fetched profile data');
        return GetProfileModel.fromJson(response.data);
      }
      
      AppLogger.warning('Unexpected status code: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(
          errorMsg,
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(
          errorMsg,
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in getProfile',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

