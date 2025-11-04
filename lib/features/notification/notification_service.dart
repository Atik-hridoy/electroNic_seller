import 'package:dio/dio.dart';
import '../../core/constants/app_urls.dart';
import '../../core/storage/storage_services.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<Response> getNotifications() async {
    try {
      final token = LocalStorage.token;
      
      print('🔔 Fetching notifications from: ${AppUrls.baseUrl}${AppUrls.getNotifications}');
      
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getNotifications}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('✅ Notifications Response: ${response.statusCode}');
      print('📦 Data: ${response.data}');
      
      return response;
    } on DioException catch (e) {
      print('❌ Notification Error: ${e.message}');
      if (e.response != null) {
        print('📛 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> markAllNotificationsAsRead() async {
    try {
      final token = LocalStorage.token;
      
      print('✅ Marking all notifications as read: ${AppUrls.baseUrl}${AppUrls.getNotifications}');
      
      final response = await _dio.patch(
        '${AppUrls.baseUrl}${AppUrls.getNotifications}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('✅ Mark All Response: ${response.statusCode}');
      print('📦 Data: ${response.data}');
      
      return response;
    } on DioException catch (e) {
      print('❌ Mark All Error: ${e.message}');
      if (e.response != null) {
        print('📛 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
