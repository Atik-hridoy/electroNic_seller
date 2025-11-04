class SingleProductResponse {
  final bool success;
  final String message;
  final int statusCode;
  final SingleProductData data;

  SingleProductResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: SingleProductData.fromJson(json['data'] ?? {}),
    );
  }
}

class SingleProductData {
  final String id;
  final SellerInfo sellerId;
  final String category;
  final CategoryInfo categoryId;
  final String subCategory;
  final String subCategoryId;
  final List<String> images;
  final String name;
  final String model;
  final String brand;
  final List<String> color;
  final List<SizeVariant> sizeType;
  final String specialCategory;
  final String overview;
  final String highlights;
  final String techSpecs;
  final bool isDeleted;
  final String status;
  final int totalStock;
  final double rating;
  final int reviewCount;
  final int views;
  final String createdAt;
  final String updatedAt;
  final bool isBookmarked;

  SingleProductData({
    required this.id,
    required this.sellerId,
    required this.category,
    required this.categoryId,
    required this.subCategory,
    required this.subCategoryId,
    required this.images,
    required this.name,
    required this.model,
    required this.brand,
    required this.color,
    required this.sizeType,
    required this.specialCategory,
    required this.overview,
    required this.highlights,
    required this.techSpecs,
    required this.isDeleted,
    required this.status,
    required this.totalStock,
    required this.rating,
    required this.reviewCount,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    required this.isBookmarked,
  });

  factory SingleProductData.fromJson(Map<String, dynamic> json) {
    return SingleProductData(
      id: json['_id'] ?? '',
      sellerId: SellerInfo.fromJson(json['sellerId'] ?? {}),
      category: json['category'] ?? '',
      categoryId: CategoryInfo.fromJson(json['categoryId'] ?? {}),
      subCategory: json['subCategory'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      color: (json['color'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      sizeType: (json['sizeType'] as List<dynamic>?)
              ?.map((e) => SizeVariant.fromJson(e))
              .toList() ??
          [],
      specialCategory: json['specialCategory'] ?? '',
      overview: json['overview'] ?? '',
      highlights: json['highlights'] ?? '',
      techSpecs: json['techSpecs'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      status: json['status'] ?? '',
      totalStock: json['totalStock'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  // Convert to Map for productData compatibility
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller': {
        'id': sellerId.id,
        'firstName': sellerId.firstName,
        'lastName': sellerId.lastName,
        'image': sellerId.image,
      },
      'category': category,
      'subCategory': subCategory,
      'images': images,
      'name': name,
      'model': model,
      'brand': brand,
      'colors': color,
      'variants': sizeType.map((v) => {
        'size': v.size,
        'price': v.price,
        'quantity': v.quantity,
        'discount': v.discount,
      }).toList(),
      'specialCategory': specialCategory,
      'overview': overview,
      'highlights': highlights,
      'techSpecs': techSpecs,
      'createdAt': createdAt,
    };
  }
}

class SellerInfo {
  final String id;
  final String image;
  final String firstName;
  final String lastName;

  SellerInfo({
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;
  final String thumbnail;

  CategoryInfo({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

class SizeVariant {
  final String id;
  final String size;
  final double price;
  final int quantity;
  final double discount;
  final double purchasePrice;
  final double profit;

  SizeVariant({
    required this.id,
    required this.size,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.purchasePrice,
    required this.profit,
  });

  factory SizeVariant.fromJson(Map<String, dynamic> json) {
    return SizeVariant(
      id: json['_id'] ?? '',
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      discount: (json['discount'] ?? 0).toDouble(),
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
    );
  }
}
