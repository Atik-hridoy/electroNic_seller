import 'package:get/get.dart';
import '../../../core/storage/storage_services.dart';
import '../../../core/storage/storage_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/util/app_logger.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final RxBool isLoggedIn = false.obs;
  final RxString authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    await LocalStorage.getAllPrefData();
    isLoggedIn.value = LocalStorage.isLogIn;
    authToken.value = LocalStorage.token;
    
    AppLogger.debug(
      'Auth state checked - isLoggedIn: ${isLoggedIn.value}, Token: ${authToken.value.isNotEmpty ? '${authToken.value.substring(0, 10)}...' : 'None'}',
      tag: 'AuthService',
    );
  }

  Future<void> login(String accessToken, {String? refreshToken}) async {
    try {
      await LocalStorage.setString(LocalStorageKeys.token, accessToken);
      if (refreshToken != null) {
        await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
      }
      await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
      await LocalStorage.getAllPrefData();
      
      isLoggedIn.value = true;
      authToken.value = accessToken;
      
      AppLogger.success(
        'User logged in successfully',
        tag: 'AuthService',
      );
      
      Get.offAllNamed(AppRoutes.profileInfo);
    } catch (e) {
      AppLogger.error(
        'Error during login: $e',
        tag: 'AuthService',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await LocalStorage.removeAllPrefData();
      isLoggedIn.value = false;
      authToken.value = '';
      
      AppLogger.info('User logged out', tag: 'AuthService');
      
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      AppLogger.error(
        'Error during logout: $e',
        tag: 'AuthService',
        error: e,
      );
      rethrow;
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    return isLoggedIn.value && authToken.value.isNotEmpty;
  }
}
