class TransactionStatisticsModel {
  final double totalEarning;
  final double pendingMoney;
  final double receivedMoney;

  TransactionStatisticsModel({
    required this.totalEarning,
    required this.pendingMoney,
    required this.receivedMoney,
  });

  factory TransactionStatisticsModel.fromJson(Map<String, dynamic> json) {
    return TransactionStatisticsModel(
      totalEarning: _parseDouble(json['totalEarning'] ?? 0),
      pendingMoney: _parseDouble(json['pendingMoney'] ?? 0),
      receivedMoney: _parseDouble(json['receivedMoney'] ?? 0),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEarning': totalEarning,
      'pendingMoney': pendingMoney,
      'receivedMoney': receivedMoney,
    };
  }

  // Helper methods for UI display
  String get formattedTotalEarning => '\$${totalEarning.toStringAsFixed(0)}';
  String get formattedPendingMoney => '\$${pendingMoney.toStringAsFixed(0)}';
  String get formattedReceivedMoney => '\$${receivedMoney.toStringAsFixed(0)}';
}

