import 'package:electronic/features/home/products/add_product_controller.dart';
import 'package:get/get.dart';


import 'products/products_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProductsController());
    Get.put(AddProductController());
  }
}