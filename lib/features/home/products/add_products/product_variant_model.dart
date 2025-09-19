class ProductVariant {
  final String id;
  final String size;
  final double price;
  final double purchasePrice;
  final double profitPrice;
  final int quantity;
  final DateTime createdAt;

  ProductVariant({
    required this.id,
    required this.size,
    required this.price,
    required this.purchasePrice,
    required this.profitPrice,
    required this.quantity,
    required this.createdAt,
  });

  factory ProductVariant.create({
    required String size,
    required double price,
    required double purchasePrice,
    required double profitPrice,
    required int quantity,
  }) {
    return ProductVariant(
      id: 'variant_${DateTime.now().millisecondsSinceEpoch}',
      size: size,
      price: price,
      purchasePrice: purchasePrice,
      profitPrice: profitPrice,
      quantity: quantity,
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
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductVariant(size: $size, price: \$${price.toStringAsFixed(2)}, quantity: $quantity)';
  }
}
