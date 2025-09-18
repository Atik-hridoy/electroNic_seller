import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_product_controller.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Card
            _buildSectionCard(
              title: 'Category',
              required: true,
              child: _buildDropdown(
                value: controller.selectedCategory.value,
                items: controller.categories,
                onChanged: controller.updateCategory,
              ),
            ),

            // Sub-category Card
            _buildSectionCard(
              title: 'Sub-category',
              required: true,
              child: _buildDropdown(
                value: controller.selectedSubCategory.value,
                items: controller.subCategories,
                onChanged: controller.updateSubCategory,
              ),
            ),

            // Product Image Card
            _buildSectionCard(
              title: 'Product Image',
              required: true,
              child: _buildImageSection(controller),
            ),

            // Product Name Card
            _buildSectionCard(
              title: 'Product Name',
              required: true,
              child: _buildTextField(
                controller: controller.productNameController,
                hintText: 'Nipson TV 40in',
              ),
            ),

            // Model Card
            _buildSectionCard(
              title: 'Model',
              required: true,
              child: _buildTextField(
                controller: controller.modelController,
                hintText: 'LED 125',
              ),
            ),

            // Brand Card
            _buildSectionCard(
              title: 'Brand',
              required: true,
              child: _buildDropdown(
                value: controller.selectedBrand.value,
                items: controller.brands,
                onChanged: controller.updateBrand,
              ),
            ),

            // Color Card
            _buildSectionCard(
              title: 'Color',
              required: true,
              child: _buildColorSection(controller),
            ),

            // Product Details Card
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // First Row: Type/Size and Price
                    Row(
                      children: [
                        // Left: Type/Size
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Type/Size',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                controller: controller.modelController,
                                hintText: 'Enter type or size',
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Right: Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPriceSection(controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second Row: Purchase Price and Profit Price
                    Row(
                      children: [
                        // Left: Purchase Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Purchase Price*',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPurchasePriceSection(controller),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Right: Profit Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profit Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildProfitPriceSection(controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Third Row: Quantity (spans both columns)
                  Row(
                    children: [
                      // Quantity field spanning full width
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildQuantitySection(controller),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton.icon(
                                onPressed: controller.addProduct,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                label: const Text(
                                  'Add Product',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),

            // Special Category Card
            _buildSectionCard(
              title: 'Product Special Category',
              required: true,
              child: _buildDropdown(
                value: controller.selectedSpecialCategory.value,
                items: controller.specialCategories,
                onChanged: controller.updateSpecialCategory,
              ),
            ),

            // Details Card
            _buildSectionCard(
              title: 'Details',
              child: _buildTextField(
                controller: controller.finishController,
                hintText: 'Enter product details...',
              ),
            ),

            // Submit Button Card
            _buildSectionCard(
              title: 'Submit Product',
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 14,
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (newValue) => onChanged(newValue ?? ''),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildImageSection(AddProductController controller) {
    return Obx(() => Row(
          children: [
            ...controller.productImages.asMap().entries.map((entry) {
              int index = entry.key;
              final path = entry.value;
              return Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(path)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(index),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 10),
                    ),
                  ),
                ),
              );
            }),
            if (controller.productImages.length < controller.maxImages)
              GestureDetector(
                //onTap: controller.addDummyImage,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Icon(Icons.add,
                      color: Color(0xFF999999), size: 24),
                ),
              ),
          ],
        ));
  }

  Widget _buildColorSection(AddProductController controller) {
    return Obx(() => Wrap(
          spacing: 12,
          children: controller.colors.map((color) {
            bool isSelected = controller.selectedColors.contains(color);
            return GestureDetector(
              onTap: () => controller.toggleColor(color),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.blue : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColorFromName(color),
                        shape: BoxShape.circle,
                        border: color.toLowerCase() == 'white'
                            ? Border.all(color: const Color(0xFFE0E0E0))
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      color,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isSelected ? Colors.blue : const Color(0xFF666666),
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.close, size: 14, color: Colors.blue),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildPriceSection(AddProductController controller) {
    return Obx(() {
      // Reference the observable variable to trigger rebuilds when it changes
      final currentPrice = controller.currentPrice.value;
      return Column(
          children: [
            // Price Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: TextFormField(
                controller: controller.priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  hintStyle: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Color(0xFF666666),
                    size: 20,
                  ),
                ),
                onChanged: (value) {
                  // Update the observable price when text changes
                  try {
                    final price = double.tryParse(value) ?? 0.0;
                    controller.currentPrice.value = price;
                  } catch (e) {
                    controller.currentPrice.value = 0.0;
                  }
                },
              ),
            ),
            
          ],
        );
    });
  }

  Widget _buildPurchasePriceSection(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller.saleTypeController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: const Icon(
            Icons.attach_money,
            color: Color(0xFF666666),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfitPriceSection(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller.brandController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: const Icon(
            Icons.attach_money,
            color: Color(0xFF666666),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySection(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller.quantityController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter quantity',
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: const Icon(
            Icons.inventory_2,
            color: Color(0xFF666666),
            size: 20,
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionCard({
    required String title,
    bool required = false,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                if (required)
                  const Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
