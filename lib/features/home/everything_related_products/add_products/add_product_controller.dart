import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../products_view/model/get_product_category_model.dart';

import '../../../../../core/util/app_logger.dart';
import 'models/add_product_model.dart';
import 'product_variant_model.dart';
import 'services/add_products_service.dart';
import '../products_view/products_controller.dart';

// Subcategory class to hold both name and ID
class Subcategory {
  final String name;
  final String id;
  
  Subcategory({required this.name, required this.id});
  
  @override
  String toString() => name; // For backward compatibility with UI
}

class AddProductController extends GetxController {
  // Services
  final AddProductService _addProductService = Get.find<AddProductService>();
  
  // Loading state
  final isLoading = false.obs;
  
  // Text editing controllers for common product fields
  final productNameController = TextEditingController();
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final finishController = TextEditingController();
  final techSpecController = TextEditingController();
  final highlightController = TextEditingController();
  final overviewController = TextEditingController();

  // Text editing controllers for variant-specific fields
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final profitPriceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final quantityDiscountPriceController = TextEditingController();
  final quantityController = TextEditingController();


  // Observable variables for dropdowns
  final selectedCategory = CategoryModel(
    id: '',
    name: 'Appliance',
    thumbnail: '',
    subCategories: [],
  ).obs;
  var selectedSubCategory = Subcategory(name: 'Select Subcategory', id: '').obs;
  var selectedBrand = 'Nipson'.obs;
  var selectedColors = <String>[].obs;
  var selectedSpecialCategory = 'Male'.obs;

  // Product images
  var productImages = <String>[].obs;
  final maxImages = 5;

  // Product variants
  var productVariants = <ProductVariant>[].obs;

  // Reference to ProductsController
  final ProductsController productsController = Get.find<ProductsController>();

  // Getter for categories list
  List<CategoryModel> get categories {
    return productsController.categories;
  }
  
  // Get category ID from CategoryModel
  String getCategoryId(CategoryModel category) {
    return category.id;
  }
  

  // Getter for available subcategories based on selected category
  List<Subcategory> get availableSubcategories {
    // Always include 'Select Subcategory' as the first option
    final subcategories = <Subcategory>[
      Subcategory(name: 'Select Subcategory', id: '')
    ];
    
    if (productsController.categories.isEmpty) {
      return subcategories;
    }
    
    try {
      // Use the selected category
      final category = selectedCategory.value;
      
      // Add all subcategories with their IDs
      subcategories.addAll(
        category.subCategories.map((sub) => 
          Subcategory(name: sub.name, id: sub.id)
        ).toList()
      );
      
      return subcategories;
    } catch (e) {
      return subcategories;
    }
  }

  // Getter for brands list from ProductsController
  List<String> get brands {
    // Add a default 'Select Brand' option
    final brandList = ['Select Brand'];
    
    // Add all brand names from the ProductsController
    if (productsController.brands.isNotEmpty) {
      brandList.addAll(productsController.brands.map((brand) => brand.name).toList());
    } else {
      // Fallback to default brands if none are loaded
      brandList.addAll(['Nipson', 'Samsung', 'LG']);
    }
    
    return brandList;
  }

  // Getter for colors list
  List<String> get colors => [
    'Red',
    'Blue',
    'Green',
    'Black',
    'White',
    'Silver',
    'Gold',
    'Other'
  ];

  // Getter for special categories
  List<String> get specialCategories => [
    'Male',
    'Female',
    'Kids',
    'Unisex',
    'Other'
  ];

  // Price range
  var minPrice = 10.40.obs;
  var maxPrice = 50.50.obs;
  var currentPrice = 10.50.obs;

  // Category ID and name from navigation arguments
  final RxString categoryId = ''.obs;
  final RxString categoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get category ID and name from navigation arguments if provided
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      if (arguments['categoryId'] != null) {
        categoryId.value = arguments['categoryId'].toString();
      }
      if (arguments['categoryName'] != null) {
        final name = arguments['categoryName'].toString();
        categoryName.value = name;
        
        // Find and set the selected category from the categories list
        if (productsController.categories.isNotEmpty) {
          try {
            final category = productsController.categories.firstWhere(
              (cat) => cat.name == name,
              orElse: () => CategoryModel(
                id: categoryId.value,
                name: name,
                thumbnail: '',
                subCategories: [],
              ),
            );
            selectedCategory.value = category;
          } catch (e) {
            // Fallback to default category if not found
            AppLogger.error('Category not found: $name');
          }
        }
      }
    }
    
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
  void updateCategory(CategoryModel newValue) {
    selectedCategory.value = newValue;
    // Reset subcategory when category changes
    selectedSubCategory.value = Subcategory(name: 'Select Subcategory', id: '');
  }

  void updateSubCategory(Subcategory value) {
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
        price: int.tryParse(priceController.text) ?? 0,
        purchasePrice: int.tryParse(purchasePriceController.text) ?? 0,
        profitPrice: int.tryParse(profitPriceController.text) ?? 0,
        discountPrice: int.tryParse(discountPriceController.text) ?? 0,
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
      Get.snackbar('Error', 'Please enter a size/type');
      return false;
    }
    if (priceController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a price');
      return false;
    }
    if (purchasePriceController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a purchase price');
      return false;
    }
    if (profitPriceController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a profit price');
      return false;
    }
    if (quantityController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a quantity');
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
    discountPriceController.clear();
    quantityDiscountPriceController.clear();
    quantityController.clear();
  }

  // Submit complete product with all variants
  Future<void> submitProduct() async {
    try {
      if (isLoading.value) return;
      
      // Validate form
      if (!validateForm()) {
        return;
      }
      
      if (productVariants.isEmpty) {
        Get.snackbar('Error', 'Please add at least one product variant');
        return;
      }
      
      isLoading.value = true;
      AppLogger.info('Starting product submission');
      
      // Convert product variants to SizeType list
      final sizeTypes = productVariants.map((variant) => SizeType(
        size: variant.size,
        price: variant.price.toDouble(),
        quantity: variant.quantity.toDouble(),
        purchasePrice: variant.purchasePrice.toDouble(),
        profit: variant.profitPrice.toDouble(),
        discount: variant.discountPrice.toDouble(),
      )).toList();
      
      // Create product model with both names and IDs
      final product = AddProductModel(
        category: selectedCategory.value,
        subCategory: selectedSubCategory.value.name,
        subCategoryId: selectedSubCategory.value.id,
        name: productNameController.text.trim(),
        model: modelController.text.trim(),
        brand: selectedBrand.value,
        color: selectedColors,
        sizeType: sizeTypes,
        specialCategory: selectedSpecialCategory.value,
        overview: overviewController.text.trim(),
        highlights: highlightController.text.trim(),
        techSpecs: techSpecController.text.trim(),
      );
      
      // Log the product data
      AppLogger.info('Submitting product: ${product.toJson()}');
      
      // Convert image paths to File objects
      final imageFiles = productImages
          .where((path) => path.isNotEmpty)
          .map((path) => File(path))
          .toList();
      
      // Call the service to add product
      final response = await _addProductService.addProduct(
        product: product,
        images: imageFiles,
      );
      
      // Log the response
      AppLogger.info('Product submission response: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.success('Product added successfully');
        Get.snackbar(
          'Success',
          'Product added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Clear the form after successful submission
        resetForm();
        
        // Navigate back or to products list
        Get.until((route) => route.isFirst);
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to add product';
        throw errorMessage;
      }
    } catch (e) {
      AppLogger.error('Error submitting product: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Submit the product to the server
  

  // Reset complete form
  void resetForm() {
    productNameController.clear();
    modelController.clear();
    brandController.clear();
    finishController.clear();

    resetVariantForm();

    selectedCategory.value = CategoryModel(
      id: '',
      name: 'Appliance',
      thumbnail: '',
      subCategories: [],
    );
    selectedSubCategory.value = Subcategory(name: 'Select Subcategory', id: '');
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