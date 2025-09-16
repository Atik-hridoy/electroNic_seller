import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final String _isLoggedInKey = 'is_logged_in';

  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  // Call this when user successfully logs in
  void login() {
    _isLoggedIn.value = true;
  }

  // Call this when user logs out
  void logout() {
    _isLoggedIn.value = false;
  }
}
