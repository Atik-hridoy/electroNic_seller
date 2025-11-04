class ProductStatsModel {
  final int storedItems;
  final int activeOrder;
  final int shippedOrder;
  final int deliveredOrder;
  final int cancelledOrder;
  final int totalRating;

  ProductStatsModel({
    required this.storedItems,
    required this.activeOrder,
    required this.shippedOrder,
    required this.deliveredOrder,
    required this.cancelledOrder,
    required this.totalRating,
  });

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductStatsModel(
      storedItems: json['storedItems'] is num ? (json['storedItems'] as num).toInt() : 0,
      activeOrder: json['activeOrder'] is num ? (json['activeOrder'] as num).toInt() : 0,
      shippedOrder: json['shippedOrder'] is num ? (json['shippedOrder'] as num).toInt() : 0,
      deliveredOrder: json['deliveredOrder'] is num ? (json['deliveredOrder'] as num).toInt() : 0,
      cancelledOrder: json['cancelledOrder'] is num ? (json['cancelledOrder'] as num).toInt() : 0,
      totalRating: json['totalRating'] is num ? (json['totalRating'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storedItems': storedItems,
      'activeOrder': activeOrder,
      'shippedOrder': shippedOrder,
      'deliveredOrder': deliveredOrder,
      'cancelledOrder': cancelledOrder,
      'totalRating': totalRating,
    };
  }
}
