import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import 'controllers/edit_account_controller.dart';
import 'views/account/services/get_product_stat_service.dart';
import 'views/account/model/get_product_stat_model.dart';
import 'views/account/services/get_monthly_statistics_service.dart';
import 'views/account/model/monthly_statistics_model.dart';
import 'views/account/services/get_transaction_statistics_service.dart';
import 'views/account/model/transaction_statistics_model.dart';
import 'views/account/services/get_seller_rating_service.dart';
import 'views/account/model/seller_rating_model.dart';
import '../notification/notification_controller.dart';

class HomeController extends GetxController {
  // Observable variables for user data
  final EditAccountController accountController = Get.put(EditAccountController());
  final userName = ''.obs;
  final userPhone = ''.obs;
  final maskedUserPhone = ''.obs;

  // Product statistics observables
  final storedItems = 0.obs;
  final activeOrders = 0.obs;
  final shippedOrders = 0.obs;
  final delivered = 256.obs;
  final cancelledProducts = 0.obs;
  final rating = 0.obs;

  // Transaction data observables
  final totalEarning = 2720.0.obs;
  final pendingMoney = 0.0.obs;
  final receivedMoney = 2560.0.obs;

  // Monthly statistics
  final selectedMonth = 'august'.tr.obs;
  final monthlyIncome = 520.0.obs;
  final monthlyReturnCount = 0.0.obs;
  final monthlyProfit = 250.0.obs;
  final currentYear = DateTime.now().year;

  // Rating statistics
  final overallRating = 4.5.obs;
  final ratingQuality = 'very_good'.tr.obs;

  // Seller rating statistics from API
  final Rx<SellerRatingModel?> sellerRating = Rx<SellerRatingModel?>(null);
  final isLoadingSellerRating = false.obs;
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
  final isLoadingTransactionStats = false.obs;

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
    _loadTransactionStatistics();
    _loadSellerRating();
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
      shippedOrders.value = stats.shippedOrder;
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

  Future<void> _loadTransactionStatistics() async {
    isLoadingTransactionStats.value = true;
    try {
      // Ensure service is available
      if (!Get.isRegistered<GetTransactionStatisticsService>()) {
        Get.put(GetTransactionStatisticsService());
      }
      final svc = Get.find<GetTransactionStatisticsService>();
      final res = await svc.getMonthlyTransactionStatistics();
      final body = res.data;
      
      // Some APIs wrap in { success, data: {...} }
      final dataJson = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      
      final stats = TransactionStatisticsModel.fromJson(dataJson);
      
      // Assign to observables
      totalEarning.value = stats.totalEarning;
      pendingMoney.value = stats.pendingMoney;
      receivedMoney.value = stats.receivedMoney;
      
    } catch (e) {
      // Keep existing values and log error
      print('Error loading transaction statistics: $e');
    } finally {
      isLoadingTransactionStats.value = false;
    }
  }

  Future<void> _loadSellerRating() async {
    isLoadingSellerRating.value = true;
    try {
      // Ensure service is available
      if (!Get.isRegistered<GetSellerRatingService>()) {
        Get.put(GetSellerRatingService());
      }
      final svc = Get.find<GetSellerRatingService>();
      final res = await svc.getSellerRating();
      final body = res.data;
      
      // Some APIs wrap in { success, data: {...} }
      final dataJson = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      
      final rating = SellerRatingModel.fromJson(dataJson);
      
      // Assign to observables
      sellerRating.value = rating;
      overallRating.value = rating.averageRating;
      
      // Update rating quality based on average rating
      if (rating.averageRating >= 4.5) {
        ratingQuality.value = 'excellent'.tr;
      } else if (rating.averageRating >= 4.0) {
        ratingQuality.value = 'very_good'.tr;
      } else if (rating.averageRating >= 3.0) {
        ratingQuality.value = 'good'.tr;
      } else if (rating.averageRating >= 2.0) {
        ratingQuality.value = 'fair'.tr;
      } else {
        ratingQuality.value = 'poor'.tr;
      }
      
    } catch (e) {
      // Keep existing values and log error
      print('Error loading seller rating: $e');
    } finally {
      isLoadingSellerRating.value = false;
    }
  }

  Future<void> _loadMonthlyStats() async {
    isLoadingChart.value = true;
    try {
      // Ensure service is available
      if (!Get.isRegistered<GetMonthlyStatisticsService>()) {
        Get.put(GetMonthlyStatisticsService());
      }
      final svc = Get.find<GetMonthlyStatisticsService>();
      
      // Convert selected month from translated string to English month name
      final monthName = _getEnglishMonthName(selectedMonth.value);
      
      final res = await svc.getMonthlyStatistics(
        month: monthName,
        year: currentYear,
      );
      
      final body = res.data;
      // Some APIs wrap in { success, data: {...} }
      final dataJson = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      
      final stats = MonthlyStatisticsModel.fromJson(dataJson);
      
      // Assign to observables
      monthlyIncome.value = stats.income;
      monthlyReturnCount.value = stats.returnCount;
      monthlyProfit.value = stats.profit;
      
      // Update chart data if available
      if (stats.chartDataIncome != null && stats.chartDataIncome!.isNotEmpty) {
        chartDataIncome.value = stats.chartDataIncome!;
      }
      if (stats.chartDataProfit != null && stats.chartDataProfit!.isNotEmpty) {
        chartDataProfit.value = stats.chartDataProfit!;
      }
    } catch (e) {
      // Keep existing values and log error
      print('Error loading monthly stats: $e');
    } finally {
      isLoadingChart.value = false;
    }
  }
  
  // Helper method to convert translated month to English month name
  String _getEnglishMonthName(String translatedMonth) {
    final monthMap = {
      'january'.tr: 'January',
      'february'.tr: 'February',
      'march'.tr: 'March',
      'april'.tr: 'April',
      'may'.tr: 'May',
      'june'.tr: 'June',
      'july'.tr: 'July',
      'august'.tr: 'August',
      'september'.tr: 'September',
      'october'.tr: 'October',
      'november'.tr: 'November',
      'december'.tr: 'December',
    };
    return monthMap[translatedMonth] ?? 'January';
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

  // Get unread notification count
  int get unreadNotificationCount {
    try {
      if (Get.isRegistered<NotificationController>()) {
        final notificationController = Get.find<NotificationController>();
        return notificationController.unreadCount;
      }
    } catch (e) {
      // If controller is not registered, return 0
    }
    return 0;
  }

  void onMonthChanged(String month) {
    selectedMonth.value = month;
    _refreshMonthlyData();
  }

  Future<void> _refreshMonthlyData() async {
    // Load new monthly data from API
    await _loadMonthlyStats();
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
      _loadTransactionStatistics(),
      _loadSellerRating(),
      refreshMonthlyStats(),
    ]);
    
  } catch (e) {
    // Log error silently without showing snackbar
    print('Error refreshing data: $e');
  }
}

  Future<void> refreshProductStats() async {
    isLoadingStats.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real app, update values from API response
    storedItems.value += 5; // Example increment
    activeOrders.value += 2;
    shippedOrders.value += 10;
    delivered.value += 10;

    isLoadingStats.value = false;
  }

  Future<void> refreshTransactionData() async {
    isLoadingTransactions.value = true;

    // Instead of adding values, refresh from API
    await _loadTransactionStatistics();

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
    // Use API data if available, otherwise fallback to local data
    if (sellerRating.value != null) {
      final rating = sellerRating.value!;
      switch (stars) {
        case 1: return rating.ratingPercentages.star1Percent.toDouble();
        case 2: return rating.ratingPercentages.star2Percent.toDouble();
        case 3: return rating.ratingPercentages.star3Percent.toDouble();
        case 4: return rating.ratingPercentages.star4Percent.toDouble();
        case 5: return rating.ratingPercentages.star5Percent.toDouble();
        default: return 0.0;
      }
    }
    
    // Fallback to local data
    final int count = ratingBreakdown[stars] ?? 0;
    final int total = totalRatings;
    if (total == 0) return 0.0;
    return (count / total) * 100.0;
  }

  // Calculate total rating count
  int get totalRatings {
    // Use API data if available, otherwise fallback to local data
    if (sellerRating.value != null) {
      return sellerRating.value!.totalReviews;
    }
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
      'shipped_orders': shippedOrders.value,
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
      'received_money': receivedMoney.value,
    };
  }
}