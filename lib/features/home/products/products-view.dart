import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildButtonRow(),
            const SizedBox(height: 24),
            _buildCategoryGrid(),
          ],
        ),
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
          side: BorderSide(
            color: Colors.green.shade300,
            width: 2,
          ),
        ),
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 24,
          ),
          const SizedBox(width: 8),
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

  Widget _buildCategoryGrid() {
    final categories = controller.getCategories();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(
          category['name'] as String,
          category['image'] as String,
          category['color'] as Color,
        );
      },
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
          Icon(
            Icons.list_alt,
            size: 24,
          ),
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

  Widget _buildCategoryItem(String name, String imagePath, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => controller.onCategoryTap(name),
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.1),
            foregroundColor: color,
            elevation: 2,
            shadowColor: color.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            minimumSize: const Size(56, 56),
            maximumSize: const Size(56, 56),
            padding: EdgeInsets.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image not found
                return Icon(
                  controller.getFallbackIcon(name),
                  color: color.withValues(alpha: 0.7),
                  size: 28,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}