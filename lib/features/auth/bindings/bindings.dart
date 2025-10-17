import 'package:get/get.dart';

import '../controllers/authController.dart';
import '../controllers/otpController.dart';
import '../controllers/profile_info_controller.dart';
import '../services/auth_create_user_service.dart';
import '../services/auth_verify_otp_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<ProfileInfoController>(
      () => ProfileInfoController(),
    );
    Get.put(AuthController());
    Get.put(AuthCreateUserService());
    Get.put(AuthVerifyOtpService());
  
  }
}