class AppRoutes {
  // Initial Route
  static const String initial = '/splash';

  // Auth Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main App Routes
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Additional Routes
  static const String search = '/search';
  static const String categories = '/categories';
  static const String wishlist = '/wishlist';
  static const String address = '/address';
  static const String payment = '/payment';

  // Route Names for Navigation
  static const Map<String, String> routeNames = {
    splash: 'Splash',
    onboarding: 'Onboarding',
    login: 'Login',
    register: 'Register',
    dashboard: 'Dashboard',
    home: 'Home',
    products: 'Products',
    productDetail: 'Product Detail',
    cart: 'Cart',
    orders: 'Orders',
    profile: 'Profile',
    settings: 'Settings',
  };
}
