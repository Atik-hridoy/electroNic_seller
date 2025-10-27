import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/core/util/app_logger.dart';
import 'model/get_product_category_model.dart';
import 'model/get_product_brands_model.dart';
import 'services/get_product_category_service.dart';
import 'services/get_product_brand_service.dart';

class ProductsController extends GetxController {
  // Services
  late final ProductCategoryService _categoryService;
  late final ProductBrandService _brandService;
  
  // Observable variables
  final RxBool isLoading = true.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<BrandModel> brands = <BrandModel>[].obs;
  final RxString errorMessage = ''.obs;
  final String tag = 'ProductsController';
  
  // Sample brand data - fallback in case API fails
  final List<BrandModel> _sampleBrands = [
    BrandModel(
      id: '1',
      name: 'Samsung',
      image: 'https://via.placeholder.com/100',
      isActive: true,
    ),
    BrandModel(
      id: '2',
      name: 'Apple',
      image: 'https://via.placeholder.com/100',
      isActive: true,
    ),
    BrandModel(
      id: '3',
      name: 'Sony',
      image: 'https://via.placeholder.com/100',
      isActive: true,
    ),
    BrandModel(
      id: '4',
      name: 'LG',
      image: 'https://via.placeholder.com/100',
      isActive: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('Initializing ProductsController...', tag: tag);
    _initializeServices();
    loadCategories();
    loadBrands();
  }
  
  // Load brands from API with fallback to sample data
  Future<void> loadBrands() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _brandService.getProductBrands();
      
      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> brandData = response.body['data'] ?? [];
        
        // Convert each brand data to BrandModel
        final List<BrandModel> loadedBrands = [];
        for (var brand in brandData) {
          try {
            loadedBrands.add(BrandModel.fromJson(brand));
          } catch (e) {
            AppLogger.error('Error parsing brand: $e', tag: tag);
          }
        }
        
        // Update the observable list
        brands.value = loadedBrands;
        
        // If no brands from API, use sample data
        if (brands.isEmpty) {
          brands.value = _sampleBrands;
        }
      } else {
        // If API fails, use sample data
        brands.value = _sampleBrands;
        errorMessage.value = 'Using sample brand data';
      }
    } catch (e) {
      // On error, use sample data
      brands.value = _sampleBrands;
      errorMessage.value = 'Error loading brands: ${e.toString()}';
      AppLogger.error('Error fetching brands: $e', tag: tag);
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeServices() {
    try {
      AppLogger.debug('Initializing services...', tag: tag);
      
      // Initialize ProductCategoryService if not already registered
      if (!Get.isRegistered<ProductCategoryService>()) {
        AppLogger.info('Registering ProductCategoryService...', tag: tag);
        Get.put(ProductCategoryService());
      }
      _categoryService = Get.find<ProductCategoryService>();
      
      // Initialize ProductBrandService if not already registered
      if (!Get.isRegistered<ProductBrandService>()) {
        AppLogger.info('Registering ProductBrandService...', tag: tag);
        Get.put(ProductBrandService());
      }
      _brandService = Get.find<ProductBrandService>();
      
      AppLogger.success('Services initialized successfully', tag: tag);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize services', 
        tag: 'ProductsController', 
        error: e, 
        stackTrace: stackTrace
      );
      rethrow;
    }
  }

  // Load categories from the service
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.info('Fetching product categories...', tag: tag);
      
      final response = await _categoryService.getProductCategories();
      
      // Log API response
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: 'categories',
        statusCode: response.statusCode ?? 0, // Provide default value 0 if statusCode is null
        responseData: response.body,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'] ?? [];
        AppLogger.info('Found ${data.length} categories', tag: tag);
        
        // Log each category
        for (var category in data) {
          AppLogger.debug('Category: ${category['name']} (ID: ${category['_id']})', tag: tag);
        }
        
        categories.value = data.map((category) => CategoryModel.fromJson(category)).toList();
        AppLogger.success('Successfully loaded ${categories.length} categories', tag: tag);
      } else {
        final errorMsg = 'Failed to load categories: ${response.statusCode} - ${response.statusText}';
        errorMessage.value = errorMsg;
        AppLogger.error(errorMsg, tag: tag);
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Error loading categories: ${e.toString()}';
      errorMessage.value = errorMsg;
      AppLogger.error(
        errorMsg,
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
      AppLogger.debug('Category loading completed', tag: tag);
    }
  }

  // Button handlers
  void onAddProductTap() {
    Get.toNamed(Routes.addProduct);
  }

  void onSeeAllTap() {
    Get.toNamed(Routes.category);
  }

  void onCategoryTap(CategoryModel category) {
    // Navigate to add product view with the selected category ID and name
    Get.toNamed(
      Routes.addProduct,
      arguments: {
        'categoryId': category.id,
        'categoryName': category.name,
      },
    );
  }

  // Fallback icon for categories
  IconData getFallbackIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return Icons.computer;
      case 'phone':
        return Icons.phone_android;
      case 'server tool':
        return Icons.storage;
      default:
        return Icons.category;
    }
  }
}