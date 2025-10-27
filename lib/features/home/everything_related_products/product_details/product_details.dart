import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImages(),
            const SizedBox(height: 24),
            _buildProductInfo(),
            const SizedBox(height: 24),
            _buildProductDescription(),
            const SizedBox(height: 24),
            _buildReviewsSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Obx(() => Text(
                '${controller.totalReviews} reviews • ${controller.averageRating.value.toStringAsFixed(1)}/5',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.reviews.isEmpty) {
              return Text(
                'No reviews yet',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              );
            }
            return Column(
              children: controller.reviews.map((r) {
                final rating = (r['rating'] as int? ?? 0).clamp(0, 5);
                final String avatar = (r['image']?.toString() ?? '').trim();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReviewerAvatar(avatar, r['reviewer']?.toString()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  r['reviewer']?.toString() ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  (r['createdAt']?.toString() ?? '').split('T').first,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (i) => Icon(
                                i < rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber[600],
                              )),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              r['comment']?.toString() ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildReviewerAvatar(String avatar, String? reviewerName) {
    final double size = 36;
    if (avatar.isNotEmpty) {
      String img = avatar;
      if (!img.startsWith('http') && !img.startsWith('assets/') && !(img.startsWith('/') || img.contains(':')) ) {
        img = '${AppUrls.imageBaseUrl}$img';
      }
      if (img.startsWith('http')) {
        return CircleAvatar(radius: size/2, backgroundImage: NetworkImage(img));
      }
      if (img.startsWith('/') || img.contains(':')) {
        return CircleAvatar(radius: size/2, backgroundImage: FileImage(File(img)));
      }
      return CircleAvatar(radius: size/2, backgroundImage: AssetImage(img));
    }
    final initial = (reviewerName?.isNotEmpty == true ? reviewerName!.substring(0,1).toUpperCase() : 'A');
    return CircleAvatar(
      radius: size/2,
      backgroundColor: Colors.blue[50],
      child: Text(
        initial,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildDetailImage(String path) {
    String imagePath = path;
    if (imagePath.isNotEmpty &&
        !imagePath.startsWith('http') &&
        !imagePath.startsWith('assets/') &&
        !(imagePath.startsWith('/') || imagePath.contains(':'))) {
      imagePath = '${AppUrls.imageBaseUrl}$imagePath';
    }
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image,
              color: Colors.grey[400],
              size: 30,
            ),
          );
        },
      );
    }
    if (imagePath.startsWith('/') || imagePath.contains(':')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.image,
              color: Colors.grey[400],
              size: 30,
            ),
          );
        },
      );
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Icon(
            Icons.image,
            color: Colors.grey[400],
            size: 30,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Products Details',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: ElevatedButton.icon(
            onPressed: controller.onEditTap,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImages() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: controller.productImages.map((imagePath) {
            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildDetailImage(imagePath),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.productName.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.brandName.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Obx(() => Text(
                    controller.quantity.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(() => Text(
                '\$${controller.currentPrice.value}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),
              const SizedBox(width: 8),
              Obx(() => Text(
                '\$${controller.originalPrice.value}',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.red[400],
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Size: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableSizes.map((sizeOption) {
                  final isSelected = controller.selectedSize.value == sizeOption;
                  return GestureDetector(
                    onTap: () => controller.updateSelectedSize(sizeOption),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sizeOption,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Color: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => Row(
                children: controller.availableColors.map((color) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
            controller.productOverview.value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          )),
          const SizedBox(height: 20),
          const Text(
            'Highlights:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.highlights.map((highlight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  highlight,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 20),
          const Text(
            'Tech Specs:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.techSpecs.map((spec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  spec,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
}