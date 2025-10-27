import 'package:electronic/features/auth/views/auth_signIn_view.dart';
import 'package:electronic/features/home/views/account/account_otions/views/account_about_us.dart';
import 'package:electronic/features/home/views/account/account_otions/views/tearms_view.dart';
import 'package:electronic/features/home/views/account/account_otions/views/work_funtiuonality.dart';
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
import '../features/home/everything_related_products/add_products/add_product_view.dart';
import '../features/home/everything_related_products/product_details/product_details.dart';
import '../features/home/everything_related_products/category/category_view.dart';
import '../features/home/views/account/account_otions/views/account_settings.dart';
import '../features/home/views/account/edit_account.dart';


part 'app_routes.dart';

class AppPages {
  //static const initial = Routes.splash;
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
    GetPage(
      name: Routes.profileInfo,
      page: () => const ProfileInfoView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
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
    GetPage(
      name: Routes.accountSettingView,
      page: () => const AccountSettingView(),
      binding: HomeBinding(),

    ),
    GetPage(
      name: Routes.accountSettings,
      page: () => const AccountSettingView(),
      binding: HomeBinding(),

    ),
    GetPage(
      name: Routes.editAccount,
      page: () => EditAccountView(),
      binding: HomeBinding(),

    ),
    GetPage(
      name: Routes.authSignIn,
      page: () => const AuthSignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.accountAboutUs,
      page: () => const AccountAboutUs(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.workFuntiuonality,
      page: () => const AccountWorkFuntiuonality(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.termsOfService,
      page: () => const TermsView(),
      binding: HomeBinding(),
    ),
  ];
}
