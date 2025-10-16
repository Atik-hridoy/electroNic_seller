import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routes/app_pages.dart';
import '../controllers/authController.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize screen util for this build context
    ScreenUtil.init(context, designSize: const Size(375, 812));
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
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
                    
                    // Bottom Section with Form
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),
                              Image.asset(
                                'assets/images/Group 290580.png',
                                width: 95.w,
                                height: 128.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xFF09B782),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  'Please Confirm your Mobile Phone Verification',
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
                              Container(
                                width: double.infinity,
                                height: 52.h,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1.h,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your Phone No.',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: const Color(0xFF9E9E9E),
                                      fontSize: 16.sp,
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 8.h),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              SizedBox(height: 40.h),
                              SizedBox(
                                width: double.infinity,
                                height: 48.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.otp);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF09B782),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
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