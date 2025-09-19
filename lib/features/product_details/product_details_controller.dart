import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../products/product_model.dart';

class ProductDetailsController extends GetxController {
  // Product model to hold dynamic data
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  
  // Product basic info (computed from product model)
  RxString get productName => product.value?.name.obs ?? 'Trkil Tracker'.obs;
  RxString get brandName => product.value?.brand.obs ?? 'Trkil'.obs;
  RxString get quantity => product.value != null 
      ? '${product.value!.variants.fold(0, (sum, variant) => sum + variant.quantity)}/100'.obs 
      : '2/20'.obs;
  RxString get currentPrice => product.value != null && product.value!.variants.isNotEmpty
      ? product.value!.variants.first.price.toStringAsFixed(2).obs
      : '16.30'.obs;
  RxString get originalPrice => product.value != null && product.value!.variants.isNotEmpty
      ? (product.value!.variants.first.price * 1.25).toStringAsFixed(2).obs
      : '20.30'.obs;
  RxString get size => product.value != null && product.value!.variants.isNotEmpty
      ? product.value!.variants.first.size.obs
      : 'N/A'.obs;

  // Product images (computed from product model)
  RxList<String> get productImages => product.value?.images.obs ?? <String>[
    'assets/images/tracker1.png',
    'assets/images/tracker2.png',
    'assets/images/tracker3.png',
    'assets/images/tracker4.png',
  ].obs;

  // Available colors (computed from product model)
  RxList<Color> get availableColors {
    if (product.value?.colors.isEmpty ?? true) {
      return <Color>[Colors.black, Colors.grey, Colors.red].obs;
    }
    
    return product.value!.colors.map((colorName) {
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
    if (product.value?.variants.isEmpty ?? true) {
      return <String>['Small', 'Medium', 'Large'].obs;
    }
    
    return product.value!.variants.map((variant) => variant.size).toSet().toList().obs;
  }
  
  // Selected size
  final RxString selectedSize = 'Small'.obs;
  
  // Selected variant (based on selected size)
  ProductVariantModel? get selectedVariant {
    if (product.value == null) return null;
    return product.value!.variants.where((v) => v.size == selectedSize.value).firstOrNull;
  }

  // Product description (computed from product model)
  RxString get productOverview => product.value != null 
      ? '''${product.value!.name} by ${product.value!.brand} is a high-quality ${product.value!.category} product. This ${product.value!.model} features ${product.value!.finish} finish and comes in ${product.value!.colors.join(', ')} colors. Perfect for ${product.value!.specialCategory} users looking for premium quality and performance.'''.obs
      : '''Protect the AirTag that's keeping track of all your important things. The OtterBox Rugged Case for AirTag securely covers the AirTag free from attached to your keys and locks it. The locked AirTag that runs in to your bends against the soft AirTag from all that bouncing and banging around as you go about your day. Simply twist on the case and AirTag is locked into legendary OtterBox protection and ready for anything.'''.obs;

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
      : <String>[
          'Secure, twist-top design',
          'Dual-material, rugged protection',
          'Limited lifetime warranty supported by hassle-free customer service',
        ].obs;

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
      : <String>[
          'Form Factor: Hard Case',
          'Material: Hard Plastic, Silicone',
          'Height: 2 in. / 5.1 cm',
          'Length: 1.6 in. / 4.1 cm',
          'Width: .4 in. / 1 cm',
        ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    loadProductData();
  }

  void loadProductData() {
    // Check if product data was passed as arguments
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      print('Product data loaded from arguments: ${product.value!.name}');
      
      // Set initial selected size to first variant's size
      if (product.value!.variants.isNotEmpty) {
        selectedSize.value = product.value!.variants.first.size;
      }
    } else {
      print('No product data provided, using fallback data');
      // Keep the fallback hardcoded values
    }
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