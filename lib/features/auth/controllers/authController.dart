// authController.dart
import 'package:electronic/core/util/app_logger.dart';
import 'package:electronic/routes/app_pages.dart';
import 'package:get/get.dart';
import '../services/auth_create_user_service.dart';

class AuthController extends GetxController {
  final AuthCreateUserService _authService = Get.put(AuthCreateUserService());
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Register user
  Future<void> registerUser(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.registerSeller(email: email);

      if (response['success'] == true) {
        // Navigate to OTP verification screen
        Get.offNamed(Routes.otp, arguments: {
          'email': email,
          'message': response['message'],
        });
      } else {
        errorMessage.value = response['message'] ?? 'Registration failed';
        AppLogger.error(
          'Registration failed: ${response['message']}',
          tag: 'Auth',
        );
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'An error occurred. Please try again.';
      AppLogger.error(
        'Registration error',
        tag: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }
}