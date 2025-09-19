import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<dynamic> products = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controller
  }

  // Methods for products functionality
  void loadProducts() {
    // Load products logic
  }

  void refreshProducts() {
    // Refresh products logic
  }

  // Button handlers
  void onAddProductTap() {
    // Navigate to Add Product view
    Get.toNamed(Routes.addProduct);
  }

  void onCategoryTap(String categoryName) {
    // Handle category tap
    Get.snackbar(
      'Category Selected',
      'You selected: $categoryName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Data for categories
  List<Map<String, dynamic>> getCategories() {
    return [
      {'name': 'Computers', 'image': 'assets/images/computer.png', 'color': Colors.blue},
      {'name': 'Phone', 'image': 'assets/images/phone.png', 'color': Colors.orange},
      {'name': 'Server Tool', 'image': 'assets/images/server.png', 'color': Colors.purple},
      {'name': 'accessories', 'image': 'assets/images/accessories.png', 'color': Colors.red},
      {'name': 'Camera', 'image': 'assets/images/camera.png', 'color': Colors.green},
      {'name': 'Networking', 'image': 'assets/images/networking.png', 'color': Colors.teal},
      {'name': 'Gadget', 'image': 'assets/images/gadget.png', 'color': Colors.indigo},
      {'name': 'Office Work', 'image': 'assets/images/office.png', 'color': Colors.brown},
      {'name': 'Appliance', 'image': 'assets/images/appliance.png', 'color': Colors.grey},
    ];
  }

  // Helper method to get fallback icon
  IconData getFallbackIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return Icons.computer;
      case 'phone':
        return Icons.phone_android;
      case 'server tool':
        return Icons.dns;
      case 'accessories':
        return Icons.headphones;
      case 'camera':
        return Icons.camera_alt;
      case 'networking':
        return Icons.router;
      case 'gadget':
        return Icons.devices;
      case 'office work':
        return Icons.business_center;
      case 'appliance':
        return Icons.kitchen;
      default:
        return Icons.category;
    }
  }
}