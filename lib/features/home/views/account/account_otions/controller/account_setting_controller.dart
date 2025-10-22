import 'dart:ui';

import 'package:electronic/core/switching_language_facilities/localization_service.dart';
import 'package:electronic/core/util/app_logger.dart';
import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AccountSettingController extends GetxController {
  final LocalizationService locService = Get.find<LocalizationService>();
   Future<void> changeLanguage(String languageCode) async {
    await locService.changeLanguage(languageCode);
    update(); // Update the UI
  }
  @override
  void onInit() {
    super.onInit();
    AppLogger.lifecycle('AccountSettingController', 'onInit');
  }

  @override
  void onClose() {
    AppLogger.lifecycle('AccountSettingController', 'onClose');
    super.onClose();
  }

  /// Navigate to Change Password screen
  void navigateToChangePassword() {
    AppLogger.navigation('AccountSettingView', 'ChangePasswordView');
    // Get.toNamed(Routes.changePassword);
    Get.snackbar(
      'info'.tr,
      'Navigate to Change Password',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Delete account
  void deleteAccount() {
    AppLogger.warning('Delete account requested', tag: 'AccountSetting');
    
    try {
      // TODO: Call API to delete account
      // await _accountService.deleteAccount();
      
      // Clear all data
      // final prefs = Get.find<SharedPreferences>();
      // await prefs.clear();
      
      AppLogger.success('Account deleted successfully', tag: 'AccountSetting');
      
      // Navigate to auth screen
      Get.offAllNamed(Routes.auth);
      
      Get.snackbar(
        'success'.tr,
        'account_deleted_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF09B782),
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete account',
        error: e,
        stackTrace: stackTrace,
        tag: 'AccountSetting',
      );
      
      Get.snackbar(
        'error'.tr,
        'failed_to_delete_account'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}