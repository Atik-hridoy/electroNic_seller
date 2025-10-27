import 'package:electronic/features/home/everything_related_products/category/model/get_model.dart';
import 'package:electronic/features/home/everything_related_products/category/services/get_allProducts_service.dart';
import 'package:electronic/features/home/everything_related_products/products_view/products_controller.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../products_view/product_model.dart';


class CategoryController extends GetxController {
  final GetAllProductsService _productsService = Get.put(GetAllProductsService());

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Category selection
  final RxInt selectedCategoryIndex = 0.obs;
  final RxString selectedSortCategory = 'Select Category'.obs;

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalProducts = 0.obs;
  final int limit = 10;

  // Get categories from ProductsController
  RxList<Map<String, dynamic>> get categories {
    try {
      final productsController = Get.find<ProductsController>();
      
      // Start with 'All' category
      final allCategories = <Map<String, dynamic>>[
        {
          'id': 'all',
          'name': 'All',
          'image': 'assets/images/all.png',
          'color': Colors.grey,
          'fallbackIcon': Icons.apps,
        }
      ];
      
      // Add dynamic categories from ProductsController
      if (productsController.categories.isNotEmpty) {
        allCategories.addAll(productsController.categories.map((category) {
          final categoryName = category.name.isNotEmpty ? category.name : 'Unnamed Category';
          String image = category.thumbnail.isNotEmpty 
              ? category.thumbnail 
              : _getDefaultCategoryImage(categoryName);
          if (image.isNotEmpty && !image.startsWith('http')) {
            image = '${AppUrls.imageBaseUrl}$image';
          }
          return {
            'id': category.id,
            'name': categoryName,
            'image': image,
            'color': _getCategoryColor(categoryName),
            'fallbackIcon': _getFallbackIcon(categoryName),
          };
        }).toList());
      } else {
        // Fallback categories if ProductsController hasn't loaded yet or has no categories
        allCategories.addAll([
          {
            'id': 'computers',
            'name': 'Computers',
            'image': 'assets/images/computer.png',
            'color': Colors.blue,
            'fallbackIcon': Icons.computer,
          },
          {
            'id': 'phone',
            'name': 'Phone',
            'image': 'assets/images/phone.png',
            'color': Colors.orange,
            'fallbackIcon': Icons.phone_android,
          },
        ]);
      }
      
      return allCategories.obs;
    } catch (e) {
      // In case ProductsController is not found or any other error occurs
      return <Map<String, dynamic>>[
        {
          'id': 'all',
          'name': 'All',
          'image': 'assets/images/all.png',
          'color': Colors.grey,
          'fallbackIcon': Icons.apps,
        },
        {
          'id': 'computers',
          'name': 'Computers',
          'image': 'assets/images/computer.png',
          'color': Colors.blue,
          'fallbackIcon': Icons.computer,
        },
        {
          'id': 'phone',
          'name': 'Phone',
          'image': 'assets/images/phone.png',
          'color': Colors.orange,
          'fallbackIcon': Icons.phone_android,
        },
      ].obs;
    }
  }
  
  // Helper methods for category properties
  String _getDefaultCategoryImage(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return 'assets/images/computer.png';
      case 'phone':
        return 'assets/images/phone.png';
      case 'server tool':
        return 'assets/images/server.png';
      case 'accessories':
        return 'assets/images/accessories.png';
      case 'camera':
        return 'assets/images/camera.png';
      default:
        return 'assets/images/all.png';
    }
  }
  
  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return Colors.blue;
      case 'phone':
        return Colors.orange;
      case 'server tool':
        return Colors.purple;
      case 'accessories':
        return Colors.red;
      case 'camera':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getFallbackIcon(String categoryName) {
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
      default:
        return Icons.category;
    }
  }

  // Products data from API
  final RxList<ProductData> apiProducts = <ProductData>[].obs;
  
  // Converted products for display
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;

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
    
    // Initialize products
    _initializeProducts();
    
    // Ensure ProductsController is initialized
    Get.put(ProductsController());
    
    // Listen to category updates from ProductsController
    try {
      final productsController = Get.find<ProductsController>();
      ever(productsController.categories, (_) {
        // Refresh products when categories are updated
        fetchProducts(isRefresh: true);
        update(); // Notify listeners that categories might have changed
      });
    } catch (e) {
      // If ProductsController is not available, continue without the listener
      // The categories getter has a fallback mechanism
    }
  }
  
  void _initializeProducts() {
    // Load products from API
    fetchProducts();
    
    // Check if we received a ProductModel from Add Product view
    if (Get.arguments != null && Get.arguments is ProductModel) {
      final newProduct = Get.arguments as ProductModel;
      addProductFromAddProductView(newProduct);
    }
    
    // Listen to search query changes
    debounce(searchQuery, (_) => fetchProducts(isRefresh: true), 
      time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch products from API
  Future<void> fetchProducts({
    bool isRefresh = false, 
    bool loadMore = false,
    String? categoryId,
  }) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        isLoading.value = true;
      } else if (loadMore) {
        if (currentPage.value >= totalPages.value) return;
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      errorMessage.value = '';

      // If no categoryId provided, get it from selected index
      if (categoryId == null && 
          selectedCategoryIndex.value > 0 && 
          selectedCategoryIndex.value < categories.length) {
        categoryId = categories[selectedCategoryIndex.value]['id'];
      }

      // Fetch products from API
      final response = await _productsService.getAllProducts(
        page: currentPage.value,
        limit: limit,
        categoryId: categoryId,
        searchQuery: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      // Update pagination info
      totalPages.value = response.meta.totalPage;
      totalProducts.value = response.meta.total;

      // Convert API products to display format
      final convertedProducts = response.data.map((product) => 
        _convertProductDataToMap(product)
      ).toList();

      if (loadMore) {
        // Append to existing products
        allProducts.addAll(convertedProducts);
      } else {
        // Replace products
        apiProducts.value = response.data;
        allProducts.value = convertedProducts;
      }

      // Update filtered products
      filteredProducts.value = allProducts;

      // Apply sorting if needed
      if (selectedSortCategory.value != 'Select Category') {
        sortProducts(selectedSortCategory.value);
      }

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Convert ProductData to Map for display
  Map<String, dynamic> _convertProductDataToMap(ProductData product) {
    double price = product.sizeType.isNotEmpty 
      ? product.sizeType.first.price 
      : 0.0;
    
    double? originalPrice;
    if (product.sizeType.isNotEmpty && product.sizeType.first.discount > 0) {
      originalPrice = price + product.sizeType.first.discount;
    }

    String mainImage = product.images.isNotEmpty ? product.images.first : '';
    if (mainImage.isNotEmpty && !mainImage.startsWith('http') && !mainImage.startsWith('assets/')) {
      mainImage = '${AppUrls.imageBaseUrl}$mainImage';
    }
    final normalizedImages = product.images.map((img) {
      if (img.isNotEmpty && !img.startsWith('http') && !img.startsWith('assets/')) {
        return '${AppUrls.imageBaseUrl}$img';
      }
      return img;
    }).toList();

    String sellerImage = product.seller.image ?? '';
    if (sellerImage.isNotEmpty && !sellerImage.startsWith('http') && !sellerImage.startsWith('assets/')) {
      sellerImage = '${AppUrls.imageBaseUrl}$sellerImage';
    }

    return {
      'id': product.id,
      'name': product.name,
      'brand': product.brand,
      'price': price.toStringAsFixed(2),
      'originalPrice': originalPrice?.toStringAsFixed(2),
      'image': mainImage,
      'category': product.category,
      'subCategory': product.subCategory,
      'model': product.model,
      'images': normalizedImages,
      'colors': product.color,
      'variants': product.sizeType.map((v) => {
        'size': v.size,
        'price': v.price,
        'quantity': v.quantity,
        'discount': v.discount,
        'purchasePrice': v.purchasePrice,
        'profit': v.profit,
      }).toList(),
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'totalStock': product.totalStock,
      'specialCategory': product.specialCategory,
      'overview': product.overview,
      'highlights': product.highlights,
      'techSpecs': product.techSpecs,
      'seller': {
        'id': product.seller.id,
        'firstName': product.seller.firstName,
        'lastName': product.seller.lastName,
        'image': sellerImage,
      },
      'createdAt': product.createdAt.toIso8601String(),
      'updatedAt': product.updatedAt.toIso8601String(),
    };
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void selectCategory(int index) {
    try {
      // Ensure we have valid categories before proceeding
      if (categories.isEmpty) return;
      
      // Clamp the index to valid range
      final safeIndex = index.clamp(0, categories.length - 1);
      selectedCategoryIndex.value = safeIndex;
      
      // If 'All' is selected, clear the category filter
      if (safeIndex == 0) {
        fetchProducts(isRefresh: true);
        return;
      }
      
      // Get the selected category ID safely
      if (safeIndex < categories.length) {
        final selectedCategory = categories[safeIndex];
        final categoryId = selectedCategory['id'];
        if (categoryId != null) {
          fetchProducts(isRefresh: true, categoryId: categoryId.toString());
        } else {
          fetchProducts(isRefresh: true);
        }
      } else {
        // Fallback to fetching all products if index is out of bounds
        fetchProducts(isRefresh: true);
      }
    } catch (e) {
      // If any error occurs, fallback to fetching all products
      selectedCategoryIndex.value = 0;
      fetchProducts(isRefresh: true);
    }
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
      case 'Newest First':
        sorted.sort((a, b) {
          DateTime dateA = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime.now();
          DateTime dateB = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime.now();
          return dateB.compareTo(dateA);
        });
        break;
      case 'Oldest First':
        sorted.sort((a, b) {
          DateTime dateA = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime.now();
          DateTime dateB = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime.now();
          return dateA.compareTo(dateB);
        });
        break;
      default:
        // Keep original order
        break;
    }

    filteredProducts.assignAll(sorted);
  }

  void addToCart(Map<String, dynamic> product) {
    print('Added to cart: ${product['name']}');
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
    return totalProducts.value;
  }

  // Method to refresh products (for pull-to-refresh)
  Future<void> refreshProducts() async {
    await fetchProducts(isRefresh: true);
    
    Get.snackbar(
      'Refreshed',
      'Products have been updated',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  // Load more products (for pagination)
  Future<void> loadMoreProducts() async {
    if (!isLoadingMore.value && currentPage.value < totalPages.value) {
      await fetchProducts(loadMore: true);
    }
  }

  // Add product from Add Product view
  void addProductFromAddProductView(ProductModel product) {
    Map<String, dynamic> newProduct = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': product.name,
      'brand': product.brand,
      'price': product.variants.isNotEmpty ? product.variants.first.price.toString() : '0',
      'originalPrice': null,
      'image': product.images.isNotEmpty ? product.images.first : 'assets/images/placeholder.png',
      'category': product.category,
      'images': product.images,
      'colors': product.colors,
      'variants': product.variants.map((v) => v.toJson()).toList(),
      'model': product.model,
      'subCategory': product.subCategory,
      'specialCategory': product.specialCategory,
      'finish': product.finish,
      'createdAt': product.createdAt.toIso8601String(),
    };
    
    allProducts.insert(0, newProduct);
    filteredProducts.insert(0, newProduct);
    
    Get.snackbar(
      'Success',
      'Product added successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
  }

  // Retry loading products on error
  void retryLoading() {
    fetchProducts(isRefresh: true);
  }
}