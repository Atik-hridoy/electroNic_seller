import 'package:electronic/routes/app_pages.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  // User data with proper null safety
  final RxString userName = 'John Doe'.obs;
  final RxString userPhone = '+1 234 567 8900'.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize any required data here
    _initializeUserData();
  }
  
  void _initializeUserData() {
    // Load user data from storage or API if needed
    // Example: userName.value = storageService.getUserName() ?? 'John Doe';
  }
  
  // Logout method
  void logout() {
    try {
      // Clear any user session data
      // Example: await authService.logout();
      
      // Navigate to auth screen
      Get.offAllNamed(Routes.auth);
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar('Error', 'Failed to logout. Please try again.');
    }
  }
  
  // Format phone number for display
  String getFormattedPhone() {
    return userPhone.value;
  }
}
