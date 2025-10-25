import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/features/home/everything_related_products/products_view/model/get_product_category_model.dart';
import 'package:electronic/features/home/everything_related_products/products_view/model/get_product_brands_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        // If still loading → show skeletons
        if (controller.isLoading.value) {
          return Skeletonizer(
            enabled: true,
            child: _buildSkeletonView(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildButtonRow(),
              const SizedBox(height: 24),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoryGrid(),
              const SizedBox(height: 24),
              const Text(
                'Brands',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildBrandsGrid(),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 Skeleton layout used while loading
  Widget _buildSkeletonView() {
    // Fake structure mimicking real layout
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildButtonRow(),
          const SizedBox(height: 24),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: 8,
            itemBuilder: (_, __) => Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Brands',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (_, __) => Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(width: 60, height: 10, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 40, height: 8, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        Expanded(
          child: _buildAddProductButton(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSeeAllButton(),
        ),
      ],
    );
  }

  Widget _buildAddProductButton() {
    return ElevatedButton(
      onPressed: controller.onAddProductTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade600,
        elevation: 4,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 24),
          SizedBox(width: 8),
          Text(
            'Add Product',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return ElevatedButton(
      onPressed: controller.onSeeAllTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade800,
        elevation: 4,
        shadowColor: Colors.blue.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.blue.shade300,
            width: 2,
          ),
        ),
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 24),
          SizedBox(width: 8),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Obx(() {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return _buildCategoryItem(category);
        },
      );
    }
  );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    final color = _getCategoryColor(category.name);
    
    return GestureDetector(
      onTap: () => controller.onCategoryTap(category),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: category.thumbnail.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: '${AppUrls.imageBaseUrl}${category.thumbnail.startsWith('/') ? category.thumbnail.substring(1) : category.thumbnail}',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: Icon(
                          controller.getFallbackIcon(category.name),
                          color: color,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[100],
                    child: Icon(
                      controller.getFallbackIcon(category.name),
                      color: color,
                      size: 24,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsGrid() {
    return Obx(() {
      return SizedBox(
        height: 120, // Increased height to accommodate all content
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.brands.length,
          itemBuilder: (context, index) {
            final brand = controller.brands[index];
            return _buildBrandItem(brand);
          },
        ),
      );
    });
  }

  Widget _buildBrandItem(BrandModel brand) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand Logo Container
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(4), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: brand.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: '${AppUrls.imageBaseUrl}${brand.image.startsWith('/') ? brand.image.substring(1) : brand.image}',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.broken_image, size: 24),
                      ),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.branding_watermark, size: 24),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          // Brand Name
          Text(
            brand.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Product Count
          Text(
            '0 products',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryName) {
    // You can customize colors based on category names
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return Colors.blue;
      case 'phone':
        return Colors.orange;
      case 'server tool':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}