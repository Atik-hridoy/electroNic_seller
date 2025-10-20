import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:electronic/core/switching_language_facilities/localization_service.dart';
import '../controller/account_setting_controller.dart';

class AccountSettingView extends GetView<AccountSettingController> {
  const AccountSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'account_setting'.tr,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Text
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              color: Colors.white,
              child: Text(
                'account_setting_description'.tr,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9E9E9E),
                  height: 1.6,
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Language Option
            InkWell(
              onTap: _showLanguageDialog,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 24.sp,
                      color: const Color(0xFF424242),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'language'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ),
                    Obx(() {
                      final locService = Get.find<LocalizationService>();
                      return Text(
                        locService.currentLanguage.value == 'en' 
                            ? 'english'.tr 
                            : 'spanish'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      );
                    }),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
            
            // Divider
            Divider(
              height: 1.h,
              thickness: 1,
              color: const Color(0xFFE0E0E0),
              indent: 60.w,
            ),
            
            // Change Password Option
            InkWell(
              onTap: controller.navigateToChangePassword,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 24.sp,
                      color: const Color(0xFF424242),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'change_password'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
            
            // Divider
            Divider(
              height: 1.h,
              thickness: 1,
              color: const Color(0xFFE0E0E0),
              indent: 60.w,
            ),
            
            // Delete Account Option
            InkWell(
              onTap: _showDeleteAccountDialog,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 24.sp,
                      color: Colors.red,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'delete_account'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final locService = Get.find<LocalizationService>();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select_language'.tr,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              
              // English Option
              Obx(() => InkWell(
                onTap: () {
                  if (locService.currentLanguage.value != 'en') {
                    controller.changeLanguage('en');
                    Get.back();
                    _showLanguageUpdatedSnackbar();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: locService.currentLanguage.value == 'en' 
                        ? const Color(0xFFE6F8F3) 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: locService.currentLanguage.value == 'en'
                          ? const Color(0xFF09B782)
                          : const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'en',
                        groupValue: locService.currentLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                            Get.back();
                            _showLanguageUpdatedSnackbar();
                          }
                        },
                        activeColor: const Color(0xFF09B782),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'english'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              
              SizedBox(height: 12.h),
              
              // Spanish Option
              Obx(() => InkWell(
                onTap: () {
                  if (locService.currentLanguage.value != 'es') {
                    controller.changeLanguage('es');
                    Get.back();
                    _showLanguageUpdatedSnackbar();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: locService.currentLanguage.value == 'es' 
                        ? const Color(0xFFE6F8F3) 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: locService.currentLanguage.value == 'es'
                          ? const Color(0xFF09B782)
                          : const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'es',
                        groupValue: locService.currentLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                            Get.back();
                            _showLanguageUpdatedSnackbar();
                          }
                        },
                        activeColor: const Color(0xFF09B782),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'spanish'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              
              SizedBox(height: 24.h),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09B782),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'close'.tr,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('delete_account_confirmation'.tr),
        content: Text('delete_account_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              // Handle account deletion
              Get.back();
              // Show success message
              Get.snackbar(
                'account_deleted'.tr,
                'account_deleted_message'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
              // Navigate to login or home screen
              // Get.offAllNamed(Routes.LOGIN);
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageUpdatedSnackbar() {
    Get.snackbar(
      'language_updated'.tr,
      'language_updated_message'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF09B782).withOpacity(0.9),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 8.r,
    );
  }
}