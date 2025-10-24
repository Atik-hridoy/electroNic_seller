import 'package:dio/dio.dart';
import 'package:electronic/features/home/products/add_products/add_product_controller.dart';
import 'package:electronic/features/home/products/category/category_controller.dart';
import 'package:electronic/features/home/products/product_details/product_details_controller.dart';
import 'package:electronic/features/home/views/account/account_otions/controller/account_setting_controller.dart';
import 'package:electronic/features/home/views/account/services/get_profile_service.dart';
import 'package:get/get.dart';
import 'products/products_controller.dart';
import 'home_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/account_controller.dart';
import 'controllers/edit_account_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Dio>(Dio(), permanent: true);
    // Register services
    Get.lazyPut<GetProfileService>(() => GetProfileService());

    // Register controllers
    Get.put(HomeController());
    Get.put(ProductsController());
    
    // Use lazy loading for feature-specific controllers to avoid conflicts
    Get.lazyPut<AddProductController>(() => AddProductController());
    Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<AccountSettingController>(() => AccountSettingController());
    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<EditAccountController>(() => EditAccountController());
    
  }
}