import 'package:dio/dio.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import 'package:get/get.dart';

class DeleteAccountService {
  final Dio _dio = Get.find<Dio>();

  Future<bool> deleteAccount() async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        throw Exception('No access token found');
      }

      // Make the DELETE request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.deleteAccount}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      // Log the request
      AppLogger.apiRequest(
        method: 'DELETE',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.delete(
        url,
        options: Options(headers: headers),
      );

      // Log the response
      AppLogger.apiResponse(
        method: 'DELETE',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.success('Account deleted successfully');
        return true;
      } else {
        final errorMsg = 'Failed to delete account: ${response.statusMessage}';
        AppLogger.error(
          errorMsg,
          error: Exception(errorMsg),
          stackTrace: StackTrace.current,
        );
        throw Exception(errorMsg);
      }
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
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to delete account: $e');
    }
  }
}
