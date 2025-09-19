import 'package:electronic/features/add_products/add_product_controller.dart';
import 'package:electronic/features/category/category_controller.dart';
import 'package:electronic/features/order/order_controller.dart';
import 'package:electronic/features/product_details/product_details_controller.dart';
import 'package:get/get.dart';
import '../products/products_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProductsController());
    // Use lazy loading for feature-specific controllers to avoid conflicts
    Get.lazyPut<AddProductController>(() => AddProductController());
    Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<OrderController>(() => OrderController());
    
  }
}