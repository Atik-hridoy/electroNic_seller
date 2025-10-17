import 'package:get/get.dart';
import 'package:electronic/routes/app_pages.dart';
import '../../../core/storage/storage_services.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Initialize storage and check auth state
      await LocalStorage.getAllPrefData();
      
      // Wait for 2 seconds (splash screen duration)
      await Future.delayed(const Duration(seconds: 2));

      if (LocalStorage.isLogIn && LocalStorage.token.isNotEmpty) {
        // User is logged in, navigate to profile info
        Get.offAllNamed(Routes.profileInfo);
      } else {
        // User is not logged in, go to onboarding
        Get.offAllNamed(Routes.onboarding);
      }
    } catch (e) {
      // If there's an error, try to navigate to onboarding as fallback
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(Routes.onboarding);
    }
  }
}
