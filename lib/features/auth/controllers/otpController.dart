import 'dart:async';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/storage/storage_keys.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../services/auth_verify_otp_service.dart';
import '../../../core/util/app_logger.dart';
import 'package:flutter/material.dart';

class OtpController extends GetxController {
  // OTP digit controllers
  final List<TextEditingController> otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  final RxInt secondsRemaining = 60.obs;
  final RxBool canResend = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  late final String email;
  late final bool isLoginFlow;
  late final AuthVerifyOtpService _otpService;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _otpService = Get.find<AuthVerifyOtpService>();
    
    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? '';
    isLoginFlow = args?['isLogin'] ?? true;
    
    startTimer();
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.onClose();
  }

  void onOtpChange(int index, String value, BuildContext context) {
    // Move to next field when a digit is entered
    if (value.isNotEmpty && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    }
    // Move to previous field when backspace is pressed on an empty field
    else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
  try {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length != 5) {
      errorMessage.value = 'Please enter a valid 5-digit OTP';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _otpService.verifyOtp(
        email: email,
        oneTimeCode: int.tryParse(otp) ?? 0,
      );

      if (response['success'] == true) {
        final accessToken = response['accessToken'] ?? response['data']?['accessToken'];
        final refreshToken = response['refreshToken'] ?? response['data']?['refreshToken'];
        
        if (accessToken == null || refreshToken == null) {
          throw Exception('Tokens not found in response');
        }

        // Save tokens to persistent storage
        await LocalStorage.setString(LocalStorageKeys.token, accessToken);
        await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
        
        // Also update the static variables
        LocalStorage.token = accessToken;
        LocalStorage.refreshToken = refreshToken;
        LocalStorage.isLogIn = true;

        // Add logging to verify flow
        AppLogger.info('OTP Flow Type: ${isLoginFlow ? "Login" : "Registration"}', 
                  tag: 'OtpController');
        
        // Navigate based on flow
        if (isLoginFlow) {
          AppLogger.info('Navigating to Home', tag: 'OtpController');
          Get.offAllNamed(Routes.home);
        } else {
          AppLogger.info('Navigating to Profile Info', tag: 'OtpController');
          Get.offAllNamed(
            Routes.profileInfo,
            arguments: {
              'email': email,
              'accessToken': accessToken,
            },
          );
        }
      } else {
        errorMessage.value = response['message'] ?? 'OTP verification failed';
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'An error occurred. Please try again.';
      AppLogger.error('OTP Verification Error: $e', 
                    tag: 'OtpController',
                    stackTrace: stackTrace);
    }
  } finally {
    isLoading.value = false;
  }
}

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Call your resend OTP API here
      // final response = await _otpService.resendOtp(email: email);
      
      // Reset timer
      secondsRemaining.value = 60;
      canResend.value = false;
      startTimer();
      
      Get.snackbar('Success', 'New OTP sent to your email');
    } catch (e) {
      errorMessage.value = 'Failed to resend OTP. Please try again.';
      AppLogger.error('Resend OTP Error: $e', tag: 'OtpController');
    } finally {
      isLoading.value = false;
    }
  }
}