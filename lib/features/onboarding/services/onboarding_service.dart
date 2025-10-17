import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/storage/storage_keys.dart';

class OnboardingService {
  final SharedPreferences _prefs;

  OnboardingService(SharedPreferences prefs) : _prefs = prefs;

  // Check if onboarding should be shown
  Future<bool> shouldShowOnboarding() async {
    return _prefs.getBool(LocalStorageKeys.isFirstLaunch) ?? true;
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _prefs.setBool(LocalStorageKeys.isFirstLaunch, false);
  }

  // Get onboarding completion status
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(LocalStorageKeys.isFirstLaunch) ?? false;
  }

  // Reset onboarding (for testing/debugging)
  Future<void> resetOnboarding() async {
    await _prefs.setBool(LocalStorageKeys.isFirstLaunch, true);
  }

  // Get onboarding data
  Future<List<Map<String, dynamic>>> getOnboardingData() async {
    // This could be fetched from backend in a real app
    return [
      {
        'title': 'Welcome to Electronic Seller',
        'description': 'Find the best electronic products at great prices with our easy-to-use app.',
        'image': 'assets/images/onboarding1.png',
        'icon': Icons.shopping_cart,
      },
      {
        'title': 'Discover Amazing Products',
        'description': 'Browse thousands of products from trusted brands and sellers.',
        'image': 'assets/images/onboarding2.png',
        'icon': Icons.search,
      },
      {
        'title': 'Fast & Secure Shopping',
        'description': 'Enjoy secure payments and fast delivery right to your doorstep.',
        'image': 'assets/images/onboarding3.png',
        'icon': Icons.local_shipping,
      },
    ];
  }

  // Track onboarding progress
  Future<void> trackOnboardingProgress(int pageIndex) async {
    // Could be used for analytics
    print('User viewed onboarding page $pageIndex');
  }

  // Get user preferences from onboarding
  Future<Map<String, dynamic>> getUserPreferences() async {
    // This could collect user preferences during onboarding
    return {
      'notifications_enabled': true,
      'marketing_emails': false,
      'theme_preference': 'system',
    };
  }
}