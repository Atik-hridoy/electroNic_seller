import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otpController.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final String email = Get.arguments?['email'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Column(
        children: [
          // Top Section with Image - 35% of screen height
          Container(
            width: double.infinity,
            height: screenHeight * 0.35,
            color: const Color(0xFFE6F8F3),
            padding: EdgeInsets.only(top: screenHeight * 0.05),
            child: Center(
              child: Image.asset(
                'assets/auth/auth1.png',
                width: screenWidth * 0.8,
                height: screenHeight * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bottom Section - 65% of screen height
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08, vertical: screenHeight * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/Group 290580.png',
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.12,
                    fit: BoxFit.contain,
                  ),

                  // Title and Subtitle
                  Column(
                    children: [
                      Text(
                        'enter_otp'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color(0xFF09B782),
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'otp_instruction'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color(0xFF606060),
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // OTP Input Fields
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: screenWidth * 0.14,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: controller.otpControllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            onChanged: (value) => controller
                                .onOtpChange(index, value, context),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Color(0xFFE6E6E6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Resend OTP
                  Obx(
                    () => GestureDetector(
                      onTap: (controller.canResend.value && !controller.isLoading.value)
                          ? () => controller.resendOtp()
                          : null,
                      child: controller.isLoading.value && controller.canResend.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.04,
                                  height: screenWidth * 0.04,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF09B782),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'sending'.tr,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: const Color(0xFF09B782),
                                    fontSize: screenHeight * 0.018,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              controller.canResend.value
                                  ? 'resend_code'.tr
                                  : 'resend_timer'.trParams({
                                      'minutes': (controller
                                                  .secondsRemaining.value ~/
                                              60)
                                          .toString()
                                          .padLeft(2, '0'),
                                      'seconds': (controller
                                                  .secondsRemaining.value %
                                              60)
                                          .toString()
                                          .padLeft(2, '0'),
                                    }),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: (controller.canResend.value && !controller.isLoading.value)
                                    ? const Color(0xFF09B782)
                                    : const Color(0xFF9E9E9E),
                                fontSize: screenHeight * 0.018,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),

                  // Verify Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller
                                    .verifyOtp()
                                    .catchError((_) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to verify OTP. Please try again.',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09B782),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'verify'.tr,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: screenHeight * 0.02,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
