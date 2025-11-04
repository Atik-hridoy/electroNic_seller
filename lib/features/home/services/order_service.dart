import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/storage/storage_services.dart';
import '../../../core/util/app_logger.dart';

class OrderService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  /// Get orders with optional status filter
  /// Status can be: 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  Future<dio.Response> getOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Get auth token from local storage
      final token = LocalStorage.token;

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Build query parameters
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      // Add status filter if provided
      if (status != null && status.isNotEmpty) {
        queryParameters['deliveryStatus'] = status;
      }

      // ===== DEBUG: Print request details =====
      final fullUrl = '${AppUrls.baseUrl}${AppUrls.getOrders}';
      print('\n========== GET ORDERS API REQUEST ==========');
      print('URL: $fullUrl');
      print('Query Parameters: $queryParameters');
      print('Token: ${token.substring(0, 20)}...');
      print('===========================================\n');
      
      AppLogger.info('Fetching orders with params: $queryParameters');

      // Make GET request
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

      print('\n========== GET ORDERS API RESPONSE (Service) ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('======================================================\n');

      AppLogger.success('Orders fetched successfully: ${response.statusCode}');
      return response;
    } on dio.DioException catch (e) {
      print('\n========== GET ORDERS API ERROR ==========');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Error Type: ${e.type}');
      print('Response: ${e.response}');
      print('Response Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('=========================================\n');
      
      AppLogger.error('DioException while fetching orders: ${e.message}');
      if (e.response != null) {
        AppLogger.error('Response data: ${e.response?.data}');
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('\n========== GET ORDERS UNEXPECTED ERROR ==========');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('================================================\n');
      
      AppLogger.error('Unexpected error while fetching orders: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Update order delivery status
  Future<dio.Response> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final token = LocalStorage.token;

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Build the full URL with the new endpoint
      final fullUrl = '${AppUrls.baseUrl}${AppUrls.updateStatus}$orderId';

      // ===== DEBUG: Print request details =====
      print('\n========== UPDATE ORDER STATUS API REQUEST ==========');
      print('URL: $fullUrl');
      print('Method: PATCH');
      print('Order ID: $orderId');
      print('New Status: $status');
      print('Body: {"deliveryStatus": "$status"}');
      print('Token: ${token.substring(0, 20)}...');
      print('====================================================\n');

      AppLogger.info('Updating order $orderId status to: $status');

      final response = await _dio.patch(
        fullUrl,
        data: {
          'deliveryStatus': status,
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('\n========== UPDATE ORDER STATUS API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('=====================================================\n');

      AppLogger.success('Order status updated successfully');
      return response;
    } on dio.DioException catch (e) {
      print('\n========== UPDATE ORDER STATUS API ERROR ==========');
      print('Error Type: DioException');
      print('Error Message: ${e.message}');
      print('Response Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('==================================================\n');

      AppLogger.error('DioException while updating order status: ${e.message}');
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('\n========== UPDATE ORDER STATUS UNEXPECTED ERROR ==========');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('=========================================================\n');

      AppLogger.error('Unexpected error while updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }
}
