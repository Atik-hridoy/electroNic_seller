class AppUrls {

  static const String baseUrl = 'http://10.10.7.62:7010/api/v1/';
  static const String imageBaseUrl = 'http://10.10.7.62:7010/';

  static const String createAccount = 'auth/register';
  static const String signIn = 'auth/login';
  static const String verifyOtp = 'auth/verify-otp';
  static const String updateProfile = 'users/complete';
  static const String getProfile = 'users/profile';
  static const String updateProfileInsideApp = 'users/profile';


  //Product 

  static const String getProductsCategories = 'categories';
  static const String getProductsBrands = 'brands';
  static const String addProduct = 'products/create';
  static const String getAllProducts = 'products/get-all-for-seller';


  // dashboard

  static const String getProductStatistics  = 'dashboard/seller-products-analysis';

  //settings

  static const String getPrivacyPolicy = 'settings?key=privacyPolicy';
  static const String getSupport = 'settings?key=support';
  static const String getSocial = 'settings?key=social';
  static const String getAboutUs = 'settings?key=aboutUs';
  static const String getWorkFuntionality = 'settings?key=workFuntionality';
  static const String getTermsOfService = 'settings?key=termsOfService';

}
