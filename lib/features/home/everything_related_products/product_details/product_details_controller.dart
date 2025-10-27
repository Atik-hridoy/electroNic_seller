import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import '../products_view/product_model.dart';

class ProductDetailsController extends GetxController {
  // Product model to hold dynamic data
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  // Alternative source when coming from CategoryView: product map
  final Rx<Map<String, dynamic>?> productData = Rx<Map<String, dynamic>?>(null);
  // Reviews state
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxDouble averageRating = 0.0.obs;

  // Product basic info (computed from product model)
  RxString get productName =>
      (product.value?.name ?? productData.value?['name']?.toString() ?? 'Trkil Tracker').obs;
  RxString get brandName =>
      (product.value?.brand ?? productData.value?['brand']?.toString() ?? 'Trkil').obs;
  RxString get quantity => product.value != null 
      ? '${product.value!.variants.fold(0, (sum, variant) => sum + variant.quantity)}/100'.obs 
      : (productData.value != null
          ? '${(productData.value?['variants'] as List? ?? [])
                .fold<double>(0, (sum, v) => sum + ((v['quantity'] ?? 0).toDouble()))}/100'.obs
          : '2/20'.obs);
  RxString get currentPrice => product.value != null && product.value!.variants.isNotEmpty
      ? product.value!.variants.first.price.toStringAsFixed(2).obs
      : ((productData.value?['variants'] as List?)?.isNotEmpty ?? false
          ? ((productData.value!['variants'][0]['price'] ?? 0).toString()).obs
          : '16.30'.obs);
  RxString get originalPrice => product.value != null && product.value!.variants.isNotEmpty
      ? (product.value!.variants.first.price * 1.25).toStringAsFixed(2).obs
      : ((productData.value?['variants'] as List?)?.isNotEmpty ?? false
          ? (((productData.value!['variants'][0]['price'] ?? 0) * 1.25).toString()).obs
          : '20.30'.obs);
  RxString get size => product.value != null && product.value!.variants.isNotEmpty
      ? product.value!.variants.first.size.obs
      : ((productData.value?['variants'] as List?)?.isNotEmpty ?? false
          ? (productData.value!['variants'][0]['size']?.toString() ?? 'N/A').obs
          : 'N/A'.obs);

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
    return <String>[
      'assets/images/tracker1.png',
      'assets/images/tracker2.png',
      'assets/images/tracker3.png',
      'assets/images/tracker4.png',
    ].obs;
  }

  // Available colors (computed from product model)
  RxList<Color> get availableColors {
    if ((product.value?.colors.isEmpty ?? true) && ((productData.value?['colors'] as List?)?.isEmpty ?? true)) {
      return <Color>[Colors.black, Colors.grey, Colors.red].obs;
    }
    final List<String> colors = product.value != null
        ? product.value!.colors
        : (productData.value?['colors']?.cast<String>() ?? <String>[]);
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
    if ((product.value?.variants.isEmpty ?? true) && ((productData.value?['variants'] as List?)?.isEmpty ?? true)) {
      return <String>['Small', 'Medium', 'Large'].obs;
    }
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
  RxString get productOverview => product.value != null 
      ? '''${product.value!.name} by ${product.value!.brand} is a high-quality ${product.value!.category} product. This ${product.value!.model} features ${product.value!.finish} finish and comes in ${product.value!.colors.join(', ')} colors. Perfect for ${product.value!.specialCategory} users looking for premium quality and performance.'''.obs
      : (productData.value != null
          ? '''${productData.value!['name'] ?? ''} by ${productData.value!['brand'] ?? ''} is a high-quality ${productData.value!['category'] ?? ''} product. This ${productData.value!['model'] ?? ''} comes in ${(productData.value!['colors'] as List? ?? []).join(', ')} colors. Perfect for ${productData.value!['specialCategory'] ?? ''} users looking for premium quality and performance.'''.obs
          : '''Protect the AirTag that's keeping track of all your important things. The OtterBox Rugged Case for AirTag securely covers the AirTag free from attached to your keys and locks it. The locked AirTag that runs in to your bends against the soft AirTag from all that bouncing and banging around as you go about your day. Simply twist on the case and AirTag is locked into legendary OtterBox protection and ready for anything.'''.obs);

  // Highlights (computed from product model)
  RxList<String> get highlights => product.value != null 
      ? <String>[
          'Category: ${product.value!.category}',
          'Sub-category: ${product.value!.subCategory}',
          'Brand: ${product.value!.brand}',
          'Model: ${product.value!.model}',
          'Available Colors: ${product.value!.colors.join(', ')}',
          'Special Category: ${product.value!.specialCategory}',
          'Finish: ${product.value!.finish}',
          'Total Variants: ${product.value!.variants.length}',
        ].obs
      : (productData.value != null
          ? <String>[
              'Category: ${productData.value!['category'] ?? ''}',
              'Sub-category: ${productData.value!['subCategory'] ?? ''}',
              'Brand: ${productData.value!['brand'] ?? ''}',
              'Model: ${productData.value!['model'] ?? ''}',
              'Available Colors: ${(productData.value!['colors'] as List? ?? []).join(', ')}',
              'Special Category: ${productData.value!['specialCategory'] ?? ''}',
              'Total Variants: ${(productData.value!['variants'] as List? ?? []).length}',
            ].obs
          : <String>[
              'Secure, twist-top design',
              'Dual-material, rugged protection',
              'Limited lifetime warranty supported by hassle-free customer service',
            ].obs);

  String get productId => productData.value?['id']?.toString() ?? '';

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
  RxList<String> get techSpecs => product.value != null 
      ? <String>[
          'Product Name: ${product.value!.name}',
          'Category: ${product.value!.category}',
          'Sub-category: ${product.value!.subCategory}',
          'Brand: ${product.value!.brand}',
          'Model: ${product.value!.model}',
          'Colors: ${product.value!.colors.join(', ')}',
          'Special Category: ${product.value!.specialCategory}',
          'Finish: ${product.value!.finish}',
          'Total Images: ${product.value!.images.length}',
          'Total Variants: ${product.value!.variants.length}',
          'Created: ${product.value!.createdAt.toString().split(' ')[0]}',
        ].obs
      : (productData.value != null
          ? <String>[
              'Product Name: ${productData.value!['name'] ?? ''}',
              'Category: ${productData.value!['category'] ?? ''}',
              'Sub-category: ${productData.value!['subCategory'] ?? ''}',
              'Brand: ${productData.value!['brand'] ?? ''}',
              'Model: ${productData.value!['model'] ?? ''}',
              'Colors: ${(productData.value!['colors'] as List? ?? []).join(', ')}',
              'Total Images: ${(productData.value!['images'] as List? ?? []).length}',
              'Total Variants: ${(productData.value!['variants'] as List? ?? []).length}',
              'Created: ${(productData.value!['createdAt'] ?? '').toString().split('T').first}',
            ].obs
          : <String>[
              'Form Factor: Hard Case',
              'Material: Hard Plastic, Silicone',
              'Height: 2 in. / 5.1 cm',
              'Length: 1.6 in. / 4.1 cm',
              'Width: .4 in. / 1 cm',
            ].obs);

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    loadProductData();
    _initializeReviews();
  }

  void loadProductData() {
    // Check if product data was passed as ProductModel
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      // Set initial selected size to first variant's size
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
      return;
    }
    // Fallback
    // Keep the fallback hardcoded values
  }

  void _initializeReviews() {
    // Optionally load initial reviews from passed map if present
    final list = productData.value?['reviews'] as List?;
    if (list != null) {
      for (final r in list) {
        if (r is Map<String, dynamic>) {
          reviews.add({
            'reviewer': r['reviewer']?.toString() ?? 'Anonymous',
            'rating': (r['rating'] is num) ? (r['rating'] as num).toInt() : 0,
            'comment': r['comment']?.toString() ?? '',
            'createdAt': r['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
          });
        }
      }
    }
    _recomputeAverage();
  }

  int get totalReviews => reviews.length;

  void addReview({required String reviewer, required int rating, required String comment}) {
    reviews.insert(0, {
      'reviewer': reviewer.isNotEmpty ? reviewer : 'Anonymous',
      'rating': rating.clamp(1, 5),
      'comment': comment,
      'createdAt': DateTime.now().toIso8601String(),
    });
    _recomputeAverage();
  }

  void _recomputeAverage() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
      return;
    }
    final sum = reviews.fold<int>(0, (acc, r) => acc + (r['rating'] as int? ?? 0));
    averageRating.value = sum / reviews.length;
  }

  // Method to update selected size
  void updateSelectedSize(String newSize) {
    selectedSize.value = newSize;
    
    // Update price and quantity based on selected variant
    final variant = selectedVariant;
    if (variant != null) {
      currentPrice.value = variant.price.toStringAsFixed(2);
      originalPrice.value = (variant.price * 1.25).toStringAsFixed(2);
      size.value = variant.size;
    }
    
    print('Size updated to: $newSize');
  }

  void onEditTap() {
    // Handle edit button tap
    print('Edit product tapped');
    // Navigate to edit product screen
    // Get.toNamed('/edit-product');
  }

  void updateProductName(String name) {
    productName.value = name;
  }

  void updateBrandName(String brand) {
    brandName.value = brand;
  }

  void updateQuantity(String qty) {
    quantity.value = qty;
  }

  void updateCurrentPrice(String price) {
    currentPrice.value = price;
  }

  void updateOriginalPrice(String price) {
    originalPrice.value = price;
  }

  void updateSize(String productSize) {
    size.value = productSize;
  }

  void updateOverview(String overview) {
    productOverview.value = overview;
  }

  void addHighlight(String highlight) {
    highlights.add(highlight);
  }

  void removeHighlight(int index) {
    if (index >= 0 && index < highlights.length) {
      highlights.removeAt(index);
    }
  }

  void addTechSpec(String spec) {
    techSpecs.add(spec);
  }

  void removeTechSpec(int index) {
    if (index >= 0 && index < techSpecs.length) {
      techSpecs.removeAt(index);
    }
  }

  void addProductImage(String imagePath) {
    productImages.add(imagePath);
  }

  void removeProductImage(int index) {
    if (index >= 0 && index < productImages.length) {
      productImages.removeAt(index);
    }
  }

  void addAvailableColor(Color color) {
    if (!availableColors.contains(color)) {
      availableColors.add(color);
    }
  }

  void removeAvailableColor(Color color) {
    availableColors.remove(color);
  }

  // Method to load product by ID (for future use)
  void loadProductById(String productId) {
    // TODO: Implement API call to load product by ID
    print('Loading product with ID: $productId');
  }

  // Method to save product changes (for future use)
  Future<bool> saveProductChanges() async {
    // TODO: Implement API call to save product changes
    print('Saving product changes...');
    return true;
  }
}