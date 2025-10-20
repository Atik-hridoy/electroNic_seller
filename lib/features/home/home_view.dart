import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'navigationbar.dart';
import 'products/products-view.dart';
import 'views/history_view.dart';

class HomeView extends GetView<HomeController> {

  // Helper method for building menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? textColor,
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 56, // Adjusted height for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: textColor ?? Colors.grey.shade700, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black87,
          ),
        ),
        trailing: showArrow
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }

  // Logout dialog method
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                // controller.logout();
                print('User logged out');
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


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
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header Section
                  GestureDetector(
                    onTap: () {
                      // Navigate to account details if needed
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profile/profile_picture.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Name
                          Obx(() => Text(
                                controller.userName.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )),
                          const SizedBox(height: 4),
                          // Phone
                          Obx(() => Text(
                                controller.userPhone.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                  

                  

                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Account Setting',
                    onTap: () {
                    Get.toNamed(Routes.accountSettingView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                    Get.toNamed(Routes.accountSettingView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.work_outline,
                    title: 'Work Functionality',
                    onTap: () {
                      // Navigate to work functionality
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      // Navigate to terms & conditions
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    onTap: () {
                      // Navigate to FAQ
                    },
                  ),

                  

                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Log Out',
                    textColor: Colors.red,
                    showArrow: false,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
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
                            controller.getFormattedPhone(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          )),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: controller.onNotificationTap,
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                    ),
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
            title: const Text(
              'Orders',
              style: TextStyle(
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
              controller.delivered.value.toString(),
              'delivered'.tr,
              Colors.green.shade50,
              Colors.green.shade600,
            ))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Obx(() => _buildStatCard(
              controller.returns.value.toString(),
              'return'.tr,
              Colors.red.shade50,
              Colors.red.shade600,
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
          Obx(() => controller.isLoadingTransactions.value
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
          controller.formatCurrency(controller.sentMoney.value),
          'sent_money'.tr,
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
    return Row(
      children: [
        Obx(() => _buildMonthlyStatItem(
            'income'.tr,
            controller.formatCurrency(controller.monthlyIncome.value),
            Colors.red.shade400
        )),
        const SizedBox(width: 24),
        Obx(() => _buildMonthlyStatItem(
            'return_count'.tr,
            controller.formatCurrency(controller.monthlyReturnCount.value),
            Colors.grey[600]!
        )),
        const SizedBox(width: 24),
        Obx(() => _buildMonthlyStatItem(
            'profit'.tr,
            controller.formatCurrency(controller.monthlyProfit.value),
            Colors.green.shade400
        )),
      ],
    );
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
    return SizedBox(
      height: 150,
      child: Obx(() => controller.isLoadingChart.value
          ? _buildLoadingIndicator()
          : CustomPaint(
        size: const Size(double.infinity, 150),
        painter: LineChartPainter(
          incomeData: controller.chartDataIncome,
          profitData: controller.chartDataProfit,
        ),
      )),
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
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Obx(() => Text(
                        controller.overallRating.value.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )),
                      const Text(
                        '/5',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
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
                child: Column(
                  children: [5, 4, 3, 2, 1].map((stars) =>
                      Obx(() => _buildHorizontalRatingBar(
                          stars,
                          controller.getRatingPercentage(stars).toInt()
                      ))
                  ).toList(),
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

class LineChartPainter extends CustomPainter {
  final List<double> incomeData;
  final List<double> profitData;

  LineChartPainter({
    required this.incomeData,
    required this.profitData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.red.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.green.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint3 = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint3);
    }

    // Draw income line
    if (incomeData.isNotEmpty) {
      final path1 = Path();
      for (int i = 0; i < incomeData.length; i++) {
        final x = size.width * i / (incomeData.length - 1);
        final y = size.height * incomeData[i];
        if (i == 0) {
          path1.moveTo(x, y);
        } else {
          path1.lineTo(x, y);
        }
      }
      canvas.drawPath(path1, paint1);
    }

    // Draw profit line
    if (profitData.isNotEmpty) {
      final path2 = Path();
      for (int i = 0; i < profitData.length; i++) {
        final x = size.width * i / (profitData.length - 1);
        final y = size.height * profitData[i];
        if (i == 0) {
          path2.moveTo(x, y);
        } else {
          path2.lineTo(x, y);
        }
      }
      canvas.drawPath(path2, paint2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}