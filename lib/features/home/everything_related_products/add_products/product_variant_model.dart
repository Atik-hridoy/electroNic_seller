class ProductVariant {
  final String id;
  final String size;
  final int price;
  final int purchasePrice;
  final int profitPrice;
  final int discountPrice;
  final int quantity;
  final String color;
  final DateTime createdAt;

  ProductVariant({
    required this.id,
    required this.size,
    required this.price,
    required this.purchasePrice,
    required this.profitPrice,
    this.discountPrice = 0,
    required this.quantity,
    this.color = '',
    required this.createdAt,
  });

  factory ProductVariant.create({
    required String size,
    required int price,
    required int purchasePrice,
    required int profitPrice,
    int discountPrice = 0,
    required int quantity,
    String color = '',
  }) {
    return ProductVariant(
      id: 'variant_${DateTime.now().millisecondsSinceEpoch}',
      size: size,
      price: price,
      purchasePrice: purchasePrice,
      profitPrice: profitPrice,
      discountPrice: discountPrice,
      quantity: quantity,
      color: color,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'purchasePrice': purchasePrice,
      'profitPrice': profitPrice,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductVariant(size: $size, price: $price, quantity: $quantity)';
  }
}
