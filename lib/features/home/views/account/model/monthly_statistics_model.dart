import 'chart_data_point.dart';

class MonthlyStatisticsModel {
  final double income;
  final double returnCount;
  final double profit;
  final String month;
  final int year;
  final List<ChartDataPoint>? chartData;
  final List<double>? chartDataIncome;
  final List<double>? chartDataProfit;

  MonthlyStatisticsModel({
    required this.income,
    required this.returnCount,
    required this.profit,
    required this.month,
    required this.year,
    this.chartData,
    this.chartDataIncome,
    this.chartDataProfit,
  });

  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) {
    // Extract summary object if it exists
    final summary = json['summary'] as Map<String, dynamic>?;
    
    // Parse chartData array
    List<ChartDataPoint>? chartDataPoints;
    List<double>? incomeData;
    List<double>? profitData;
    
    if (json['chartData'] != null && json['chartData'] is List) {
      chartDataPoints = (json['chartData'] as List)
          .map((e) => ChartDataPoint.fromJson(e as Map<String, dynamic>))
          .toList();
      
      // Extract income and profit arrays for the chart
      incomeData = chartDataPoints.map((point) => point.income).toList();
      profitData = chartDataPoints.map((point) => point.profit).toList();
    }
    
    return MonthlyStatisticsModel(
      income: summary != null && summary['income'] is num 
          ? (summary['income'] as num).toDouble() 
          : 0.0,
      returnCount: summary != null && summary['returnCost'] is num 
          ? (summary['returnCost'] as num).toDouble() 
          : 0.0,
      profit: summary != null && summary['profit'] is num 
          ? (summary['profit'] as num).toDouble() 
          : 0.0,
      month: json['month'] as String? ?? '',
      year: json['year'] is num ? (json['year'] as num).toInt() : DateTime.now().year,
      chartData: chartDataPoints,
      chartDataIncome: incomeData,
      chartDataProfit: profitData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'returnCount': returnCount,
      'profit': profit,
      'month': month,
      'year': year,
      'chartData': chartData?.map((e) => e.toJson()).toList(),
      'chartDataIncome': chartDataIncome,
      'chartDataProfit': chartDataProfit,
    };
  }
}
