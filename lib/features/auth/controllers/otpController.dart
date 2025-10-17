import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../services/auth_verify_otp_service.dart';
import '../services/auth_service.dart';
import '../../../core/util/app_logger.dart';

class OtpController extends GetxController {
  // 5 OTP digit controllers
  final List<TextEditingController> otpControllers = List.generate(
    5, // Changed from 6 to 5
    (index) => TextEditingController(),
  );

  final int resendTimeout = 30; // seconds
  final remainingTime = 0.obs;
  final canResend = false.obs;
  Timer? _timer;

  // Loading and error states
  final AuthService _authService = Get.put(AuthService());
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late AuthVerifyOtpService _otpService;

  @override
  void onInit() {
    super.onInit();
    _otpService = Get.find<AuthVerifyOtpService>();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // Handle OTP input changes
  void onOtpChange(int index, String value, BuildContext context) {
    if (value.length == 1 && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  // Start the countdown timer
  void startTimer() {
    canResend.value = false;
    remainingTime.value = resendTimeout;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 1) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Resend OTP
  void resendOtp(String email) async {
    if (!canResend.value) return;

    try {
      startTimer();
      // TODO: Call your resend OTP endpoint here if needed
      Get.snackbar(
        'Success',
        'OTP sent successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Resend OTP error',
        error: e,
        stackTrace: stackTrace,
        tag: 'OtpController',
      );
      Get.snackbar(
        'Error',
        'Failed to resend OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String email) async {
    final otp = otpControllers.map((controller) => controller.text).join();
    
    AppLogger.info(
      'Starting OTP verification - email: $email, otp_length: ${otp.length}, is_otp_valid: ${otp.length == 5}',
      tag: 'OtpController',
    );

    if (otp.length != 5) {
      final errorMsg = 'Invalid OTP length: ${otp.length}. Expected 5 digits';
      errorMessage.value = errorMsg;
      
      AppLogger.error(
        errorMsg,
        tag: 'OtpController.verifyOtp',
      );
      
      Get.snackbar(
        'Error',
        'Please enter a valid 5-digit OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.debug(
        'Initiating OTP verification API call - email: $email, otp: $otp',
        tag: 'OtpController',
      );

      final stopwatch = Stopwatch()..start();
      final response = await _otpService.verifyOtp(
        email: email,
        oneTimeCode: int.parse(otp),
      );
      stopwatch.stop();

      AppLogger.info(
        'OTP verification API response received in ${stopwatch.elapsedMilliseconds}ms - Success: ${response['success']}',
        tag: 'OtpController.verifyOtp',
      );

      if (response['success'] == true) {
        final accessToken = response['data']?['accessToken']?.toString() ?? '';
        final refreshToken = response['data']?['refreshToken']?.toString() ?? '';
        
        if (accessToken.isNotEmpty) {
          try {
            // Use AuthService to handle login and token storage
            await _authService.login(
              accessToken,
              refreshToken: refreshToken,
            );
            
            AppLogger.success(
              'User authentication successful. Access Token: ${accessToken.substring(0, 10)}..., Refresh Token: ${refreshToken.isNotEmpty ? refreshToken.substring(0, 10) + '...' : 'Not provided'}',
              tag: 'OtpController.verifyOtp',
            );
            
            // Navigate to profile info page
            Get.offAllNamed(Routes.profileInfo);
            
          } catch (e) {
            AppLogger.error(
              'Error during authentication: $e',
              tag: 'OtpController.verifyOtp',
              error: e,
            );
            
            Get.snackbar(
              'Success',
              'Verification successful, but there was an issue with your session',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            Get.offAllNamed(Routes.profileInfo);
          }
        } else {
          AppLogger.warning(
            'Authentication successful but no access token received in response',
            tag: 'OtpController.verifyOtp',
          );
          
          // Still navigate but log the issue
          Get.offAllNamed(Routes.home);
        }
      } else {
        final errorMsg = response['message'] ?? 'OTP verification failed';
        errorMessage.value = errorMsg;
        
        AppLogger.error(
          errorMsg,
          tag: 'OtpController.verifyOtp',
        );
        
        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final errorMsg = 'An error occurred during OTP verification: $e';
      errorMessage.value = errorMsg;
      
      AppLogger.error(
        errorMsg,
        tag: 'OtpController.verifyOtp',
        error: e,
      );
      
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      AppLogger.debug(
        'OTP verification process completed for $email - Status: ${errorMessage.value.isEmpty ? 'success' : 'failed'}',
        tag: 'OtpController.verifyOtp',
      );
    }
  }
}