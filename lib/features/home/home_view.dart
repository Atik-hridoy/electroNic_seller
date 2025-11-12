import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'navigationbar.dart';
import 'everything_related_products/products_view/products-view.dart';
import 'views/account/account_view.dart';
import 'views/history_view.dart';

class HomeView extends GetView<HomeController> {



  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBarForView(controller.selectedBottomNavIndex.value),
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedBottomNavIndex.value,
          children: [
            // Dashboard View (Index 0)
            RefreshIndicator(
              onRefresh: controller.refreshAllData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductStatistic(),
                    const SizedBox(height: 24),
                    _buildTransactionUpdate(),
                    const SizedBox(height: 24),
                    _buildMonthlyStatistic(),
                    const SizedBox(height: 24),
                    _buildRatingsStatistic(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Products View (Index 1)
            const ProductsView(),
            // Orders View (Index 2)
            const HistoryView(),
            // Account View (Index 3)
            const AccountView()
          ],
        );
      }),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    ));
  }

  PreferredSizeWidget _buildAppBarForView(int index) {
    switch (index) {
      case 0: // Dashboard
        return PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(15),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/Group 290580.png',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                            controller.userName.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          )),
                          Obx(() => Text(
                            controller.maskedUserPhone.value,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          )),
                        ],
                      ),
                    ),
                    Obx(() {
                      final unreadCount = controller.unreadNotificationCount;
                      return Stack(
                        children: [
                          IconButton(
                            onPressed: controller.onNotificationTap,
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.black,
                            ),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      case 1: // Products
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 12,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            shadowColor: Colors.black.withValues(alpha: 0.4),
            title: Text(
              'Products'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        );
      case 2: // Orders
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            shadowColor: Colors.black.withOpacity(0.1),
            title: Text(
              'orders'.tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        );
      case 3: // Account
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            shadowColor: Colors.black.withValues(alpha: 0.1),
            title: Text(
              'Account'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        );
      default:
        return PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            shadowColor: Colors.black.withValues(alpha: 0.1),
            title: Text(
              'Dashboard'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        );
    }
  }

  Widget _buildProductStatistic() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product_statistic'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => controller.isLoadingStats.value
              ? _buildLoadingIndicator()
              : _buildProductStatsContent()),
        ],
      ),
    );
  }

  Widget _buildProductStatsContent() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Obx(() => _buildStatCard(
              controller.storedItems.value.toString(),
              'stored_items'.tr,
              Colors.blue.shade50,
              Colors.blue.shade600,
            ))),
            const SizedBox(width: 16),
            Expanded(child: Obx(() => _buildStatCard(
              controller.activeOrders.value.toString(),
              'active_order'.tr,
              Colors.orange.shade50,
              Colors.orange.shade600,
            ))),
            const SizedBox(width: 16),
            Expanded(child: Obx(() => _buildStatCard(
              controller.shippedOrders.value.toString(),
              'shipped_order'.tr,
              Colors.teal.shade50,
              Colors.teal.shade600,
            ))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Obx(() => _buildStatCard(
              controller.delivered.value.toString(),
              'delivered'.tr,
              Colors.green.shade50,
              Colors.green.shade600,
            ))),
            const SizedBox(width: 16),
            Expanded(child: Obx(() => _buildStatCard(
              '0${controller.cancelledProducts.value}',
              'cancel_products'.tr,
              Colors.purple.shade50,
              Colors.purple.shade600,
            ))),
            const SizedBox(width: 16),
            Expanded(child: Obx(() => _buildStatCard(
              controller.rating.value.toString(),
              'rating'.tr,
              Colors.amber.shade50,
              Colors.amber.shade600,
            ))),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionUpdate() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'transaction_update'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => controller.isLoadingTransactionStats.value
              ? _buildLoadingIndicator()
              : _buildTransactionContent()),
        ],
      ),
    );
  }

  Widget _buildTransactionContent() {
    return Row(
      children: [
        Expanded(child: Obx(() => _buildTransactionCard(
          controller.formatCurrency(controller.totalEarning.value),
          'total_earning'.tr,
          Colors.grey[700]!,
        ))),
        const SizedBox(width: 16),
        Expanded(child: Obx(() => _buildTransactionCard(
          controller.formatCurrency(controller.pendingMoney.value),
          'pending_money'.tr,
          Colors.orange.shade600,
        ))),
        const SizedBox(width: 16),
        Expanded(child: Obx(() => _buildTransactionCard(
          controller.formatCurrency(controller.receivedMoney.value),
          'received_money'.tr,
          Colors.green.shade600,
        ))),
      ],
    );
  }

  Widget _buildTransactionCard(String amount, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }


  Widget _buildMonthlyStatistic() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'monthly_statistic'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              _buildMonthDropdown(),
            ],
          ),
          const SizedBox(height: 16),
          _buildMonthlyStatsRow(),
          const SizedBox(height: 24),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: controller.selectedMonth.value,
        underline: const SizedBox(),
        items: controller.months.map((String month) {
          return DropdownMenuItem<String>(
            value: month,
            child: Text(month, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.onMonthChanged(newValue);
          }
        },
        icon: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
      ),
    ));
  }

  Widget _buildMonthlyStatsRow() {
    return Obx(() {
      if (controller.isLoadingChart.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
            ),
          ),
        );
      }
      
      return Row(
        children: [
          _buildMonthlyStatItem(
              'income'.tr,
              controller.formatCurrency(controller.monthlyIncome.value),
              Colors.red.shade400
          ),
          const SizedBox(width: 24),
          _buildMonthlyStatItem(
              'return_count'.tr,
              controller.formatCurrency(controller.monthlyReturnCount.value),
              Colors.grey[600]!
          ),
          const SizedBox(width: 24),
          _buildMonthlyStatItem(
              'profit'.tr,
              controller.formatCurrency(controller.monthlyProfit.value),
              Colors.green.shade400
          ),
        ],
      );
    });
  }

  Widget _buildMonthlyStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Obx(() {
      if (controller.isLoadingChart.value) {
        return SizedBox(
          height: 200,
          child: _buildLoadingIndicator(),
        );
      }
      
      return Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('income_label'.tr, Colors.red.shade400),
              const SizedBox(width: 20),
              _buildLegendItem('profit_label'.tr, Colors.green.shade400),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: ImprovedLineChartPainter(
                incomeData: controller.chartDataIncome,
                profitData: controller.chartDataProfit,
              ),
            ),
          ),
        ],
      );
    });
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingsStatistic() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ratings_statistic'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Rating display
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.isLoadingSellerRating.value
                    ? const SizedBox(
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 4),
                          Text(
                            controller.overallRating.value.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            '/5',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      )
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    '${'total_rating'.tr}  ${controller.getTotalRatingCount()}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
              const SizedBox(width: 32),
              // Right side - Rating bars
              Expanded(
                child: Obx(() => controller.isLoadingSellerRating.value
                  ? Column(
                      children: List.generate(5, (index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        height: 20,
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.grey, size: 14),
                            const SizedBox(width: 8),
                            Text('${5 - index}', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const SizedBox(width: 30, child: Text('--', style: TextStyle(color: Colors.grey))),
                          ],
                        ),
                      )),
                    )
                  : Column(
                      children: [5, 4, 3, 2, 1].map((stars) =>
                          _buildHorizontalRatingBar(
                              stars,
                              controller.getRatingPercentage(stars).toInt()
                          )
                      ).toList(),
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalRatingBar(int stars, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Star rating with stars
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(
                '$stars'.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Progress bar
          Expanded(
            flex: 3,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Percentage
          SizedBox(
            width: 35,
            child: Text(
              '$percentage%'.tr,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }


  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ImprovedLineChartPainter extends CustomPainter {
  final List<double> incomeData;
  final List<double> profitData;

  ImprovedLineChartPainter({
    required this.incomeData,
    required this.profitData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (incomeData.isEmpty && profitData.isEmpty) return;

    // Padding for axes and labels
    const leftPadding = 40.0;
    const rightPadding = 10.0;
    const topPadding = 10.0;
    const bottomPadding = 30.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Paint styles
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 0.5;

    final incomePaint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final profitPaint = Paint()
      ..color = Colors.green.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    // Find max value for Y-axis
    double maxValue = 0;
    for (var value in incomeData) {
      if (value > maxValue) maxValue = value;
    }
    for (var value in profitData) {
      if (value > maxValue) maxValue = value;
    }
    if (maxValue == 0) maxValue = 100;

    // Round up maxValue to nearest nice number
    final magnitude = (maxValue / 5).ceil() * 5;
    maxValue = magnitude * 5;

    // Draw Y-axis
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, size.height - bottomPadding),
      axisPaint,
    );

    // Draw X-axis
    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width - rightPadding, size.height - bottomPadding),
      axisPaint,
    );

    // Draw horizontal grid lines and Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (int i = 0; i <= 5; i++) {
      final y = size.height - bottomPadding - (chartHeight * i / 5);
      
      // Grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      // Y-axis label
      final value = (maxValue * i / 5).toInt();
      textPainter.text = TextSpan(
        text: value.toString(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Draw X-axis labels (show every 5th day)
    for (int i = 0; i < incomeData.length; i += 5) {
      final x = leftPadding + (chartWidth * i / (incomeData.length - 1));
      
      textPainter.text = TextSpan(
        text: 'D${i + 1}',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - bottomPadding + 5),
      );
    }

    // Helper function to get Y position
    double getY(double value) {
      final normalizedValue = value / maxValue;
      return size.height - bottomPadding - (chartHeight * normalizedValue);
    }

    // Draw income line and dots
    if (incomeData.isNotEmpty) {
      final path = Path();
      for (int i = 0; i < incomeData.length; i++) {
        final x = leftPadding + (chartWidth * i / (incomeData.length - 1));
        final y = getY(incomeData[i]);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }

        // Draw dot if value > 0
        if (incomeData[i] > 0) {
          dotPaint.color = Colors.red.shade400;
          canvas.drawCircle(Offset(x, y), 3, dotPaint);
        }
      }
      canvas.drawPath(path, incomePaint);
    }

    // Draw profit line and dots
    if (profitData.isNotEmpty) {
      final path = Path();
      for (int i = 0; i < profitData.length; i++) {
        final x = leftPadding + (chartWidth * i / (profitData.length - 1));
        final y = getY(profitData[i]);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }

        // Draw dot if value > 0
        if (profitData[i] > 0) {
          dotPaint.color = Colors.green.shade400;
          canvas.drawCircle(Offset(x, y), 3, dotPaint);
        }
      }
      canvas.drawPath(path, profitPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}