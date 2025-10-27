import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import 'controllers/edit_account_controller.dart';
import 'views/account/services/get_product_stat_service.dart';
import 'views/account/model/get_product_stat_model.dart';

class HomeController extends GetxController {
  // Observable variables for user data
  final EditAccountController accountController = Get.put(EditAccountController());
  final userName = ''.obs;
  final userPhone = ''.obs;
  final maskedUserPhone = ''.obs;

  // Product statistics observables
  final storedItems = 0.obs;
  final activeOrders = 0.obs;
  final delivered = 256.obs;
  final cancelledProducts = 0.obs;
  final rating = 0.obs;

  // Transaction data observables
  final totalEarning = 5620.0.obs;
  final pendingMoney = 755.0.obs;
  final sentMoney = 4865.0.obs;

  // Monthly statistics
  final selectedMonth = 'august'.tr.obs;
  final monthlyIncome = 520.0.obs;
  final monthlyReturnCount = 0.0.obs;
  final monthlyProfit = 250.0.obs;

  // Rating statistics
  final overallRating = 4.5.obs;
  final ratingQuality = 'very_good'.tr.obs;
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
    'january'.tr,
    'february'.tr,
    'march'.tr,
    'april'.tr,
    'may'.tr,
    'june'.tr,
    'july'.tr,
    'august'.tr,
    'september'.tr,
    'october'.tr,
    'november'.tr,
    'december'.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize user fields from EditAccountController and react to changes
    try {
      userName.value = accountController.fullName.value;
      userPhone.value = accountController.phone.value;
      maskedUserPhone.value = _maskPhone(userPhone.value);
      ever<String>(accountController.fullName, (v) => userName.value = v);
      ever<String>(accountController.phone, (v) {
        userPhone.value = v;
        maskedUserPhone.value = _maskPhone(v);
      });
    } catch (_) {}
    _initializeData();
    _loadChartData();
  }

  String _maskPhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '***';
    final last3 = digits.length >= 3 ? digits.substring(digits.length - 3) : digits;
    return '***$last3';
  }

  void _initializeData() {
    // Initialize with default data
    _loadProductStats();
    _loadTransactionData();
    _loadMonthlyStats();
    _loadRatingStats();
  }

  Future<void> _loadProductStats() async {
    isLoadingStats.value = true;
    try {
      // Ensure service is available
      if (!Get.isRegistered<GetProductStatService>()) {
        Get.put(GetProductStatService());
      }
      final svc = Get.find<GetProductStatService>();
      final res = await svc.getProductStatistics();
      final body = res.data;
      // Some APIs wrap in { success, data: {...} }
      final dataJson = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      final stats = ProductStatsModel.fromJson(dataJson);

      // Assign to observables
      storedItems.value = stats.storedItems;
      activeOrders.value = stats.activeOrder;
      delivered.value = stats.deliveredOrder;
      cancelledProducts.value = stats.cancelledOrder;
      rating.value = stats.totalRating;
      // 'returns' not provided by API; keep as-is or set to 0 if absent
      if (!(dataJson.containsKey('returns'))) {
        // returns.value = returns.value; // no-op
      }
    } catch (e) {
      // Keep existing values and optionally log/snackbar if desired
    } finally {
      isLoadingStats.value = false;
    }
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
    if (month == 'august'.tr) {
      monthlyIncome.value = 520.0;
      monthlyProfit.value = 250.0;
    } else if (month == 'july'.tr) {
      monthlyIncome.value = 480.0;
      monthlyProfit.value = 220.0;
    } else if (month == 'september'.tr) {
      monthlyIncome.value = 560.0;
      monthlyProfit.value = 280.0;
    } else {
      monthlyIncome.value = 500.0;
      monthlyProfit.value = 240.0;
    }
  }

  String get currentMonth {
    final now = DateTime.now();
    return months[now.month - 1];
  }

  void onBottomNavTap(int index) {
    selectedBottomNavIndex.value = index;
    // The IndexedStack in the view will automatically switch to the corresponding view
  }

  // Refresh methods
  Future<void> refreshAllData() async {
  try {
    await Future.wait([
      refreshProductStats(),
      refreshTransactionData(),
      refreshMonthlyStats(),
    ]);
    
    // Show completion message
    Future.microtask(() {
      Get.snackbar(
        'refresh_complete'.tr,
        '',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    });
  } catch (e) {
    // Show error message if something goes wrong
    Future.microtask(() {
      Get.snackbar(
        'error'.tr,
        'update_failed'.tr,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    });
  }
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