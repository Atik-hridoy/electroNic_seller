import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  // Observable variables for user data
  final userName = 'Nadir Hossain'.obs;
  final userPhone = '+8801955******33'.obs;

  // Product statistics observables
  final storedItems = 520.obs;
  final activeOrders = 25.obs;
  final delivered = 256.obs;
  final returns = 20.obs;
  final cancelledProducts = 2.obs;
  final rating = 200.obs;

  // Transaction data observables
  final totalEarning = 5620.0.obs;
  final pendingMoney = 755.0.obs;
  final sentMoney = 4865.0.obs;

  // Monthly statistics
  final selectedMonth = 'August'.obs;
  final monthlyIncome = 520.0.obs;
  final monthlyReturnCount = 0.0.obs;
  final monthlyProfit = 250.0.obs;

  // Rating statistics
  final overallRating = 4.5.obs;
  final ratingQuality = 'Very good quality'.obs;
  final ratingBreakdown = <int, int>{
    5: 50,
    4: 30,
    3: 15,
    2: 3,
    1: 2,
  }.obs;

  // Bottom navigation
  final selectedBottomNavIndex = 0.obs;

  // Loading states
  final isLoadingStats = false.obs;
  final isLoadingTransactions = false.obs;
  final isLoadingChart = false.obs;

  // Chart data
  final chartDataIncome = <double>[].obs;
  final chartDataProfit = <double>[].obs;

  // Months list for dropdown
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _loadChartData();
  }

  void _initializeData() {
    // Initialize with default data
    _loadProductStats();
    _loadTransactionData();
    _loadMonthlyStats();
    _loadRatingStats();
  }

  void _loadProductStats() {
    isLoadingStats.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      // Data is already initialized in observables
      isLoadingStats.value = false;
    });
  }

  void _loadTransactionData() {
    isLoadingTransactions.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoadingTransactions.value = false;
    });
  }

  void _loadMonthlyStats() {
    // Load monthly data based on selected month
    // In real app, this would be an API call
  }

  void _loadRatingStats() {
    // Load rating statistics
    // In real app, this would be an API call
  }

  void _loadChartData() {
    isLoadingChart.value = true;

    // Sample chart data - in real app, this would come from API
    chartDataIncome.value = [0.8, 0.6, 0.7, 0.4, 0.5, 0.3];
    chartDataProfit.value = [0.9, 0.7, 0.6, 0.5, 0.3, 0.2];

    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoadingChart.value = false;
    });
  }

  // Methods for user interactions
  void onNotificationTap() {
    Get.toNamed(Routes.notification);
  }

  void onMonthChanged(String month) {
    selectedMonth.value = month;
    _refreshMonthlyData();
  }

  void _refreshMonthlyData() {
    // Simulate loading new monthly data
    isLoadingChart.value = true;

    Future.delayed(const Duration(milliseconds: 1500), () {
      // Update data based on selected month
      _updateMonthlyStatsForMonth(selectedMonth.value);
      _loadChartData();
    });
  }

  void _updateMonthlyStatsForMonth(String month) {
    // Simulate different data for different months
    switch (month) {
      case 'August':
        monthlyIncome.value = 520.0;
        monthlyProfit.value = 250.0;
        break;
      case 'July':
        monthlyIncome.value = 480.0;
        monthlyProfit.value = 220.0;
        break;
      case 'September':
        monthlyIncome.value = 560.0;
        monthlyProfit.value = 280.0;
        break;
      default:
        monthlyIncome.value = 500.0;
        monthlyProfit.value = 240.0;
    }
  }

  void onBottomNavTap(int index) {
    if (index == 2) {
      // Navigate to OrderView when orders tab is tapped
      Get.toNamed(Routes.order);
    } else {
      // For other tabs, switch the index for IndexedStack
      selectedBottomNavIndex.value = index;
    }
  }

  // Refresh methods
  Future<void> refreshAllData() async {
    await Future.wait([
      refreshProductStats(),
      refreshTransactionData(),
      refreshMonthlyStats(),
    ]);
  }

  Future<void> refreshProductStats() async {
    isLoadingStats.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real app, update values from API response
    storedItems.value += 5; // Example increment
    activeOrders.value += 2;
    delivered.value += 10;

    isLoadingStats.value = false;
  }

  Future<void> refreshTransactionData() async {
    isLoadingTransactions.value = true;

    await Future.delayed(const Duration(seconds: 1));

    // Update transaction data
    totalEarning.value += 50.0;
    sentMoney.value += 100.0;

    isLoadingTransactions.value = false;
  }

  Future<void> refreshMonthlyStats() async {
    isLoadingChart.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    _loadChartData();
  }

  // Utility methods
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(0)}';
  }

  String getFormattedPhone() {
    return userPhone.value;
  }

  double getRatingPercentage(int stars) {
    final int count = ratingBreakdown[stars] ?? 0;
    final int total = totalRatings;
    if (total == 0) return 0.0;
    return (count / total) * 100.0;
  }

  // Calculate total rating count
  int get totalRatings {
    return ratingBreakdown.values.fold(0, (sum, count) => sum + count);
  }

  // Backward-compatible method if the view calls getTotalRatingCount()
  int getTotalRatingCount() {
    return totalRatings;
  }

  // Get product statistics as a map
  Map<String, dynamic> get productStatsMap {
    return {
      'stored_items': storedItems.value,
      'active_orders': activeOrders.value,
      'delivered': delivered.value,
      'returns': returns.value,
      'cancelled': cancelledProducts.value,
      'rating': rating.value,
    };
  }

  // Get transaction data as a map
  Map<String, dynamic> get transactionDataMap {
    return {
      'total_earning': totalEarning.value,
      'pending_money': pendingMoney.value,
      'sent_money': sentMoney.value,
    };
  }
}