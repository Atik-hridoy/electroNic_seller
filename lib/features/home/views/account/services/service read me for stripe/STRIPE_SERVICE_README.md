# Stripe Service Documentation

A comprehensive Stripe payment service for handling GET and POST requests to the Stripe API.

## Features

✅ **GET Requests** - Retrieve payment intents, customers, and other Stripe resources  
✅ **POST Requests** - Create payment intents, customers, and confirm payments  
✅ **Error Handling** - Comprehensive error handling with detailed logging  
✅ **Authentication** - Support for both Stripe secret keys and local auth tokens  
✅ **Form Data** - Automatic form-urlencoded formatting (Stripe's preferred format)  
✅ **Logging** - Detailed API request/response logging using AppLogger  

---

## Installation

The service is already created at:
```
lib/features/home/views/account/services/stripe_service.dart
```

No additional packages needed - uses existing `dio` package.

---

## Quick Start

### 1. Import the Service

```dart
import 'package:electronic/features/home/views/account/services/stripe_service.dart';
```

### 2. Initialize the Service

```dart
final stripeService = StripeService();
```

### 3. Set Your Stripe Secret Key

```dart
const String stripeSecretKey = 'sk_test_your_stripe_secret_key_here';
```

⚠️ **Security Note**: Never hardcode your secret key in production. Use environment variables or secure storage.

---

## Core Methods

### GET Request

```dart
Future<Map<String, dynamic>?> get({
  required String endpoint,
  Map<String, dynamic>? queryParameters,
  bool useAuth = true,
  String? stripeSecretKey,
})
```

**Parameters:**
- `endpoint` - The full Stripe API URL
- `queryParameters` - Optional query parameters
- `useAuth` - Use LocalStorage token (default: true)
- `stripeSecretKey` - Your Stripe secret key

**Example:**
```dart
final result = await stripeService.get(
  endpoint: 'https://api.stripe.com/v1/payment_intents/pi_123',
  useAuth: false,
  stripeSecretKey: stripeSecretKey,
);
```

---

### POST Request

```dart
Future<Map<String, dynamic>?> post({
  required String endpoint,
  required Map<String, dynamic> data,
  bool useAuth = true,
  String? stripeSecretKey,
  bool useFormData = true,
})
```

**Parameters:**
- `endpoint` - The full Stripe API URL
- `data` - Request body data
- `useAuth` - Use LocalStorage token (default: true)
- `stripeSecretKey` - Your Stripe secret key
- `useFormData` - Send as form-urlencoded (default: true)

**Example:**
```dart
final result = await stripeService.post(
  endpoint: 'https://api.stripe.com/v1/payment_intents',
  data: {
    'amount': 5000,
    'currency': 'usd',
  },
  useAuth: false,
  stripeSecretKey: stripeSecretKey,
);
```

---

## Helper Methods

### Create Payment Intent

```dart
Future<Map<String, dynamic>?> createPaymentIntent({
  required int amount,
  required String currency,
  Map<String, dynamic>? metadata,
  required String stripeSecretKey,
})
```

**Example:**
```dart
final result = await stripeService.createPaymentIntent(
  amount: 5000, // $50.00 in cents
  currency: 'usd',
  metadata: {
    'order_id': '12345',
    'customer_name': 'John Doe',
  },
  stripeSecretKey: stripeSecretKey,
);

print('Payment Intent ID: ${result?['id']}');
print('Client Secret: ${result?['client_secret']}');
```

---

### Retrieve Payment Intent

```dart
Future<Map<String, dynamic>?> retrievePaymentIntent({
  required String paymentIntentId,
  required String stripeSecretKey,
})
```

**Example:**
```dart
final result = await stripeService.retrievePaymentIntent(
  paymentIntentId: 'pi_1234567890',
  stripeSecretKey: stripeSecretKey,
);

print('Status: ${result?['status']}');
print('Amount: ${result?['amount']}');
```

---

### Confirm Payment Intent

```dart
Future<Map<String, dynamic>?> confirmPaymentIntent({
  required String paymentIntentId,
  required String paymentMethodId,
  required String stripeSecretKey,
})
```

**Example:**
```dart
final result = await stripeService.confirmPaymentIntent(
  paymentIntentId: 'pi_1234567890',
  paymentMethodId: 'pm_1234567890',
  stripeSecretKey: stripeSecretKey,
);

if (result?['status'] == 'succeeded') {
  print('Payment successful! 🎉');
}
```

---

### List Payment Intents

```dart
Future<Map<String, dynamic>?> listPaymentIntents({
  int limit = 10,
  required String stripeSecretKey,
})
```

**Example:**
```dart
final result = await stripeService.listPaymentIntents(
  limit: 20,
  stripeSecretKey: stripeSecretKey,
);

final paymentIntents = result?['data'] as List;
for (var intent in paymentIntents) {
  print('ID: ${intent['id']}, Amount: ${intent['amount']}');
}
```

---

## Complete Payment Flow Example

```dart
class PaymentController extends GetxController {
  final StripeService _stripeService = StripeService();
  final isLoading = false.obs;
  
  static const String stripeSecretKey = 'sk_test_your_key_here';

  Future<void> processPayment({
    required double amount,
    required String paymentMethodId,
  }) async {
    try {
      isLoading.value = true;

      // Step 1: Create payment intent
      final createResult = await _stripeService.createPaymentIntent(
        amount: (amount * 100).toInt(), // Convert to cents
        currency: 'usd',
        metadata: {
          'user_id': LocalStorage.userId,
          'timestamp': DateTime.now().toIso8601String(),
        },
        stripeSecretKey: stripeSecretKey,
      );

      if (createResult == null) {
        throw Exception('Failed to create payment intent');
      }

      final paymentIntentId = createResult['id'] as String;

      // Step 2: Confirm payment
      final confirmResult = await _stripeService.confirmPaymentIntent(
        paymentIntentId: paymentIntentId,
        paymentMethodId: paymentMethodId,
        stripeSecretKey: stripeSecretKey,
      );

      // Step 3: Handle result
      final status = confirmResult?['status'] as String?;
      
      if (status == 'succeeded') {
        Get.snackbar(
          'Success',
          'Payment of \$${amount.toStringAsFixed(2)} completed!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (status == 'requires_action') {
        Get.snackbar(
          'Action Required',
          'Please complete additional verification',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Payment failed with status: $status');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Payment failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## Using with Your Backend API

If you have your own backend that handles Stripe:

```dart
// Use local auth token instead of Stripe secret key
final result = await stripeService.post(
  endpoint: 'https://your-backend.com/api/create-payment',
  data: {
    'amount': 5000,
    'currency': 'usd',
    'customer_id': 'cus_123',
  },
  useAuth: true, // Uses LocalStorage.token
);
```

---

## Error Handling

The service automatically handles errors and provides detailed logging:

```dart
try {
  final result = await stripeService.createPaymentIntent(
    amount: 5000,
    currency: 'usd',
    stripeSecretKey: stripeSecretKey,
  );
  
  // Handle success
  if (result != null) {
    print('Success: ${result['id']}');
  }
} catch (e) {
  // Handle error
  print('Error: $e');
  
  // Show user-friendly message
  Get.snackbar('Error', 'Payment failed. Please try again.');
}
```

---

## Common Stripe Operations

### Create a Customer

```dart
final customer = await stripeService.post(
  endpoint: 'https://api.stripe.com/v1/customers',
  data: {
    'email': 'customer@example.com',
    'name': 'John Doe',
    'phone': '+1234567890',
  },
  stripeSecretKey: stripeSecretKey,
);

print('Customer ID: ${customer?['id']}');
```

### Create a Charge

```dart
final charge = await stripeService.post(
  endpoint: 'https://api.stripe.com/v1/charges',
  data: {
    'amount': 2000,
    'currency': 'usd',
    'source': 'tok_visa', // Token from Stripe.js
    'description': 'Charge for order #12345',
  },
  stripeSecretKey: stripeSecretKey,
);
```

### Refund a Payment

```dart
final refund = await stripeService.post(
  endpoint: 'https://api.stripe.com/v1/refunds',
  data: {
    'payment_intent': 'pi_1234567890',
    'amount': 1000, // Partial refund of $10.00
  },
  stripeSecretKey: stripeSecretKey,
);
```

---

## Testing

Use Stripe test keys and test card numbers:

**Test Secret Key:**
```
sk_test_51...
```

**Test Card Numbers:**
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`
- Requires Authentication: `4000 0025 0000 3155`

---

## Security Best Practices

1. ✅ **Never expose secret keys** in client-side code
2. ✅ **Use environment variables** for API keys
3. ✅ **Validate amounts** on the server side
4. ✅ **Use HTTPS** for all API calls
5. ✅ **Implement rate limiting** to prevent abuse
6. ✅ **Log all transactions** for audit trails

---

## Troubleshooting

### Error: "No authentication token found"

**Solution:** Make sure you're providing a `stripeSecretKey` or set `useAuth: false`

```dart
await stripeService.get(
  endpoint: 'https://api.stripe.com/v1/payment_intents',
  useAuth: false, // Don't use LocalStorage token
  stripeSecretKey: stripeSecretKey, // Use Stripe key instead
);
```

### Error: "Network error"

**Solution:** Check your internet connection and ensure the endpoint URL is correct

### Error: "Invalid API key"

**Solution:** Verify your Stripe secret key is correct and not expired

---

## API Reference

For complete Stripe API documentation, visit:
https://stripe.com/docs/api

---

## Support

For issues or questions about this service:
1. Check the example file: `stripe_service_example.dart`
2. Review Stripe API documentation
3. Check AppLogger output for detailed error messages

---

## Version

- **Version:** 1.0.0
- **Last Updated:** November 2024
- **Stripe API Version:** 2023-10-16
