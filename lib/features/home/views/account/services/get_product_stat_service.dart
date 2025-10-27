import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';

class GetProductStatService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  Future<dio.Response> getProductStatistics() async {
    try {
      final token = LocalStorage.token;

      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getProductStatistics}',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      throw Exception('Error fetching product statistics: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
