import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalizationService extends GetxService {
  static LocalizationService get to => Get.find();
  final RxString currentLanguage = AppConstants.defaultLanguage.obs;

  Future<LocalizationService> init() async {
    // Load saved language from shared preferences
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(AppConstants.languageKey);
    if (languageCode != null && AppConstants.supportedLocales.contains(languageCode)) {
      currentLanguage.value = languageCode;
    }
    return this;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!AppConstants.supportedLocales.contains(languageCode)) return;
    
    // Update current language
    currentLanguage.value = languageCode;
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, languageCode);
    
    // Update app locale
    await Get.updateLocale(Locale(languageCode));
  }

  Locale getCurrentLocale() {
    return Locale(currentLanguage.value);
  }

  bool isCurrentLanguage(String languageCode) {
    return currentLanguage.value == languageCode;
  }
}
