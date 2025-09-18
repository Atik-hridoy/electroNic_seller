import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  // Text editing controllers
  final productNameController = TextEditingController();
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final priceController = TextEditingController();
  final saleTypeController = TextEditingController();
  final quantityController = TextEditingController();
  final finishController = TextEditingController();

  // Observable variables for dropdowns
  var selectedCategory = 'Appliance'.obs;
  var selectedSubCategory = 'TV'.obs;
  var selectedBrand = 'Nipson'.obs;
  var selectedColors = <String>[].obs;
  var selectedSpecialCategory = 'Male'.obs;

  // Product images
  var productImages = <String>[].obs;
  final maxImages = 3;

  // Dropdown options
  final categories = ['Appliance', 'Electronics', 'Furniture', 'Clothing'];
  final subCategories = ['TV', 'Refrigerator', 'Washing Machine', 'Air Conditioner'];
  final brands = ['Nipson', 'Samsung', 'LG', 'Sony', 'Panasonic'];
  final colors = ['Black', 'White', 'Silver', 'Red', 'Blue'];
  final specialCategories = ['Male', 'Female', 'Unisex', 'Kids'];

  // Price range
  var minPrice = 10.40.obs;
  var maxPrice = 50.50.obs;
  var currentPrice = 10.50.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values
    productNameController.text = "Nipson TV 40tk";
    modelController.text = "LED TV";
    priceController.text = "10.50";
    saleTypeController.text = "N/A";
    quantityController.text = "50";
  }

  // Methods to handle dropdown changes
  void updateCategory(String value) {
    selectedCategory.value = value;
  }

  void updateSubCategory(String value) {
    selectedSubCategory.value = value;
  }

  void updateBrand(String value) {
    selectedBrand.value = value;
  }

  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
  }

  void updateSpecialCategory(String value) {
    selectedSpecialCategory.value = value;
  }

  // Image handling methods
  void addImage(String imagePath) {
    if (productImages.length < maxImages) {
      productImages.add(imagePath);
    }
  }

  void removeImage(int index) {
    if (index < productImages.length) {
      productImages.removeAt(index);
    }
  }

  // Price handling
  void updatePrice(double value) {
    currentPrice.value = value;
    priceController.text = value.toStringAsFixed(2);
  }

  // Validation
  bool validateForm() {
    if (productNameController.text.isEmpty) {
      Get.snackbar('Error', 'Product name is required');
      return false;
    }
    if (selectedColors.isEmpty) {
      Get.snackbar('Error', 'Please select at least one color');
      return false;
    }
    if (productImages.isEmpty) {
      Get.snackbar('Error', 'Please add at least one product image');
      return false;
    }
    return true;
  }

  // Add product method
  void addProduct() {
    if (validateForm()) {
      // Create product object
      final productData = {
        'name': productNameController.text,
        'category': selectedCategory.value,
        'subCategory': selectedSubCategory.value,
        'model': modelController.text,
        'brand': selectedBrand.value,
        'colors': selectedColors.toList(),
        'price': currentPrice.value,
        'saleType': saleTypeController.text,
        'quantity': int.tryParse(quantityController.text) ?? 0,
        'specialCategory': selectedSpecialCategory.value,
        'finish': finishController.text,
        'images': productImages.toList(),
      };

      print('Product Data: $productData');
      Get.snackbar('Success', 'Product added successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
      
      // Reset form after successful submission
      resetForm();
    }
  }

  // Reset form
  void resetForm() {
    productNameController.clear();
    modelController.clear();
    brandController.clear();
    priceController.clear();
    saleTypeController.clear();
    quantityController.clear();
    finishController.clear();
    
    selectedCategory.value = 'Appliance';
    selectedSubCategory.value = 'TV';
    selectedBrand.value = 'Nipson';
    selectedColors.clear();
    selectedSpecialCategory.value = 'Male';
    productImages.clear();
    currentPrice.value = 10.50;
  }

  @override
  void onClose() {
    // Dispose controllers
    productNameController.dispose();
    modelController.dispose();
    brandController.dispose();
    priceController.dispose();
    saleTypeController.dispose();
    quantityController.dispose();
    finishController.dispose();
    super.onClose();
  }
}