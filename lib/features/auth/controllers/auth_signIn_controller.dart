import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/core/util/app_logger.dart';
import '../services/auth_login_service.dart';

class AuthSignInController extends GetxController {
  // Initialize the service properly
  final AuthSignInService _authService = Get.put(AuthSignInService());
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final emailController = TextEditingController();
  final RxString userEmail = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Clear error message when user starts typing
  void clearError() {
    if (errorMessage.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  // Handle email submission (first step of login)
  Future<void> signIn({String? email}) async {
  // Use the provided email or fall back to the controller's text
  final userEmail = email ?? emailController.text.trim();
  
  if (userEmail.isEmpty) {
    errorMessage.value = 'Please enter your email';
    return;
  }

  if (!GetUtils.isEmail(userEmail)) {
    errorMessage.value = 'Please enter a valid email';
    return;
  }

  isLoading.value = true;
  errorMessage.value = '';

  try {
    AppLogger.debug('Initiating sign in for email: $userEmail', tag: 'AuthSignInController');
    
    final response = await _authService.signInUser(email: userEmail);
    AppLogger.debug('Sign in response: $response', tag: 'AuthSignInController');

    if (response['success'] == true) {
      // OTP sent successfully, navigate to OTP screen
      this.userEmail.value = userEmail;
      Get.offNamed(Routes.otp, arguments: {
          'email': email,
          'message': response['message'],
          'isLogin': true,
        });
    } else {
      errorMessage.value = response['message'] ?? 'Failed to send OTP. Please try again.';
      AppLogger.error('Sign in failed: ${errorMessage.value}', tag: 'AuthSignInController');
    }
  } catch (e, stackTrace) {
    errorMessage.value = 'An error occurred. Please try again.';
    AppLogger.error(
      'Unexpected error during sign in: $e',
      tag: 'AuthSignInController',
      error: e,
      stackTrace: stackTrace,
    );
  } finally {
    isLoading.value = false;
  }
}
}