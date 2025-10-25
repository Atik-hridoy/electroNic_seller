class ProductModel {
  final String name;
  final String category;
  final String subCategory;
  final String model;
  final String brand;
  final List<String> colors;
  final String specialCategory;
  final String finish;
  final List<String> images;
  final List<ProductVariantModel> variants;
  final DateTime createdAt;

  ProductModel({
    required this.name,
    required this.category,
    required this.subCategory,
    required this.model,
    required this.brand,
    required this.colors,
    required this.specialCategory,
    required this.finish,
    required this.images,
    required this.variants,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      specialCategory: json['specialCategory'] ?? '',
      finish: json['finish'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      variants: (json['variants'] as List?)
              ?.map((v) => ProductVariantModel.fromJson(v))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'model': model,
      'brand': brand,
      'colors': colors,
      'specialCategory': specialCategory,
      'finish': finish,
      'images': images,
      'variants': variants.map((v) => v.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductModel(name: $name, brand: $brand, variants: ${variants.length})';
  }
}

class ProductVariantModel {
  final String id;
  final String size;
  final double price;
  final double purchasePrice;
  final double profitPrice;
  final int quantity;
  final DateTime createdAt;

  ProductVariantModel({
    required this.id,
    required this.size,
    required this.price,
    required this.purchasePrice,
    required this.profitPrice,
    required this.quantity,
    required this.createdAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? '',
      size: json['size'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      purchasePrice: (json['purchasePrice'] ?? 0.0).toDouble(),
      profitPrice: (json['profitPrice'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'purchasePrice': purchasePrice,
      'profitPrice': profitPrice,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductVariantModel(size: $size, price: \$${price.toStringAsFixed(2)}, quantity: $quantity)';
  }
}
