import 'package:electronic/features/splash/bindings/splash_binding.dart';
import 'package:electronic/features/splash/views/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/auth/bindings/bindings.dart';
import '../features/auth/views/authview.dart';
import '../features/auth/views/otpView.dart';
import '../features/onboarding/bindings/onboarding_bindings.dart';
import '../features/onboarding/views/onboarding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

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
  ];
}
