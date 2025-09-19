import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../product_model.dart';

class CategoryController extends GetxController {
  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Category selection
  final RxInt selectedCategoryIndex = 0.obs;
  final RxString selectedSortCategory = 'Select Category'.obs;

  // Categories data (using the same from previous ProductsView)
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[
    {
      'name': 'Computers',
      'image': 'assets/images/computer.png',
      'color': Colors.blue,
      'fallbackIcon': Icons.computer,
    },
    {
      'name': 'Phone',
      'image': 'assets/images/phone.png',
      'color': Colors.orange,
      'fallbackIcon': Icons.phone_android,
    },
    {
      'name': 'Server Tool',
      'image': 'assets/images/server.png',
      'color': Colors.purple,
      'fallbackIcon': Icons.dns,
    },
    {
      'name': 'accessories',
      'image': 'assets/images/accessories.png',
      'color': Colors.red,
      'fallbackIcon': Icons.headphones,
    },
    {
      'name': 'Camera',
      'image': 'assets/images/camera.png',
      'color': Colors.green,
      'fallbackIcon': Icons.camera_alt,
    },
  ].obs;

  // Products data
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Trkil Tracker',
      'brand': 'Trkil',
      'price': '16.30',
      'originalPrice': '5.00',
      'image': 'assets/images/tracker1.png',
      'category': 'accessories',
    },
    {
      'id': '2',
      'name': 'Oppo A35 mobile..',
      'brand': 'Osaka',
      'price': '2500',
      'originalPrice': null,
      'image': 'assets/images/oppo_phone.png',
      'category': 'Phone',
    },
    {
      'id': '3',
      'name': 'CMF Buds By Noth..',
      'brand': 'Tribute',
      'price': '562',
      'originalPrice': null,
      'image': 'assets/images/cmf_buds.png',
      'category': 'accessories',
    },
    {
      'id': '4',
      'name': 'Nippon TV 40in',
      'brand': 'Nippon',
      'price': '500',
      'originalPrice': null,
      'image': 'assets/images/nippon_tv.png',
      'category': 'accessories',
    },
    {
      'id': '5',
      'name': 'Realme Phone',
      'brand': 'Realme',
      'price': '850',
      'originalPrice': null,
      'image': 'assets/images/realme_phone.png',
      'category': 'Phone',
    },
    {
      'id': '6',
      'name': 'ASUS Laptop',
      'brand': 'ASUS',
      'price': '1200',
      'originalPrice': null,
      'image': 'assets/images/asus_laptop.png',
      'category': 'Computers',
    },
  ].obs;

  // Filtered products based on search and category
  final RxList<Map<String, dynamic>> filteredProducts = <Map<String, dynamic>>[].obs;

  // Sort options for dropdown
  final List<String> sortOptions = [
    'Select Category',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'Name: Z to A',
    'Newest First',
    'Oldest First',
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Check if we received a ProductModel from Add Product view
    if (Get.arguments != null && Get.arguments is ProductModel) {
      final newProduct = Get.arguments as ProductModel;
      addProductFromAddProductView(newProduct);
    }
    
    // Initialize filtered products with all products
    filteredProducts.assignAll(allProducts);
    
    // Listen to search query changes
    debounce(searchQuery, (_) => filterProducts(), time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    filterProducts();
  }

  void filterProducts() {
    List<Map<String, dynamic>> filtered = allProducts.toList();

    // Filter by category if not "All" (index 0 could be "All" category)
    if (selectedCategoryIndex.value > 0) {
      final selectedCategory = categories[selectedCategoryIndex.value]['name'];
      filtered = filtered.where((product) => 
        product['category'].toString().toLowerCase() == 
        selectedCategory.toString().toLowerCase()
      ).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = product['name'].toString().toLowerCase();
        final brand = product['brand'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        
        return name.contains(query) || brand.contains(query);
      }).toList();
    }

    filteredProducts.assignAll(filtered);
  }

  void onProductTap(Map<String, dynamic> product) {
    print('Product tapped: ${product['name']}');
    // Navigate to product details
    Get.toNamed(Routes.productDetails, arguments: product);
  }

  void showCategoryDropdown() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...sortOptions.map((option) => ListTile(
              title: Text(option),
              onTap: () {
                selectedSortCategory.value = option;
                sortProducts(option);
                Get.back();
              },
              trailing: selectedSortCategory.value == option
                  ? Icon(Icons.check, color: Colors.green.shade600)
                  : null,
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void sortProducts(String sortOption) {
    List<Map<String, dynamic>> sorted = filteredProducts.toList();

    switch (sortOption) {
      case 'Price: Low to High':
        sorted.sort((a, b) {
          double priceA = double.tryParse(a['price'].toString()) ?? 0;
          double priceB = double.tryParse(b['price'].toString()) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) {
          double priceA = double.tryParse(a['price'].toString()) ?? 0;
          double priceB = double.tryParse(b['price'].toString()) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Name: A to Z':
        sorted.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
        break;
      case 'Name: Z to A':
        sorted.sort((a, b) => b['name'].toString().compareTo(a['name'].toString()));
        break;
      default:
        // Keep original order for other options
        break;
    }

    filteredProducts.assignAll(sorted);
  }

  void addToCart(Map<String, dynamic> product) {
    print('Added to cart: ${product['name']}');
    // Implement add to cart functionality
    Get.snackbar(
      'Added to Cart',
      '${product['name']} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  String getCurrentCategoryName() {
    if (selectedCategoryIndex.value < categories.length) {
      return categories[selectedCategoryIndex.value]['name'];
    }
    return 'All Categories';
  }

  int getProductCountForCurrentCategory() {
    return filteredProducts.length;
  }

  // Method to refresh products (for pull-to-refresh)
  Future<void> refreshProducts() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Reload products
    filterProducts();
    
    Get.snackbar(
      'Refreshed',
      'Products have been updated',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  // Add product from Add Product view
  void addProductFromAddProductView(ProductModel product) {
    // Convert ProductModel to the format used in category view
    Map<String, dynamic> newProduct = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': product.name,
      'brand': product.brand,
      'price': product.variants.isNotEmpty ? product.variants.first.price.toString() : '0',
      'originalPrice': null,
      'image': product.images.isNotEmpty ? product.images.first : 'assets/images/placeholder.png',
      'category': product.category,
      'images': product.images, // Store all images
      'colors': product.colors, // Store colors
      'variants': product.variants.map((v) => v.toJson()).toList(), // Store variants
      'model': product.model,
      'subCategory': product.subCategory,
      'specialCategory': product.specialCategory,
      'finish': product.finish,
      'createdAt': product.createdAt.toIso8601String(),
    };
    
    // Add to the beginning of the list
    allProducts.insert(0, newProduct);
    
    // Update filtered products to show the new product
    filterProducts();
    
    // Show success message
    Get.snackbar(
      'Success',
      'Product added successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
  }
}