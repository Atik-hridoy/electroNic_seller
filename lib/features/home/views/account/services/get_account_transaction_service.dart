import 'package:dio/dio.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import 'package:get/get.dart';

class GetAccountTransactionService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'GetAccountTransactionService';

  // Check account status
  Future<Map<String, dynamic>> getAccountStatus() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.getAccountStatus}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        
        AppLogger.success('Account status checked successfully', tag: _tag);
        return {};
      } else {
        final errorMsg = 'Failed to check account status: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check account status: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to check account status: $e');
    }
  }

  // Create Stripe Connect account
  Future<Map<String, dynamic>> createConnectAccount() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.createConnectAccount}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'POST',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.post(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'POST',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        AppLogger.success('Connect account created successfully', tag: _tag);
        
        // Extract the URL from response
        if (data is Map) {
          // Check for URL in various possible locations
          String? url;
          
          if (data['data'] != null && data['data'] is Map) {
            url = data['data']['url'] ?? data['data']['accountLink'] ?? data['data']['onboardingUrl'];
          } else {
            url = data['url'] ?? data['accountLink'] ?? data['onboardingUrl'] ?? data['link'];
          }
          
          if (url != null) {
            return {
              'success': true,
              'url': url,
              'data': data,
            };
          }
          
          return {
            'success': true,
            'data': data,
          };
        }
        
        return {'success': true};
      } else {
        final errorMsg = 'Failed to create connect account: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create connect account: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to create connect account: $e');
    }
  }

  // Get account onboarding link
  Future<Map<String, dynamic>> getAccountLink() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.getAccountLink}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        
        AppLogger.success('Account link retrieved successfully', tag: _tag);
        return {};
      } else {
        final errorMsg = 'Failed to get account link: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get account link: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to get account link: $e');
    }
  }

  // Get login link to Stripe Dashboard
  Future<Map<String, dynamic>> getLoginLink() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.getLoginLink}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        
        AppLogger.success('Login link retrieved successfully', tag: _tag);
        return {};
      } else {
        final errorMsg = 'Failed to get login link: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get login link: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to get login link: $e');
    }
  }

  // Get account information
  Future<Map<String, dynamic>> getAccountInfo() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.getAccountInfo}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        
        AppLogger.success('Account info loaded successfully', tag: _tag);
        return {};
      } else {
        final errorMsg = 'Failed to load account info: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load account info: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to load account info: $e');
    }
  }

  // Get transaction history
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      final url = '${AppUrls.baseUrl}${AppUrls.getTransactions}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<Map<String, dynamic>> transactionList = [];

        if (data is Map && data['data'] != null) {
          final transactionData = data['data'];
          if (transactionData is List) {
            transactionList = transactionData.map((item) => item as Map<String, dynamic>).toList();
          }
        } else if (data is List) {
          transactionList = data.map((item) => item as Map<String, dynamic>).toList();
        }

        AppLogger.success('Transactions loaded successfully: ${transactionList.length} items', tag: _tag);
        return transactionList;
      } else {
        final errorMsg = 'Failed to load transactions: ${response.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: Exception(errorMsg));
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(errorMsg, tag: _tag, error: e, stackTrace: e.stackTrace);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load transactions: $e', tag: _tag, error: e, stackTrace: stackTrace);
      throw Exception('Failed to load transactions: $e');
    }
  }
}
