import 'package:electronic/features/home/everything_related_products/add_products/add_product_controller.dart';
import 'package:electronic/features/home/everything_related_products/products_view/model/get_product_category_model.dart';


class AddProductModel {
  final CategoryModel category;
  final String subCategory;
  final String subCategoryId;
  final String name;
  final String model;
  final String brand;
  final List<String> color;
  final List<SizeType> sizeType;
  final String specialCategory;
  final String overview;
  final String highlights;
  final String techSpecs;

  AddProductModel({
    required this.category,
    required this.subCategory,
    required this.subCategoryId,
    required this.name,
    required this.model,
    required this.brand,
    required this.color,
    required this.sizeType,
    required this.specialCategory,
    required this.overview,
    required this.highlights,
    required this.techSpecs,
  });

  String get categoryId => category.id;

  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'categoryId': category.id,
      'subCategory': subCategory,
      'subCategoryId': subCategoryId,
      'name': name,
      'model': model,
      'brand': brand,
      'color': color,
      'sizeType': sizeType.map((e) => e.toJson()).toList(),
      'specialCategory': specialCategory,
      'overview': overview,
      'highlights': highlights,
      'techSpecs': techSpecs,
      'isDeleted': false,  // Added default value
      'status': 'active',  // Added default value
      'totalStock': sizeType.fold(0, (sum, item) => sum + item.quantity.toInt()),  // Calculate total stock
      'rating': 0,  // Default rating
      'reviewCount': 0,  // Default review count
    };
  }
}

class SizeType {
  final String size;
  final double price;
  final double quantity;
  final double purchasePrice;
  final double profit;
  final double discount;

  SizeType({
    required this.size,
    required this.price,
    required this.quantity,
    required this.purchasePrice,
    required this.profit,
    required this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'price': price.toInt(),  // Convert to int to match example
      'quantity': quantity.toInt(),  // Convert to int to match example
      'discount': discount.toInt(),  // Convert to int to match example
      'purchasePrice': purchasePrice.toInt(),  // Convert to int to match example
      'profit': profit.toInt(),  // Convert to int to match example
    };
  }

  factory SizeType.fromJson(Map<String, dynamic> json) {
    return SizeType(
      size: json['size'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}


extension AddProductModelExtension on AddProductController {
  AddProductModel toAddProductModel() {
    return AddProductModel(
      category: selectedCategory.value,
      subCategory: selectedSubCategory.value.name,
      subCategoryId: selectedSubCategory.value.id,
      name: productNameController.text.trim(),
      model: modelController.text.trim(),
      brand: selectedBrand.value,
      color: selectedColors,
      sizeType: productVariants.map((variant) => SizeType(
        size: variant.size,
        price: variant.price.toDouble(),
        quantity: variant.quantity.toDouble(),
        purchasePrice: variant.purchasePrice.toDouble(),
        profit: variant.profitPrice.toDouble(),
        discount: variant.discountPrice.toDouble(),
      )).toList(),
      specialCategory: selectedSpecialCategory.value,
      overview: overviewController.text.trim(),
      highlights: highlightController.text.trim(),
      techSpecs: techSpecController.text.trim(),
    );
  }
}
