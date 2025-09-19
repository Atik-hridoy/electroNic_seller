import 'package:electronic/features/notification/bindings.dart';
import 'package:electronic/features/notification/notification_view.dart';
import 'package:electronic/features/splash/bindings/splash_binding.dart';
import 'package:electronic/features/splash/views/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/auth/bindings/bindings.dart';
import '../features/auth/views/authview.dart';
import '../features/auth/views/otpView.dart';
import '../features/auth/views/profile_info.dart';
import '../features/onboarding/bindings/onboarding_bindings.dart';
import '../features/onboarding/views/onboarding.dart';
import '../features/home/home_bindings.dart';
import '../features/home/home_view.dart';
import '../features/home/products/add_products/add_product_view.dart';
import '../features/home/products/product_details/product_details.dart';
import '../features/home/products/category/category_view.dart';


part 'app_routes.dart';

class AppPages {
  //static const initial = Routes.splash;
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.profileInfo,
      page: () => const ProfileInfoView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => AddProductView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => ProductDetailsView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.category,
      page: () => CategoryView(),
      binding: HomeBinding(),
    ),
  ];
}
