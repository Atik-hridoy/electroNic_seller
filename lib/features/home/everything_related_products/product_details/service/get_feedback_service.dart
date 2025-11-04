import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import '../model/feedback_model.dart';

class GetFeedbackService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  Future<List<FeedbackModel>> getFeedbacks(String productId) async {
    const String tag = 'GetFeedbackService';
    final String endpoint = '${AppUrls.baseUrl}${AppUrls.getFeedBack}$productId';

    try {
      // Get the token from storage
      final token = LocalStorage.token;
      
      // Log API request
      AppLogger.apiRequest(
        method: 'GET',
        endpoint: endpoint,
      );

      // Make the API call with timing
      final startTime = DateTime.now();
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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

      if (response.statusCode == 200) {
        List<dynamic> data;
        
        // Check if response is wrapped in an object or is direct array
        if (response.data is List) {
          data = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // If wrapped, try common keys: data, feedbacks, results
          final map = response.data as Map<String, dynamic>;
          data = (map['data'] ?? map['feedbacks'] ?? map['results'] ?? []) as List<dynamic>;
        } else {
          data = [];
        }
        
        final feedbacks = data.map((json) => FeedbackModel.fromJson(json)).toList();
        
        AppLogger.success(
          'Loaded ${feedbacks.length} feedbacks for product: $productId',
          tag: tag,
        );
        
        return feedbacks;
      } else {
        final errorMsg = 'Failed to fetch feedbacks: ${response.statusCode}';
        AppLogger.error(errorMsg, tag: tag, error: response.data);
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      final errorMsg = 'DioError fetching feedbacks: ${e.message}';
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
