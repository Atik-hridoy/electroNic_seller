import 'package:electronic/core/switching_language_facilities/localization_service.dart';
import 'package:electronic/core/switching_language_facilities/my_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);
  
  // Initialize LocalizationService
  final localizationService = LocalizationService();
  await localizationService.init();
  Get.put<LocalizationService>(localizationService);

  // Set up system UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  // Get the current locale after initialization
  final locale = Get.find<LocalizationService>().getCurrentLocale();
  
  runApp(MyApp(initialLocale: locale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Electronic Seller',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          translations: MyTranslations(),
          locale: initialLocale,
          fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}