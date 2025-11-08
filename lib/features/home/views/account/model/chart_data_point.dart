class ChartDataPoint {
  final int day;
  final String date;
  final double income;
  final double returnCost;
  final double profit;

  ChartDataPoint({
    required this.day,
    required this.date,
    required this.income,
    required this.returnCost,
    required this.profit,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      day: json['day'] is num ? (json['day'] as num).toInt() : 0,
      date: json['date'] as String? ?? '',
      income: json['income'] is num ? (json['income'] as num).toDouble() : 0.0,
      returnCost: json['returnCost'] is num ? (json['returnCost'] as num).toDouble() : 0.0,
      profit: json['profit'] is num ? (json['profit'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
      'income': income,
      'returnCost': returnCost,
      'profit': profit,
    };
  }
}
