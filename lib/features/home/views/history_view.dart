import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order History',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Obx(() => controller.hasError.value
                      ? Icon(Icons.error, color: Colors.red, size: 20)
                      : SizedBox.shrink()),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () => controller.refreshOrders(),
                    icon: Icon(Icons.refresh, color: Colors.amber[700]),
                    tooltip: 'Refresh Orders',
                  ),
                ],
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.amber[700],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.amber[700],
            indicatorWeight: 3,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'To Ship'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList('pending'),
            _buildOrderList('to_ship'),
            _buildOrderList('completed'),
            _buildOrderList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    return Obx(() {
      // Show loading indicator
      if (controller.isLoading.value && controller.orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.amber[700],
              ),
              const SizedBox(height: 16),
              Text(
                'Loading orders...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }
      
      final allOrders = controller.orders;
      
      final filteredOrders = allOrders.where((order) {
        final tabFilter = order['tab_filter']?.toString().toLowerCase() ?? '';
        return tabFilter == status;
      }).toList();

      if (filteredOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No ${status.replaceAll('_', ' ')} orders',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshOrders,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return _buildOrderCard(order);
          },
        ),
      );
    });
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with address and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['address'] ?? '20 Cooper Square, Newyork',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order date ${order['date'] ?? '25 Aug, 2025'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order['status'] ?? 'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order['status']),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Product details and actions
          Row(
            children: [
              // Product image with dynamic icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getProductColor(order['product_name']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getProductIcon(order['product_name']),
                  color: Colors.white,
                  size: 22,
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order No: ${order['id'] ?? '#1458118'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (order['status'].toString().toLowerCase() == 'completed')
                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Return Request',
                                'Return request initiated for ${order['product_name']}',
                                backgroundColor: Colors.blue[50],
                                colorText: Colors.blue[800],
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              minimumSize: const Size(0, 0),
                            ),
                            child: Text(
                              'Return',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['product_name'] ?? 'Luggage Tag',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty ${order['quantity'] ?? '3'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Price: \$${order['total']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              if (order['tab_filter'].toString().toLowerCase() == 'pending') ...[
                // Process to Ship button for pending orders
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Process to Ship'),
                          content: Text('Process order ${order['id']} to ship?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                                // Call controller method to change status
                                controller.processOrderToShip(order['id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[700],
                              ),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Process to Ship',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Cancel button for pending orders
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Cancel Order'),
                          content: Text('Are you sure you want to cancel order ${order['id']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                // Call controller method to change status
                                controller.cancelOrder(order['id']);
                              },
                              child: const Text('Yes, Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ] else if (order['tab_filter'].toString().toLowerCase() == 'to_ship') ...[
                // Complete button for to_ship orders
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Complete Order'),
                          content: Text('Mark order ${order['id']} as completed?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                                // Call controller method to mark as completed
                                controller.completeOrder(order['id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Cancel button for to_ship orders
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Cancel Order'),
                          content: Text('Are you sure you want to cancel order ${order['id']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                // Call controller method to change status
                                controller.cancelOrder(order['id']);
                              },
                              child: const Text('Yes, Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ] else
                // Buy Again button for completed and cancelled statuses
                Expanded(
                  child: _buildActionButton(order),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> order) {
    return ElevatedButton(
      onPressed: () {
        Get.snackbar(
          'Buy Again',
          '${order['product_name']} added to cart',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Buy Again',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'processing':
        return Colors.amber;
      case 'to ship':
      case 'shipped':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get product-specific colors for better visual distinction
  Color _getProductColor(String? productName) {
    switch (productName?.toLowerCase()) {
      case 'luggage tag':
        return Colors.brown;
      case 'travel backpack':
        return Colors.indigo;
      case 'phone case':
        return Colors.purple;
      case 'wireless headphones':
        return Colors.deepPurple;
      case 'laptop stand':
        return Colors.teal;
      case 'coffee mug set':
        return Colors.orange;
      case 'desk organizer':
        return Colors.green;
      default:
        return Colors.grey[800]!;
    }
  }

  // Get product-specific icons
  IconData _getProductIcon(String? productName) {
    switch (productName?.toLowerCase()) {
      case 'luggage tag':
        return Icons.luggage;
      case 'travel backpack':
        return Icons.backpack;
      case 'phone case':
        return Icons.phone_android;
      case 'wireless headphones':
        return Icons.headphones;
      case 'laptop stand':
        return Icons.laptop;
      case 'coffee mug set':
        return Icons.coffee;
      case 'desk organizer':
        return Icons.storage;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}
