import 'dart:convert';

GetProductsResponse getProductsResponseFromJson(String str) =>
    GetProductsResponse.fromJson(json.decode(str));

String getProductsResponseToJson(GetProductsResponse data) =>
    json.encode(data.toJson());

class GetProductsResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<ProductData> data;
  final Meta meta;

  GetProductsResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    required this.meta,
  });

  factory GetProductsResponse.fromJson(Map<String, dynamic> json) =>
      GetProductsResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        statusCode: json['statusCode'] ?? 0,
        data: (json['data'] as List<dynamic>?)
                ?.map((e) => ProductData.fromJson(e))
                .toList() ??
            [],
        meta: Meta.fromJson(json['meta'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'statusCode': statusCode,
        'data': data.map((e) => e.toJson()).toList(),
        'meta': meta.toJson(),
      };
}

class ProductData {
  final String id;
  final Seller seller;
  final String category;
  final CategoryId categoryId;
  final String subCategory;
  final String subCategoryId;
  final List<String> images;
  final String name;
  final String model;
  final String brand;
  final List<String> color;
  final List<SizeType> sizeType;
  final String specialCategory;
  final String overview;
  final String highlights;
  final String techSpecs;
  final bool isDeleted;
  final String status;
  final int totalStock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductData({
    required this.id,
    required this.seller,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json['_id'] ?? '',
        seller: Seller.fromJson(json['sellerId'] ?? {}),
        category: json['category'] ?? '',
        categoryId: CategoryId.fromJson(json['categoryId'] ?? {}),
        subCategory: json['subCategory'] ?? '',
        subCategoryId: json['subCategoryId'] ?? '',
        images:
            (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        name: json['name'] ?? '',
        model: json['model'] ?? '',
        brand: json['brand'] ?? '',
        color: (json['color'] as List?)?.map((e) => e.toString()).toList() ?? [],
        sizeType: (json['sizeType'] as List?)
                ?.map((e) => SizeType.fromJson(e))
                .toList() ??
            [],
        specialCategory: json['specialCategory'] ?? '',
        overview: "${json['overview'] ?? ''}",
        highlights: "${json['highlights'] ?? ''}",
        techSpecs: "${json['techSpecs'] ?? ''}",
        isDeleted: json['isDeleted'] ?? false,
        status: "${json['status'] ?? ''}",
        totalStock: json['totalStock'] ?? 0,
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['reviewCount'] ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'sellerId': seller.toJson(),
        'category': category,
        'categoryId': categoryId.toJson(),
        'subCategory': subCategory,
        'subCategoryId': subCategoryId,
        'images': images,
        'name': name,
        'model': model,
        'brand': brand,
        'color': color,
        'sizeType': sizeType.map((e) => e.toJson()).toList(),
        'specialCategory': specialCategory,
        'overview': "${overview ?? ''}",
        'highlights': "${highlights ?? ''}",
        'techSpecs': "${techSpecs ?? ''}",
        'isDeleted': isDeleted,
        'status': status,
        'totalStock': totalStock,
        'rating': rating,
        'reviewCount': reviewCount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Seller {
  final String id;
  final String? image;
  final String firstName;
  final String lastName;

  Seller({
    required this.id,
    this.image,
    required this.firstName,
    required this.lastName,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json['_id'] ?? '',
        image: json['image'],
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'image': image,
        'firstName': firstName,
        'lastName': lastName,
      };
}

class CategoryId {
  final String id;
  final String name;
  final List<String> subCategory;
  final String thumbnail;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryId({
    required this.id,
    required this.name,
    required this.subCategory,
    required this.thumbnail,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        subCategory:
            (json['subCategory'] as List?)?.map((e) => e.toString()).toList() ??
                [],
        thumbnail: json['thumbnail'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'subCategory': subCategory,
        'thumbnail': thumbnail,
        'isDeleted': isDeleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class SizeType {
  final String size;
  final double price;
  final double quantity;
  final double discount;
  final double purchasePrice;
  final double profit;
  final String id;

  SizeType({
    required this.size,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.purchasePrice,
    required this.profit,
    required this.id,
  });

  factory SizeType.fromJson(Map<String, dynamic> json) => SizeType(
        size: json['size'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: (json['quantity'] ?? 0).toDouble(),
        discount: (json['discount'] ?? 0).toDouble(),
        purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
        profit: (json['profit'] ?? 0).toDouble(),
        id: json['_id'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'price': price,
        'quantity': quantity,
        'discount': discount,
        'purchasePrice': purchasePrice,
        'profit': profit,
        '_id': id,
      };
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 10,
        total: json['total'] ?? 0,
        totalPage: json['totalPage'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPage': totalPage,
      };
}
