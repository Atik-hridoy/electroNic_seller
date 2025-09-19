// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class ApiService {
//   late final Dio _dio;

//   ApiService() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://api.electronicseller.com/v1',
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         sendTimeout: const Duration(seconds: 30),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );

//     // Add interceptors
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           // Add auth token if available
//           // final token = LocalStorageService().getToken();
//           // if (token != null) {
//           //   options.headers['Authorization'] = 'Bearer $token';
//           // }
          
//           if (kDebugMode) {
//             print('Request: ${options.method} ${options.path}');
//             print('Headers: ${options.headers}');
//             if (options.data != null) {
//               print('Body: ${options.data}');
//             }
//           }
          
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           if (kDebugMode) {
//             print('Response: ${response.statusCode} ${response.statusMessage}');
//             print('Data: ${response.data}');
//           }
//           return handler.next(response);
//         },
//         onError: (DioException error, handler) {
//           if (kDebugMode) {
//             print('Error: ${error.message}');
//             print('Error Type: ${error.type}');
//             if (error.response != null) {
//               print('Error Response: ${error.response?.data}');
//             }
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   // GET request
//   Future<Response> get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.get(
//         path,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // POST request
//   Future<Response> post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.post(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // PUT request
//   Future<Response> put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.put(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // DELETE request
//   Future<Response> delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.delete(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // PATCH request
//   Future<Response> patch(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       return await _dio.patch(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Error handling
//   dynamic _handleError(DioException error) {
//     if (error.response != null) {
//       final statusCode = error.response!.statusCode;
//       final data = error.response!.data;
      
//       switch (statusCode) {
//         case 400:
//           throw BadRequestException(data['message'] ?? 'Bad Request');
//         case 401:
//           throw UnauthorizedException(data['message'] ?? 'Unauthorized');
//         case 403:
//           throw ForbiddenException(data['message'] ?? 'Forbidden');
//         case 404:
//           throw NotFoundException(data['message'] ?? 'Not Found');
//         case 500:
//           throw InternalServerErrorException(data['message'] ?? 'Internal Server Error');
//         default:
//           throw ApiException(
//             data['message'] ?? 'An error occurred',
//             statusCode!,
//           );
//       }
//     } else {
//       switch (error.type) {
//         case DioExceptionType.connectionTimeout:
//         case DioExceptionType.sendTimeout:
//         case DioExceptionType.receiveTimeout:
//           throw TimeoutException('Connection timeout. Please try again.');
//         case DioExceptionType.connectionError:
//           throw NetworkException('No internet connection. Please check your network.');
//         default:
//           throw ApiException('An unexpected error occurred', 0);
//       }
//     }
//   }
// }

// // Custom Exceptions
// class ApiException implements Exception {
//   final String message;
//   final int statusCode;

//   ApiException(this.message, this.statusCode);

//   @override
//   String toString() => 'ApiException: $message (Status: $statusCode)';
// }

// class BadRequestException extends ApiException {
//   BadRequestException([String? message]) : super(message ?? 'Bad Request', 400);
// }

// class UnauthorizedException extends ApiException {
//   UnauthorizedException([String? message]) : super(message ?? 'Unauthorized', 401);
// }

// class ForbiddenException extends ApiException {
//   ForbiddenException([String? message]) : super(message ?? 'Forbidden', 403);
// }

// class NotFoundException extends ApiException {
//   NotFoundException([String? message]) : super(message ?? 'Not Found', 404);
// }

// class InternalServerErrorException extends ApiException {
//   InternalServerErrorException([String? message]) : super(message ?? 'Internal Server Error', 500);
// }

// class TimeoutException extends ApiException {
//   TimeoutException([String? message]) : super(message ?? 'Timeout', 408);
// }

// class NetworkException extends ApiException {
//   NetworkException([String? message]) : super(message ?? 'Network Error', 0);
// }