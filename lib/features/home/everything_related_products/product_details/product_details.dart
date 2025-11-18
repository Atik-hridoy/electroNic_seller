import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic/core/constants/app_urls.dart';
import 'product_details_controller.dart';
import 'widgets/edit_product_dialog.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  'Loading product details...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.productImages.isNotEmpty) _buildProductImages(),
              if (controller.productImages.isNotEmpty) const SizedBox(height: 24),
              _buildProductInfo(),
              const SizedBox(height: 24),
              _buildProductDescription(),
              const SizedBox(height: 24),
              _buildReviewsSection(),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
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
            children: [
              const Icon(Icons.rate_review, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
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
            // Debug print
            print('Feedbacks count: ${controller.feedbacks.length}');
            
            if (controller.feedbacks.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      'No reviews yet',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: controller.feedbacks.map((feedback) {
                final rating = feedback.rating.clamp(0, 5);
                final String avatar = feedback.userId.image.trim();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReviewerAvatar(avatar, feedback.userId.fullName),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  feedback.userId.fullName.isNotEmpty 
                                      ? feedback.userId.fullName 
                                      : 'Anonymous',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  feedback.createdAt.toString().split(' ').first,
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
                              feedback.comment,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                            // Show feedback images if any
                            if (feedback.images.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: feedback.images.take(3).map((img) {
                                  final imageUrl = img.startsWith('http') 
                                      ? img 
                                      : '${AppUrls.baseImageUrl}$img';
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image, color: Colors.grey[400]),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
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
      
      // Check if it's already a full URL
      if (img.startsWith('http://') || img.startsWith('https://')) {
        return CircleAvatar(radius: size/2, backgroundImage: NetworkImage(img));
      }
      
      // Check if it's a local file path
      bool isLocalFilePath = img.contains(':') || 
                             (img.startsWith('/') && (img.startsWith('/data/') || 
                              img.startsWith('/storage/') || 
                              img.startsWith('/var/') ||
                              img.contains('/cache/') ||
                              img.contains('/files/')));
      
      if (isLocalFilePath) {
        return CircleAvatar(radius: size/2, backgroundImage: FileImage(File(img)));
      }
      
      // Check if it's an asset path
      if (img.startsWith('assets/')) {
        return CircleAvatar(radius: size/2, backgroundImage: AssetImage(img));
      }
      
      // Otherwise, it's an API relative path - prepend base URL
      img = '${AppUrls.baseImageUrl}$img';
      return CircleAvatar(radius: size/2, backgroundImage: NetworkImage(img));
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
    
    // Check if it's already a full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
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
    
    // Check if it's a local file path (contains drive letter ':' for Windows, or is an absolute path with multiple segments for mobile)
    // Local file paths: D:/path/file.jpg, C:\path\file.jpg, /data/user/0/.../file.jpg, /storage/emulated/0/.../file.jpg
    bool isLocalFilePath = imagePath.contains(':') || 
                           (imagePath.startsWith('/') && (imagePath.startsWith('/data/') || 
                            imagePath.startsWith('/storage/') || 
                            imagePath.startsWith('/var/') ||
                            imagePath.contains('/cache/') ||
                            imagePath.contains('/files/')));
    
    if (isLocalFilePath) {
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
    
    // Check if it's an asset path
    if (imagePath.startsWith('assets/')) {
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
    
    // Otherwise, it's an API relative path - prepend base URL and use network image
    imagePath = '${AppUrls.baseImageUrl}$imagePath';
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
            onPressed: () {
              controller.onEditTap();
              Get.dialog(
                const EditProductDialog(),
                barrierDismissible: false,
              );
            },
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
        child: Obx(() {
          if (controller.productImages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'No images available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          }
          
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.productImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildDetailImage(controller.productImages[index]),
                ),
              );
            },
          );
        }),
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
                      controller.productName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.brandName,
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
                    'In Stock:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Obx(() {
                    final qty = int.tryParse(controller.quantity) ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: qty > 0 ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.quantity,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: qty > 0 ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(() => Text(
                '\$${controller.currentPrice}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),
              const SizedBox(width: 8),
              Obx(() => Text(
                '\$${controller.originalPrice}',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.red[400],
                ),
              )),
              const SizedBox(width: 8),
              Obx(() {
                if (controller.discountPercentage.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    controller.discountPercentage,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.availableSizes.isEmpty) return const SizedBox.shrink();
            return Column(
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
                Wrap(
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
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          Obx(() {
            if (controller.availableColors.isEmpty) return const SizedBox.shrink();
            return Row(
              children: [
                Text(
                  'Color: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
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
                ),
              ],
            );
          }),
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
            controller.productOverview,
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