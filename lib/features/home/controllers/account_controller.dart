import 'package:electronic/routes/app_pages.dart';
import 'package:get/get.dart';
import '../views/account/services/get_profile_service.dart';

class AccountController extends GetxController {
  // User data with proper null safety
  final RxString userName = ''.obs;

  final RxString userAddress = ''.obs;
  final GetProfileService _getProfileService = GetProfileService();
  
  @override
  void onInit() {
    super.onInit();
    _initializeUserData();
  }
  
  Future<void> _initializeUserData() async {
    try {
      final profileData = await _getProfileService.getProfile();
      if (profileData != null) {
        userName.value = '${profileData.data.firstName} ${profileData.data.lastName}';
        userAddress.value = profileData.data.address;
      } else {
        // Fallback to default values if profile data is not available
        userName.value = 'John Doe';
        userAddress.value = 'No address provided';
      }
    } catch (e) {
      // Fallback to default values in case of error
      userName.value = 'John Doe';
      userAddress.value = 'No address available';
      print('Error loading profile data: $e');
    }
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
}
