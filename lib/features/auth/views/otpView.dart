import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/otpController.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    final String email = Get.arguments?['email'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Top Section with Image
                    Container(
                      width: double.infinity,
                      height: 300.h,
                      color: const Color(0xFFE6F8F3),
                      child: Center(
                        child: Image.asset(
                          'assets/auth/auth1.png',
                          width: 300.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Bottom Section
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 40.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(5),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Logo
                            Image.asset(
                              'assets/images/Group 290580.png',
                              width: 95.w,
                              height: 128.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 16.h),

                            // Title
                            Text(
                              'enter_otp'.tr,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xFF09B782),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Subtitle
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'otp_instruction'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xFF606060),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 40.h),

                            // OTP Input Fields
                            Form(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  5,
                                  (index) => Container(
                                    width: 55.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6E6E6),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: const Color(0xFFE0E0E0),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.otpControllers[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      onChanged: (value) => controller
                                          .onOtpChange(index, value, context),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        fillColor: const Color(0xFFE6E6E6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Resend OTP
                            Obx(
                              () => GestureDetector(
                                onTap: controller.canResend.value
                                    ? () => controller.resendOtp()
                                    : null,
                                child: Text(
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
                                    color: controller.canResend.value
                                        ? const Color(0xFF09B782)
                                        : const Color(0xFF9E9E9E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 40.h),

                            // Verify Button
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 50.h,
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
                                      borderRadius: BorderRadius.circular(8.r),
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
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
