import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:electronic/core/constants/app_urls.dart';
import '../products_view/product_model.dart';
import 'service/get_single_product_service.dart';
import 'service/update_product_service.dart';
import 'service/get_feedback_service.dart';
import 'model/feedback_model.dart';

class ProductDetailsController extends GetxController {
  // Services
  final GetSingleProductService _productService = GetSingleProductService();
  final UpdateProductService _updateService = UpdateProductService();
  final GetFeedbackService _feedbackService = GetFeedbackService();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  
  // Edit mode
  final RxBool isEditMode = false.obs;
  
  // Form controllers for editing
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();
  final TextEditingController highlightsController = TextEditingController();
  final TextEditingController techSpecsController = TextEditingController();
  
  // New images for update
  final RxList<File> newImages = <File>[].obs;
  
  // Product model to hold dynamic data
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  // Alternative source when coming from CategoryView: product map
  final Rx<Map<String, dynamic>?> productData = Rx<Map<String, dynamic>?>(null);
  // Feedbacks state
  final RxList<FeedbackModel> feedbacks = <FeedbackModel>[].obs;
  final RxDouble averageRating = 0.0.obs;

  // Product basic info (computed from product model)
  String get productName =>
      product.value?.name ?? productData.value?['name']?.toString() ?? '';
  
  String get brandName =>
      product.value?.brand ?? productData.value?['brand']?.toString() ?? '';
  
  String get quantity {
    if (product.value != null) {
      final variant = selectedVariant;
      if (variant != null) {
        return '${variant.quantity}';
      }
      return '${product.value!.variants.fold(0, (sum, variant) => sum + variant.quantity)}';
    }
    
    // For productData map - show selected variant quantity
    final variants = productData.value?['variants'] as List? ?? [];
    if (variants.isNotEmpty) {
      // Find variant matching selected size
      Map<String, dynamic>? selectedVar;
      try {
        selectedVar = variants.firstWhere(
          (v) => v['size']?.toString() == selectedSize.value,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedVar = variants.first as Map<String, dynamic>;
      }
      return '${selectedVar['quantity'] ?? 0}';
    }
    return '0';
  }
  
  String get currentPrice {
    if (product.value != null && product.value!.variants.isNotEmpty) {
      final variant = selectedVariant;
      if (variant != null) {
        return variant.price.toStringAsFixed(2);
      }
      return product.value!.variants.first.price.toStringAsFixed(2);
    }
    
    // For productData map
    final variants = productData.value?['variants'] as List? ?? [];
    if (variants.isNotEmpty) {
      // Find variant matching selected size
      Map<String, dynamic>? selectedVar;
      try {
        selectedVar = variants.firstWhere(
          (v) => v['size']?.toString() == selectedSize.value,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedVar = variants.first as Map<String, dynamic>;
      }
      final price = selectedVar['price'] ?? 0;
      final discount = selectedVar['discount'] ?? 0;
      final discountedPrice = price - (price * discount / 100);
      return discountedPrice.toStringAsFixed(2);
    }
    return '0';
  }
  
  String get originalPrice {
    if (product.value != null && product.value!.variants.isNotEmpty) {
      final variant = selectedVariant;
      if (variant != null) {
        return variant.price.toStringAsFixed(2);
      }
      return product.value!.variants.first.price.toStringAsFixed(2);
    }
    
    // For productData map
    final variants = productData.value?['variants'] as List? ?? [];
    if (variants.isNotEmpty) {
      // Find variant matching selected size
      Map<String, dynamic>? selectedVar;
      try {
        selectedVar = variants.firstWhere(
          (v) => v['size']?.toString() == selectedSize.value,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedVar = variants.first as Map<String, dynamic>;
      }
      final price = selectedVar['price'] ?? 0;
      return price.toStringAsFixed(2);
    }
    return '0';
  }
  
  String get size => product.value != null && product.value!.variants.isNotEmpty
      ? product.value!.variants.first.size
      : ((productData.value?['variants'] as List?)?.isNotEmpty ?? false
          ? (productData.value!['variants'][0]['size']?.toString() ?? '')
          : '');

  // Product images (computed from product model)
  RxList<String> get productImages {
    if (product.value != null) {
      return product.value!.images.obs;
    }
    final imgsDyn = productData.value?['images'] as List?;
    if (imgsDyn != null) {
      final imgs = imgsDyn.map((e) => e.toString()).toList();
      return RxList<String>.from(imgs);
    }
    return <String>[].obs;
  }

  // Available colors (computed from product model)
  RxList<Color> get availableColors {
    final List<String> colors = product.value != null
        ? product.value!.colors
        : (productData.value?['colors']?.cast<String>() ?? <String>[]);
    
    if (colors.isEmpty) return <Color>[].obs;
    
    return colors.map((colorName) {
      switch (colorName.toLowerCase()) {
        case 'black': return Colors.black;
        case 'white': return Colors.white;
        case 'red': return Colors.red;
        case 'blue': return Colors.blue;
        case 'green': return Colors.green;
        case 'yellow': return Colors.yellow;
        case 'silver': return Colors.grey[300]!;
        case 'gold': return Colors.amber;
        default: return Colors.grey;
      }
    }).toList().obs;
  }

  // Size options (computed from product variants)
  RxList<String> get availableSizes {
    if (product.value != null) {
      return product.value!.variants.map((variant) => variant.size).toSet().toList().obs;
    }
    final List variants = productData.value?['variants'] as List? ?? [];
    return variants.map<String>((v) => v['size']?.toString() ?? 'N/A').toSet().toList().obs;
  }

  // Selected size
  final RxString selectedSize = 'Small'.obs;

  // Selected variant (based on selected size)
  ProductVariantModel? get selectedVariant {
    if (product.value != null) {
      return product.value!.variants.where((v) => v.size == selectedSize.value).firstOrNull;
    }
    // For map-based product, not returning a model; keep null and rely on map in getters
    return null;
  }

  // Product description (computed from product model)
  String get productOverview => productData.value?['overview']?.toString() ?? 
      product.value?.name ?? 'No description available';

  // Highlights (computed from product model)
  List<String> get highlights {
    final highlightsText = productData.value?['highlights']?.toString() ?? '';
    if (highlightsText.isNotEmpty) {
      return highlightsText.split('\n').where((line) => line.trim().isNotEmpty).toList();
    }
    return <String>[];
  }

  String get productId => 
      productData.value?['_id']?.toString() ?? 
      productData.value?['id']?.toString() ?? '';

  String get sellerId => productData.value?['seller']?['id']?.toString() ?? '';

  String get sellerFullName {
    final first = productData.value?['seller']?['firstName']?.toString() ?? '';
    final last = productData.value?['seller']?['lastName']?.toString() ?? '';
    return '$first $last'.trim();
  }

  String get sellerImageUrl {
    String path = productData.value?['seller']?['image']?.toString() ?? '';
    if (path.isEmpty) return '';
    if (path.startsWith('http') || path.startsWith('assets/')) return path;
    return '${AppUrls.imageBaseUrl}$path';
  }

  // Tech specs (computed from product model)
  List<String> get techSpecs {
    final techSpecsText = productData.value?['techSpecs']?.toString() ?? '';
    if (techSpecsText.isNotEmpty) {
      return techSpecsText.split('\n').where((line) => line.trim().isNotEmpty).toList();
    }
    return <String>[];
  }

  @override
  void onInit() {
    super.onInit();
    // Check if a product ID was passed to load from API
    if (Get.arguments is String) {
      final prodId = Get.arguments as String;
      loadProductById(prodId);
      loadFeedbacks(prodId);
    } else {
      // Initialize with sample data or passed product
      loadProductData();
    }
  }
  
  // Load feedbacks for product
  Future<void> loadFeedbacks(String productId) async {
    if (productId.isEmpty) {
      print('Cannot load feedbacks: productId is empty');
      return;
    }
    
    try {
      print('Loading feedbacks for product: $productId');
      final loadedFeedbacks = await _feedbackService.getFeedbacks(productId);
      feedbacks.value = loadedFeedbacks;
      _recomputeAverage();
      print('Loaded ${loadedFeedbacks.length} feedbacks');
    } catch (e) {
      // Silent fail, just log
      print('Failed to load feedbacks: $e');
      feedbacks.clear();
      averageRating.value = 0.0;
    }
  }

  void loadProductData() {
    // Check if product data was passed as ProductModel
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      if (product.value!.variants.isNotEmpty) {
        selectedSize.value = product.value!.variants.first.size;
      }
      return;
    }
    // Or as Map<String, dynamic> from CategoryView
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      productData.value = Get.arguments as Map<String, dynamic>;
      final variants = productData.value?['variants'] as List? ?? [];
      if (variants.isNotEmpty) {
        selectedSize.value = (variants.first['size']?.toString() ?? selectedSize.value);
      }
      
      // Load feedbacks if product ID is available
      final prodId = productId;
      if (prodId.isNotEmpty) {
        loadFeedbacks(prodId);
      }
    }
  }

  int get totalReviews => feedbacks.length;

  void _recomputeAverage() {
    if (feedbacks.isEmpty) {
      averageRating.value = 0.0;
      return;
    }
    final sum = feedbacks.fold<int>(0, (acc, f) => acc + f.rating);
    averageRating.value = sum / feedbacks.length;
  }

  // Get discount percentage for selected variant
  String get discountPercentage {
    final variants = productData.value?['variants'] as List? ?? [];
    if (variants.isNotEmpty) {
      Map<String, dynamic>? selectedVar;
      try {
        selectedVar = variants.firstWhere(
          (v) => v['size']?.toString() == selectedSize.value,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedVar = variants.first as Map<String, dynamic>;
      }
      final discount = selectedVar['discount'] ?? 0;
      return discount > 0 ? '${discount.toStringAsFixed(0)}% OFF' : '';
    }
    return '';
  }

  // Method to update selected size
  void updateSelectedSize(String newSize) {
    selectedSize.value = newSize;
    // Reactive getters will automatically update
  }

  void onEditTap() {
    // Populate form controllers with current data
    nameController.text = productName;
    brandController.text = brandName;
    modelController.text = productData.value?['model']?.toString() ?? '';
    overviewController.text = productData.value?['overview']?.toString() ?? '';
    highlightsController.text = productData.value?['highlights']?.toString() ?? '';
    techSpecsController.text = productData.value?['techSpecs']?.toString() ?? '';
    
    // Show edit dialog
    isEditMode.value = true;
  }
  
  // Pick new images for product
  Future<void> pickNewImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFiles.isNotEmpty) {
        newImages.addAll(pickedFiles.map((xFile) => File(xFile.path)));
        Get.snackbar(
          'Success',
          '${pickedFiles.length} image(s) added',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: ${e.toString()}',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }
  
  // Remove new image
  void removeNewImage(int index) {
    if (index >= 0 && index < newImages.length) {
      newImages.removeAt(index);
    }
  }
  
  // Update product
  Future<void> updateProduct() async {
    try {
      isUpdating.value = true;
      
      // Prepare update data
      final updateData = {
        'name': nameController.text.trim(),
        'brand': brandController.text.trim(),
        'model': modelController.text.trim(),
        'overview': overviewController.text.trim(),
        'highlights': highlightsController.text.trim(),
        'techSpecs': techSpecsController.text.trim(),
      };
      
      // Call update service
      final response = await _updateService.updateProduct(
        productId: productId,
        productData: updateData,
        newImages: newImages.isNotEmpty ? newImages : null,
      );
      
      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Product updated successfully',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
        
        // Reload product data
        await loadProductById(productId);
        
        // Close edit mode
        isEditMode.value = false;
        newImages.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: ${e.toString().replaceAll("Exception: ", "")}',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isUpdating.value = false;
    }
  }
  
  void cancelEdit() {
    isEditMode.value = false;
    newImages.clear();
    nameController.clear();
    brandController.clear();
    modelController.clear();
    overviewController.clear();
    highlightsController.clear();
    techSpecsController.clear();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    brandController.dispose();
    modelController.dispose();
    overviewController.dispose();
    highlightsController.dispose();
    techSpecsController.dispose();
    super.onClose();
  }

  // Method to load product by ID from API
  Future<void> loadProductById(String productId) async {
    try {
      isLoading.value = true;
      
      // Fetch product from API
      final response = await _productService.getSingleProduct(productId);
      
      if (response.success) {
        // Convert API response to productData map for compatibility
        productData.value = response.data.toMap();
        
        // Set initial selected size
        if (response.data.sizeType.isNotEmpty) {
          selectedSize.value = response.data.sizeType.first.size;
        }
        
        // Load feedbacks
        await loadFeedbacks(productId);
        
        Get.snackbar(
          'Success',
          'Product loaded successfully',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product: ${e.toString().replaceAll("Exception: ", "")}',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }
}