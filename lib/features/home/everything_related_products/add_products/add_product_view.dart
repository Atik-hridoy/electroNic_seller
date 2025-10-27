import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'add_product_controller.dart';
import '../products_view/model/get_product_category_model.dart';
import 'product_variant_model.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

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
              child: _buildDropdown<CategoryModel>(
                value: controller.selectedCategory.value,
                items: controller.categories,
                onChanged: controller.updateCategory,
                itemAsString: (category) => category.name,
              ),
            ),

            // Sub Category Card - Only show when a category is selected
            Obx(() => controller.selectedCategory.value.name.isNotEmpty && controller.availableSubcategories.isNotEmpty
              ? _buildSectionCard(
                  title: 'Sub Category',
                  required: true,
                  child: _buildDropdown<Subcategory>(
                    value: controller.selectedSubCategory.value,
                    items: controller.availableSubcategories,
                    onChanged: controller.updateSubCategory,
                    itemAsString: (subcategory) => subcategory.name,
                  ),
                )
              : const SizedBox()),

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
              child: _buildDropdown<String>(
                value: controller.selectedBrand.value,
                items: controller.brands,
                onChanged: controller.updateBrand,
                itemAsString: (brand) => brand,
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
                                controller: controller.sizeController,
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
                  
                  // Discount Price
                  _buildSectionCard(
                    title: 'Discount Price',
                    required: false,
                    child: _buildTextField(
                      controller: controller.discountPriceController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Fourth Row: Quantity (spans both columns)
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
                                onPressed: controller.addProductVariant,
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
                                  'Add Variant',
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

            // Product Variants Section
            _buildVariantsSection(controller),

            // Special Category Card
            _buildSectionCard(
              title: 'Product Special Category',
              required: true,
              child: _buildDropdown<String>(
                value: controller.selectedSpecialCategory.value,
                items: controller.specialCategories,
                onChanged: controller.updateSpecialCategory,
                itemAsString: (category) => category,
              ),
            ),

            // Details Card
            // _buildSectionCard(
            //   title: 'Details',
            //   child: _buildTextField(
            //     controller: controller.finishController,
            //     hintText: 'Enter product details...',
            //   ),
            // ),

            // Technical Specifications Card
            _buildSectionCard(
              title: 'Overview',
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9FCFF)),
                ),
                child: TextField(
                  controller: controller.techSpecController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Overview',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Technical Specifications Card
            _buildSectionCard(
              title: 'Highlight',
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9FCFF)),
                ),
                child: TextField(
                  controller: controller.techSpecController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Highlight',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Technical Specifications Card
            _buildSectionCard(
              title: 'Technical Specifications',
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9FCFF)),
                ),
                child: TextField(
                  controller: controller.techSpecController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Technical Specifications',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Submit Button Card
            _buildSectionCard(
              title: 'Submit Product',
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Product',
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

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required Function(T) onChanged,
    required String Function(T) itemAsString,
  }) {
  // Ensure we have a valid value that exists in items, or use the first item
  final selectedValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : null);
  
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFE9FCFF)),
    ),
    child: DropdownButtonFormField<T>(
      initialValue: selectedValue,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
      ),
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemAsString(item)),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
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
    return Obx(() => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Display existing images
            ...controller.productImages.asMap().entries.map((entry) {
              int index = entry.key;
              final path = entry.value;
              return Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ),
                ],
              );
            }),
            
            // Add image button
            if (controller.productImages.length < controller.maxImages)
              GestureDetector(
                onTap: () => _pickImage(controller),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: const Color(0xFF999999),
                        size: 24,
                      ),
                      Text(
                        '${controller.productImages.length + 1}/5',
                        style: TextStyle(
                          color: const Color(0xFF999999),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ));
  }

  // Method to pick image from gallery or camera
  void _pickImage(AddProductController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add Photo'),
        content: const Text('Choose how you want to add a photo'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _pickImageFromSource(controller, ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _pickImageFromSource(controller, ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Method to pick image from specific source (camera or gallery)
  Future<void> _pickImageFromSource(AddProductController controller, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      
      if (image != null) {
        controller.addImage(image.path);
        
        // Show snackbar to indicate image was added
        Get.snackbar(
          'Image Added',
          'Image ${controller.productImages.length} of ${controller.maxImages} added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Widget _buildColorSection(AddProductController controller) {
  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Colors Preview
        if (controller.selectedColors.isNotEmpty) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.selectedColors.map((color) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getColorFromName(color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getColorFromName(color),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: _getColorFromName(color),
                          shape: BoxShape.circle,
                          border: color.toLowerCase() == 'white'
                              ? Border.all(color: Colors.grey.shade300)
                              : null,
                        ),
                      ),
                      Text(
                        color,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => controller.toggleColor(color),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Color Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            mainAxisExtent: 36,
          ),
          itemCount: controller.colors.length,
          itemBuilder: (context, index) {
            final color = controller.colors[index];
            final isSelected = controller.selectedColors.contains(color);
            final colorValue = _getColorFromName(color);
            
            return GestureDetector(
              onTap: () => controller.toggleColor(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? colorValue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? colorValue : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: colorValue,
                        shape: BoxShape.circle,
                        border: color.toLowerCase() == 'white'
                            ? Border.all(color: Colors.grey.shade300)
                            : null,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        color,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? colorValue : Colors.grey.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 2),
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: colorValue,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
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
        controller: controller.purchasePriceController,
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
        controller: controller.profitPriceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        onChanged: (value) {
          // You can add any validation or formatting logic here
        },
      ),
    );
  }

  Widget _buildDiscountPriceSection(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller.discountPriceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        onChanged: (value) {
          // You can add any validation or formatting logic here
        },
      ),
    );
  }

  Widget _buildQuantityDiscountPriceSection(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: TextFormField(
        controller: controller.quantityDiscountPriceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        onChanged: (value) {
          // You can add any validation or formatting logic here
        },
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

  // Product Variants Section
  Widget _buildVariantsSection(AddProductController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.productVariants.isNotEmpty) ...[
          const Text(
            'Product Variants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
        ...controller.productVariants.map((variant) => _buildVariantCard(controller, variant)),
          const SizedBox(height: 16),
        ],
      ],
    ));
  }

  // Variant Card Widget
  Widget _buildVariantCard(AddProductController controller, ProductVariant variant) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    child: Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with size and delete button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type/Size and Quantity with enhanced styling
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            variant.size,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, 
                              size: 16, 
                              color: Colors.grey[600]
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${variant.quantity} pieces',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => controller.removeProductVariant(variant.id),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      tooltip: 'Remove variant',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Price information grid with enhanced cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Price and Purchase Price Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriceItem(
                            icon: Icons.attach_money,
                            label: 'Selling Price',
                            value: '\$${variant.price.toStringAsFixed(2)}',
                            color: Colors.purple,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          child: _buildPriceItem(
                            icon: Icons.shopping_cart_outlined,
                            label: 'Purchase',
                            value: '\$${variant.purchasePrice.toStringAsFixed(2)}',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    
                    Divider(height: 24, thickness: 1, color: Colors.grey.shade300),
                    
                    // Profit and Discount Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriceItem(
                            icon: Icons.trending_up,
                            label: 'Profit',
                            value: '\$${variant.profitPrice.toStringAsFixed(2)}',
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          child: _buildPriceItem(
                            icon: Icons.local_offer_outlined,
                            label: 'Discount',
                            value: '\$${variant.discountPrice.toStringAsFixed(2)}',
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Helper widget for price items
Widget _buildPriceItem({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    ],
  );
}

  // Helper method for building slip rows
  Widget _buildSlipRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}