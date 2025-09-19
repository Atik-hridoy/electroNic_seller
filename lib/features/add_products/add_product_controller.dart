import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_variant_model.dart';
import '../products/product_model.dart';

class AddProductController extends GetxController {
  // Text editing controllers for common product fields
  final productNameController = TextEditingController();
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final finishController = TextEditingController();

  // Text editing controllers for variant-specific fields
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final profitPriceController = TextEditingController();
  final quantityController = TextEditingController();

  // Observable variables for dropdowns
  var selectedCategory = 'Appliance'.obs;
  var selectedSubCategory = 'TV'.obs;
  var selectedBrand = 'Nipson'.obs;
  var selectedColors = <String>[].obs;
  var selectedSpecialCategory = 'Male'.obs;

  // Product images
  var productImages = <String>[].obs;
  final maxImages = 5;

  // Product variants
  var productVariants = <ProductVariant>[].obs;

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
    productNameController.text = "Nipson TV";
    modelController.text = "LED TV";
    sizeController.text = "40inch";
    priceController.text = "10.50";
    purchasePriceController.text = "8.00";
    profitPriceController.text = "2.50";
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

  // Validation for main product form
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

  // Add product variant method
  void addProductVariant() {
    if (validateVariantForm()) {
      // Create product variant
      final variant = ProductVariant.create(
        size: sizeController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0.0,
        profitPrice: double.tryParse(profitPriceController.text) ?? 0.0,
        quantity: int.tryParse(quantityController.text) ?? 0,
      );

      productVariants.add(variant);

      Get.snackbar(
        'Success',
        'Product variant added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Reset variant form after successful submission
      resetVariantForm();
    }
  }

  // Remove product variant
  void removeProductVariant(String variantId) {
    productVariants.removeWhere((variant) => variant.id == variantId);
  }

  // Validation for variant form
  bool validateVariantForm() {
    if (sizeController.text.isEmpty) {
      Get.snackbar('Error', 'Size/Type is required');
      return false;
    }
    if (priceController.text.isEmpty) {
      Get.snackbar('Error', 'Price is required');
      return false;
    }
    if (purchasePriceController.text.isEmpty) {
      Get.snackbar('Error', 'Purchase price is required');
      return false;
    }
    if (quantityController.text.isEmpty) {
      Get.snackbar('Error', 'Quantity is required');
      return false;
    }
    return true;
  }

  // Reset variant form
  void resetVariantForm() {
    sizeController.clear();
    priceController.clear();
    purchasePriceController.clear();
    profitPriceController.clear();
    quantityController.clear();
  }

  // Submit complete product with all variants
  void submitProduct() {
    if (validateForm() && productVariants.isNotEmpty) {
      // Create complete product object with variants
      final productData = {
        'name': productNameController.text,
        'category': selectedCategory.value,
        'subCategory': selectedSubCategory.value,
        'model': modelController.text,
        'brand': selectedBrand.value,
        'colors': selectedColors.toList(),
        'specialCategory': selectedSpecialCategory.value,
        'finish': finishController.text,
        'images': productImages.toList(),
        'variants': productVariants.map((v) => v.toJson()).toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      print('Complete Product Data: $productData');
      Get.snackbar(
        'Success',
        'Product with ${productVariants.length} variants submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Create ProductModel from the form data
      final product = ProductModel(
        name: productNameController.text,
        category: selectedCategory.value,
        subCategory: selectedSubCategory.value,
        model: modelController.text,
        brand: selectedBrand.value,
        colors: selectedColors.toList(),
        specialCategory: selectedSpecialCategory.value,
        finish: finishController.text,
        images: productImages.toList(),
        variants: productVariants.map((v) => ProductVariantModel(
          id: v.id,
          size: v.size,
          price: v.price,
          purchasePrice: v.purchasePrice,
          profitPrice: v.profitPrice,
          quantity: v.quantity,
          createdAt: v.createdAt,
        )).toList(),
        createdAt: DateTime.now(),
      );

      // Navigate to Product Details view with product data
      //Get.toNamed(Routes.productDetails, arguments: product);
      Get.toNamed(Routes.category, arguments: product);

      // Reset entire form after successful submission
      resetForm();
    } else if (productVariants.isEmpty) {
      Get.snackbar('Error', 'Please add at least one product variant');
    }
  }

  // Reset complete form
  void resetForm() {
    productNameController.clear();
    modelController.clear();
    brandController.clear();
    finishController.clear();

    resetVariantForm();

    selectedCategory.value = 'Appliance';
    selectedSubCategory.value = 'TV';
    selectedBrand.value = 'Nipson';
    selectedColors.clear();
    selectedSpecialCategory.value = 'Male';
    productVariants.clear();
    productImages.clear();
    currentPrice.value = 10.50;
  }

  @override
  void onClose() {
    // Dispose controllers
    productNameController.dispose();
    modelController.dispose();
    brandController.dispose();
    finishController.dispose();
    sizeController.dispose();
    priceController.dispose();
    purchasePriceController.dispose();
    profitPriceController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}