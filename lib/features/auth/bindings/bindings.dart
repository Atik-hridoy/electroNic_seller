
import 'package:get/get.dart';

import '../controllers/authController.dart';
import '../controllers/otpController.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  
  }
}