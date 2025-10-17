import 'package:get/get.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/services/auth_verify_otp_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize services
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AuthVerifyOtpService(), fenix: true);
    
    // Initialize other services here
  }
}
