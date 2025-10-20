import 'package:electronic/routes/app_pages.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  // User data
  final RxString userName = 'John Doe'.obs;
  final RxString userPhone = '+1 234 567 8900'.obs;
  
  // Logout method
  void logout() {
    // Handle logout logic here
    print('User logged out');
    // Example: Clear user session, navigate to login, etc.
   Get.offAllNamed(Routes.auth);
  }
  
  // Format phone number for display
  String getFormattedPhone() {
    return userPhone.value;
  }
}
