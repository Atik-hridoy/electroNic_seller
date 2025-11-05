// import 'dart:convert';
// import 'package:dio/dio.dart' as dio;
// import 'package:electronic/core/storage/storage_services.dart';
// import 'package:electronic/core/util/app_logger.dart';
// import 'package:get/get.dart';

// /// Stripe Service for handling payment-related API requests
// /// Supports both GET and POST requests with proper error handling
// class StripeService {
//   final dio.Dio _dio = Get.find<dio.Dio>();
  
//   // Stripe API configuration
//   static const String stripeApiVersion = '2023-10-16';
  
//   /// Make a GET request to Stripe API
//   /// 
//   /// [endpoint] - The Stripe API endpoint (e.g., '/v1/payment_intents')
//   /// [queryParameters] - Optional query parameters for the request
//   /// [useAuth] - Whether to include authorization token from local storage
//   /// [stripeSecretKey] - Optional Stripe secret key (if not using local auth)
//   /// 
//   /// Returns the response data as a Map
//   Future<Map<String, dynamic>?> get({
//     required String endpoint,
//     Map<String, dynamic>? queryParameters,
//     bool useAuth = true,
//     String? stripeSecretKey,
//   }) async {
//     const String tag = 'StripeService-GET';
    
//     try {
//       // Prepare headers
//       final headers = await _prepareHeaders(
//         useAuth: useAuth,
//         stripeSecretKey: stripeSecretKey,
//       );

//       // Log the request
//       AppLogger.apiRequest(
//         method: 'GET',
//         endpoint: endpoint,
//         headers: headers,
//         queryParams: queryParameters,
//       );

//       // Make the GET request
//       final response = await _dio.get(
//         endpoint,
//         queryParameters: queryParameters,
//         options: dio.Options(headers: headers),
//       );

//       // Log the response
//       AppLogger.apiResponse(
//         method: 'GET',
//         endpoint: endpoint,
//         statusCode: response.statusCode ?? 0,
//         responseData: response.data,
//       );

//       if (response.statusCode == 200) {
//         AppLogger.success('GET request successful', tag: tag);
//         return response.data is Map<String, dynamic> 
//             ? response.data 
//             : {'data': response.data};
//       } else {
//         final errorMsg = 'GET request failed: ${response.statusMessage}';
//         AppLogger.error(errorMsg, tag: tag);
//         throw Exception(errorMsg);
//       }
//     } on dio.DioException catch (e) {
//       return _handleDioError(e, 'GET', endpoint);
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Unexpected error in GET request: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Make a POST request to Stripe API
//   /// 
//   /// [endpoint] - The Stripe API endpoint (e.g., '/v1/payment_intents')
//   /// [data] - The request body data
//   /// [useAuth] - Whether to include authorization token from local storage
//   /// [stripeSecretKey] - Optional Stripe secret key (if not using local auth)
//   /// [useFormData] - Whether to send data as form-urlencoded (Stripe default)
//   /// 
//   /// Returns the response data as a Map
//   Future<Map<String, dynamic>?> post({
//     required String endpoint,
//     required Map<String, dynamic> data,
//     bool useAuth = true,
//     String? stripeSecretKey,
//     bool useFormData = true,
//   }) async {
//     const String tag = 'StripeService-POST';
    
//     try {
//       // Prepare headers
//       final headers = await _prepareHeaders(
//         useAuth: useAuth,
//         stripeSecretKey: stripeSecretKey,
//         isFormData: useFormData,
//       );

//       // Prepare request body
//       dynamic requestBody = data;
//       if (useFormData) {
//         // Convert to form-urlencoded format (Stripe's preferred format)
//         requestBody = dio.FormData.fromMap(data);
//       }

//       // Log the request
//       AppLogger.apiRequest(
//         method: 'POST',
//         endpoint: endpoint,
//         headers: headers,
//         body: data,
//       );

//       // Make the POST request
//       final response = await _dio.post(
//         endpoint,
//         data: requestBody,
//         options: dio.Options(headers: headers),
//       );

//       // Log the response
//       AppLogger.apiResponse(
//         method: 'POST',
//         endpoint: endpoint,
//         statusCode: response.statusCode ?? 0,
//         responseData: response.data,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         AppLogger.success('POST request successful', tag: tag);
//         return response.data is Map<String, dynamic> 
//             ? response.data 
//             : {'data': response.data};
//       } else {
//         final errorMsg = 'POST request failed: ${response.statusMessage}';
//         AppLogger.error(errorMsg, tag: tag);
//         throw Exception(errorMsg);
//       }
//     } on dio.DioException catch (e) {
//       return _handleDioError(e, 'POST', endpoint);
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Unexpected error in POST request: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Create a Payment Intent (common Stripe operation)
//   /// 
//   /// [amount] - Amount in cents (e.g., 1000 = $10.00)
//   /// [currency] - Currency code (e.g., 'usd', 'eur')
//   /// [metadata] - Optional metadata for the payment
//   /// [stripeSecretKey] - Your Stripe secret key
//   Future<Map<String, dynamic>?> createPaymentIntent({
//     required int amount,
//     required String currency,
//     Map<String, dynamic>? metadata,
//     required String stripeSecretKey,
//   }) async {
//     const String tag = 'StripeService-CreatePaymentIntent';
    
//     try {
//       final data = {
//         'amount': amount,
//         'currency': currency.toLowerCase(),
//         if (metadata != null) 'metadata': metadata,
//       };

//       AppLogger.debug('Creating payment intent: $data', tag: tag);

//       return await post(
//         endpoint: 'https://api.stripe.com/v1/payment_intents',
//         data: data,
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//         useFormData: true,
//       );
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Failed to create payment intent: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Retrieve a Payment Intent
//   /// 
//   /// [paymentIntentId] - The ID of the payment intent
//   /// [stripeSecretKey] - Your Stripe secret key
//   Future<Map<String, dynamic>?> retrievePaymentIntent({
//     required String paymentIntentId,
//     required String stripeSecretKey,
//   }) async {
//     const String tag = 'StripeService-RetrievePaymentIntent';
    
//     try {
//       AppLogger.debug('Retrieving payment intent: $paymentIntentId', tag: tag);

//       return await get(
//         endpoint: 'https://api.stripe.com/v1/payment_intents/$paymentIntentId',
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//       );
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Failed to retrieve payment intent: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Confirm a Payment Intent
//   /// 
//   /// [paymentIntentId] - The ID of the payment intent
//   /// [paymentMethodId] - The payment method ID
//   /// [stripeSecretKey] - Your Stripe secret key
//   Future<Map<String, dynamic>?> confirmPaymentIntent({
//     required String paymentIntentId,
//     required String paymentMethodId,
//     required String stripeSecretKey,
//   }) async {
//     const String tag = 'StripeService-ConfirmPaymentIntent';
    
//     try {
//       final data = {
//         'payment_method': paymentMethodId,
//       };

//       AppLogger.debug('Confirming payment intent: $paymentIntentId', tag: tag);

//       return await post(
//         endpoint: 'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm',
//         data: data,
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//         useFormData: true,
//       );
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Failed to confirm payment intent: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// List all Payment Intents
//   /// 
//   /// [limit] - Number of results to return (default: 10)
//   /// [stripeSecretKey] - Your Stripe secret key
//   Future<Map<String, dynamic>?> listPaymentIntents({
//     int limit = 10,
//     required String stripeSecretKey,
//   }) async {
//     const String tag = 'StripeService-ListPaymentIntents';
    
//     try {
//       AppLogger.debug('Listing payment intents (limit: $limit)', tag: tag);

//       return await get(
//         endpoint: 'https://api.stripe.com/v1/payment_intents',
//         queryParameters: {'limit': limit},
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//       );
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Failed to list payment intents: $e',
//         tag: tag,
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }

//   /// Prepare headers for Stripe API requests
//   Future<Map<String, String>> _prepareHeaders({
//     bool useAuth = true,
//     String? stripeSecretKey,
//     bool isFormData = false,
//   }) async {
//     final headers = <String, String>{
//       'Stripe-Version': stripeApiVersion,
//     };

//     // Add authorization
//     if (stripeSecretKey != null) {
//       // Use provided Stripe secret key
//       final credentials = base64Encode(utf8.encode('$stripeSecretKey:'));
//       headers['Authorization'] = 'Basic $credentials';
//     } else if (useAuth) {
//       // Use token from local storage
//       await LocalStorage.getAllPrefData();
//       if (LocalStorage.token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer ${LocalStorage.token}';
//       }
//     }

//     // Set content type
//     if (isFormData) {
//       headers['Content-Type'] = 'application/x-www-form-urlencoded';
//     } else {
//       headers['Content-Type'] = 'application/json';
//     }

//     return headers;
//   }

//   /// Handle Dio errors with proper logging
//   Map<String, dynamic>? _handleDioError(
//     dio.DioException e,
//     String method,
//     String endpoint,
//   ) {
//     const String tag = 'StripeService-Error';
    
//     if (e.response != null) {
//       final statusCode = e.response?.statusCode ?? 0;
//       final errorData = e.response?.data;
      
//       AppLogger.error(
//         'API Error ($method): $statusCode - ${e.response?.statusMessage}',
//         tag: tag,
//         error: e,
//         stackTrace: e.stackTrace,
//       );

//       // Extract Stripe error message if available
//       String errorMessage = 'API request failed';
//       if (errorData is Map && errorData.containsKey('error')) {
//         final error = errorData['error'];
//         if (error is Map && error.containsKey('message')) {
//           errorMessage = error['message'];
//         }
//       }

//       throw Exception('$method $endpoint failed: $errorMessage (Status: $statusCode)');
//     } else {
//       // Network error
//       final errorMsg = 'Network error: ${e.message}';
//       AppLogger.error(
//         errorMsg,
//         tag: tag,
//         error: e,
//         stackTrace: e.stackTrace,
//       );
//       throw Exception(errorMsg);
//     }
//   }
// }
