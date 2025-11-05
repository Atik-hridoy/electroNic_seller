// // ============================================================================
// // Stripe Service Usage Examples
// // ============================================================================

// import 'package:electronic/features/home/views/account/services/stripe_service.dart';

// /// Example class demonstrating how to use StripeService
// class StripeServiceExamples {
//   final StripeService _stripeService = StripeService();
  
//   // Your Stripe secret key (keep this secure!)
//   static const String stripeSecretKey = 'sk_test_your_stripe_secret_key_here';

//   // ========== EXAMPLE 1: Create a Payment Intent ==========
//   /// Creates a payment intent for $50.00 USD
//   Future<void> exampleCreatePaymentIntent() async {
//     try {
//       final result = await _stripeService.createPaymentIntent(
//         amount: 5000, // Amount in cents ($50.00)
//         currency: 'usd',
//         metadata: {
//           'order_id': '12345',
//           'customer_name': 'John Doe',
//         },
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null) {
//         print('Payment Intent Created!');
//         print('ID: ${result['id']}');
//         print('Client Secret: ${result['client_secret']}');
//         print('Amount: ${result['amount']}');
//         print('Status: ${result['status']}');
//       }
//     } catch (e) {
//       print('Error creating payment intent: $e');
//     }
//   }

//   // ========== EXAMPLE 2: Retrieve a Payment Intent ==========
//   /// Retrieves an existing payment intent by ID
//   Future<void> exampleRetrievePaymentIntent(String paymentIntentId) async {
//     try {
//       final result = await _stripeService.retrievePaymentIntent(
//         paymentIntentId: paymentIntentId,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null) {
//         print('Payment Intent Retrieved!');
//         print('ID: ${result['id']}');
//         print('Status: ${result['status']}');
//         print('Amount: ${result['amount']}');
//       }
//     } catch (e) {
//       print('Error retrieving payment intent: $e');
//     }
//   }

//   // ========== EXAMPLE 3: Confirm a Payment Intent ==========
//   /// Confirms a payment intent with a payment method
//   Future<void> exampleConfirmPaymentIntent(
//     String paymentIntentId,
//     String paymentMethodId,
//   ) async {
//     try {
//       final result = await _stripeService.confirmPaymentIntent(
//         paymentIntentId: paymentIntentId,
//         paymentMethodId: paymentMethodId,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null) {
//         print('Payment Intent Confirmed!');
//         print('Status: ${result['status']}');
//         if (result['status'] == 'succeeded') {
//           print('Payment successful! 🎉');
//         }
//       }
//     } catch (e) {
//       print('Error confirming payment intent: $e');
//     }
//   }

//   // ========== EXAMPLE 4: List Payment Intents ==========
//   /// Lists the most recent payment intents
//   Future<void> exampleListPaymentIntents() async {
//     try {
//       final result = await _stripeService.listPaymentIntents(
//         limit: 10,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null && result['data'] != null) {
//         final paymentIntents = result['data'] as List;
//         print('Found ${paymentIntents.length} payment intents:');
        
//         for (var intent in paymentIntents) {
//           print('- ID: ${intent['id']}, Amount: ${intent['amount']}, Status: ${intent['status']}');
//         }
//       }
//     } catch (e) {
//       print('Error listing payment intents: $e');
//     }
//   }

//   // ========== EXAMPLE 5: Custom GET Request ==========
//   /// Makes a custom GET request to any Stripe endpoint
//   Future<void> exampleCustomGetRequest() async {
//     try {
//       final result = await _stripeService.get(
//         endpoint: 'https://api.stripe.com/v1/customers',
//         queryParameters: {
//           'limit': 5,
//         },
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null) {
//         print('Custom GET request successful!');
//         print('Response: $result');
//       }
//     } catch (e) {
//       print('Error in custom GET request: $e');
//     }
//   }

//   // ========== EXAMPLE 6: Custom POST Request ==========
//   /// Makes a custom POST request to create a customer
//   Future<void> exampleCustomPostRequest() async {
//     try {
//       final result = await _stripeService.post(
//         endpoint: 'https://api.stripe.com/v1/customers',
//         data: {
//           'email': 'customer@example.com',
//           'name': 'John Doe',
//           'description': 'New customer from mobile app',
//         },
//         useAuth: false,
//         stripeSecretKey: stripeSecretKey,
//         useFormData: true, // Stripe prefers form-urlencoded
//       );

//       if (result != null) {
//         print('Customer created!');
//         print('Customer ID: ${result['id']}');
//         print('Email: ${result['email']}');
//       }
//     } catch (e) {
//       print('Error creating customer: $e');
//     }
//   }

//   // ========== EXAMPLE 7: Using with Local Auth Token ==========
//   /// Makes a request using the auth token from LocalStorage
//   Future<void> exampleWithLocalAuth() async {
//     try {
//       // This will use the token from LocalStorage.token
//       final result = await _stripeService.get(
//         endpoint: 'https://your-backend-api.com/api/payments',
//         useAuth: true, // Uses LocalStorage.token
//       );

//       if (result != null) {
//         print('Request with local auth successful!');
//         print('Response: $result');
//       }
//     } catch (e) {
//       print('Error with local auth request: $e');
//     }
//   }

//   // ========== EXAMPLE 8: Complete Payment Flow ==========
//   /// Complete payment flow from creation to confirmation
//   Future<void> exampleCompletePaymentFlow({
//     required int amount,
//     required String currency,
//     required String paymentMethodId,
//   }) async {
//     try {
//       // Step 1: Create payment intent
//       print('Step 1: Creating payment intent...');
//       final createResult = await _stripeService.createPaymentIntent(
//         amount: amount,
//         currency: currency,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (createResult == null) {
//         throw Exception('Failed to create payment intent');
//       }

//       final paymentIntentId = createResult['id'] as String;
//       print('✓ Payment intent created: $paymentIntentId');

//       // Step 2: Confirm payment intent
//       print('Step 2: Confirming payment...');
//       final confirmResult = await _stripeService.confirmPaymentIntent(
//         paymentIntentId: paymentIntentId,
//         paymentMethodId: paymentMethodId,
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (confirmResult == null) {
//         throw Exception('Failed to confirm payment');
//       }

//       // Step 3: Check payment status
//       final status = confirmResult['status'] as String;
//       print('✓ Payment status: $status');

//       if (status == 'succeeded') {
//         print('🎉 Payment successful!');
//         print('Amount charged: \$${amount / 100}');
//       } else if (status == 'requires_action') {
//         print('⚠️ Payment requires additional action');
//       } else {
//         print('❌ Payment failed or incomplete');
//       }
//     } catch (e) {
//       print('Error in payment flow: $e');
//     }
//   }
// }

// // ============================================================================
// // HOW TO USE IN YOUR CONTROLLER
// // ============================================================================

// /*

// import 'package:electronic/features/home/views/account/services/stripe_service.dart';
// import 'package:get/get.dart';

// class PaymentController extends GetxController {
//   final StripeService _stripeService = StripeService();
//   final isLoading = false.obs;
  
//   // Your Stripe secret key (store securely, preferably in environment variables)
//   static const String stripeSecretKey = 'sk_test_your_key_here';

//   Future<void> processPayment({
//     required double amount,
//     required String paymentMethodId,
//   }) async {
//     try {
//       isLoading.value = true;

//       // Convert amount to cents
//       final amountInCents = (amount * 100).toInt();

//       // Create payment intent
//       final result = await _stripeService.createPaymentIntent(
//         amount: amountInCents,
//         currency: 'usd',
//         metadata: {
//           'user_id': 'user_123',
//           'order_id': 'order_456',
//         },
//         stripeSecretKey: stripeSecretKey,
//       );

//       if (result != null) {
//         final paymentIntentId = result['id'] as String;
        
//         // Confirm payment
//         final confirmResult = await _stripeService.confirmPaymentIntent(
//           paymentIntentId: paymentIntentId,
//           paymentMethodId: paymentMethodId,
//           stripeSecretKey: stripeSecretKey,
//         );

//         if (confirmResult?['status'] == 'succeeded') {
//           Get.snackbar('Success', 'Payment completed successfully!');
//         } else {
//           Get.snackbar('Error', 'Payment failed');
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Payment error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// */
