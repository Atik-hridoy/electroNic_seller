import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';

class GetTermsService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();

  Future<dio.Response> getTerms() async {
    try {
      final token = LocalStorage.token;
      final url = '${AppUrls.baseUrl}${AppUrls.getTermsOfService}';

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
      throw Exception('Failed to fetch Terms of Service: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
