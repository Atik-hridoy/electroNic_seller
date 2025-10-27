import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';

class GetWorkFuntionalityService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  Future<dio.Response> getWorkFuntionality() async {
    try {
      final token = LocalStorage.token;
      final url = '${AppUrls.baseUrl}${AppUrls.getWorkFuntionality}';

      final res = await _dio.get(
        url,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return res;
    } on dio.DioException catch (e) {
      throw Exception('Failed to fetch Work Funtionality: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
