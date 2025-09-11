import 'package:get/get.dart';
import '../services/api_service.dart';
import '../storage/local_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize services
    Get.lazyPut(() => ApiService(), fenix: true);
    
    // Initialize storage
    Get.putAsync<LocalStorageService>(() async {
      await LocalStorageService.init();
      return LocalStorageService();
    }, permanent: true);
    
    // Add other global dependencies here
    // Get.lazyPut(() => AuthService(), fenix: true);
    // Get.lazyPut(() => ProductService(), fenix: true);
    // Get.lazyPut(() => CartService(), fenix: true);
  }
  
  // Initialize app-wide services
  static Future<void> initializeApp() async {
    // Initialize local storage
    await LocalStorageService.init();
    
    // Initialize other app-wide services here
    // await Hive.initFlutter();
    // registerHiveAdapters();
    // await NotificationService.init();
    
    // Check if first launch
    final isFirstLaunch = LocalStorageService.isFirstLaunch() ?? true;
    if (isFirstLaunch) {
      // Perform first launch setup
      await LocalStorageService.setFirstLaunch(false);
      // Set default preferences
      await LocalStorageService.setThemeMode('light');
      await LocalStorageService.setLanguage('en');
    }
  }
}