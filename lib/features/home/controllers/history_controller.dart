import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/order_service.dart';
import '../../../core/util/app_logger.dart';

class HistoryController extends GetxController {
  // Service
  final OrderService _orderService = Get.find<OrderService>();
  
  // Observable list of orders
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load orders when controller initializes
    loadOrders();
  }

  // Load orders from API
  Future<void> loadOrders({String? status}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      AppLogger.info('Loading orders${status != null ? " with status: $status" : ""}');
      
      final response = await _orderService.getOrders(status: status);
      
      // ===== DEBUG: Print full response =====
      print('\n========== GET ORDERS API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Success: ${response.data['success']}');
      print('Message: ${response.data['message']}');
      print('Orders Count: ${response.data['data']?['orders']?.length ?? 0}');
      print('Full Orders Data: ${response.data['data']?['orders']}');
      print('=============================================\n');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> ordersData = response.data['data']['orders'] ?? [];
        
        // Transform API data to match our UI format
        final transformedOrders = ordersData.map((order) {
          // Get first product for display (you can modify this logic)
          final product = order['products']?.isNotEmpty == true 
              ? order['products'][0] 
              : null;
          
          final deliveryStatus = order['deliveryStatus'] ?? 'pending';
          
          return {
            'id': order['orderNumber'] ?? order['_id'] ?? '',
            'status': _mapDeliveryStatusForDisplay(deliveryStatus),
            'tab_filter': _mapDeliveryStatusForTab(deliveryStatus),
            'product_name': product?['productName'] ?? 'Unknown Product',
            'quantity': product?['quantity'] ?? 0,
            'total': (order['totalPrice'] ?? 0).toDouble(),
            'date': _formatDate(order['createdAt']),
            'address': order['address'] ?? '',
            'raw_data': order, // Store raw data for future use
          };
        }).toList();
        
        orders.assignAll(transformedOrders);
        AppLogger.success('Orders loaded successfully: ${orders.length} orders');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      AppLogger.error('Error loading orders: $e');
      
      // Load demo data as fallback
      _loadDemoOrders();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Map API delivery status to display status (what user sees on card)
  String _mapDeliveryStatusForDisplay(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }
  
  // Map API delivery status to tab filter (which tab to show in)
  String _mapDeliveryStatusForTab(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'pending':
        return 'pending';
      case 'processing':
        return 'pending';  // Processing orders show in Pending tab
      case 'shipped':
        return 'to_ship';
      case 'delivered':
        return 'completed';
      case 'cancelled':
        return 'cancelled';
      default:
        return 'pending';
    }
  }
  
  // Format date from API
  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
  
  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
  
  // Load demo data as fallback
  void _loadDemoOrders() {
    final demoOrders = [
      {
        'id': '#1458118',
        'status': 'Pending',
        'tab_filter': 'pending',
        'product_name': 'Luggage Tag',
        'quantity': 2,
        'total': 18.0,
        'date': '25 Aug, 2025',
        'address': '20 Cooper Square, Newyork',
      },
      {
        'id': '#1458119',
        'status': 'Processing',
        'tab_filter': 'pending',
        'product_name': 'Travel Backpack',
        'quantity': 1,
        'total': 89.99,
        'date': '24 Aug, 2025',
        'address': '123 Main St, Newyork',
      },
      {
        'id': '#1458120',
        'status': 'Completed',
        'tab_filter': 'completed',
        'product_name': 'Phone Case',
        'quantity': 3,
        'total': 36.99,
        'date': '20 Aug, 2025',
        'address': '456 Park Ave, Newyork',
      },
      {
        'id': '#1458121',
        'status': 'Cancelled',
        'tab_filter': 'cancelled',
        'product_name': 'Wireless Headphones',
        'quantity': 1,
        'total': 129.99,
        'date': '15 Aug, 2025',
        'address': '789 Broadway, Newyork',
      },
    ];

    orders.assignAll(demoOrders);
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  // Process order to ship - change status from Pending/Processing to Shipped
  Future<void> processOrderToShip(String orderId) async {
    try {
      final orderIndex = orders.indexWhere((order) => order['id'] == orderId);
      
      if (orderIndex == -1) {
        Get.snackbar(
          'Error',
          'Order not found',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Get the actual order ID and current status from raw data
      final rawData = orders[orderIndex]['raw_data'];
      final actualOrderId = rawData?['_id'] ?? orderId;
      final currentStatus = rawData?['deliveryStatus']?.toString().toLowerCase() ?? 'pending';
      
      AppLogger.info('Processing order to ship: $actualOrderId (current status: $currentStatus)');
      
      // Step 1: If order is 'pending', first move it to 'processing'
      if (currentStatus == 'pending') {
        AppLogger.info('Step 1: Moving order from pending to processing');
        final processingResponse = await _orderService.updateOrderStatus(
          orderId: actualOrderId,
          status: 'processing',
        );
        
        if (processingResponse.statusCode != 200) {
          throw Exception(processingResponse.data['message'] ?? 'Failed to move order to processing');
        }
        
        AppLogger.success('Order moved to processing status');
      }
      
      // Step 2: Move order from 'processing' to 'shipped'
      AppLogger.info('Step 2: Moving order from processing to shipped');
      final shippedResponse = await _orderService.updateOrderStatus(
        orderId: actualOrderId,
        status: 'shipped',
      );
      
      if (shippedResponse.statusCode == 200) {
        // Update local state - change both display status and tab filter
        orders[orderIndex]['status'] = 'Shipped';
        orders[orderIndex]['tab_filter'] = 'to_ship';
        
        // Update raw data if exists
        if (orders[orderIndex]['raw_data'] != null) {
          orders[orderIndex]['raw_data']['deliveryStatus'] = 'shipped';
        }
        
        orders.refresh();
        
        Get.snackbar(
          'Order Processed',
          'Order $orderId is now ready to ship',
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
          colorText: Get.theme.colorScheme.primary,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        AppLogger.success('Order processed successfully - moved to To Ship tab');
      } else {
        throw Exception(shippedResponse.data['message'] ?? 'Failed to process order');
      }
    } catch (e) {
      AppLogger.error('Error processing order: $e');
      Get.snackbar(
        'Error',
        'Failed to process order: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Complete order - change status from Shipped to Delivered
  Future<void> completeOrder(String orderId) async {
    try {
      final orderIndex = orders.indexWhere((order) => order['id'] == orderId);
      
      if (orderIndex == -1) {
        Get.snackbar(
          'Error',
          'Order not found',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Get the actual order ID from raw data
      final rawData = orders[orderIndex]['raw_data'];
      final actualOrderId = rawData?['_id'] ?? orderId;
      
      AppLogger.info('Completing order: $actualOrderId');
      
      // Call API to update status to 'delivered'
      final response = await _orderService.updateOrderStatus(
        orderId: actualOrderId,
        status: 'delivered',
      );
      
      if (response.statusCode == 200) {
        // Update local state - change both display status and tab filter
        orders[orderIndex]['status'] = 'Completed';
        orders[orderIndex]['tab_filter'] = 'completed';
        
        // Update raw data if exists
        if (orders[orderIndex]['raw_data'] != null) {
          orders[orderIndex]['raw_data']['deliveryStatus'] = 'delivered';
        }
        
        orders.refresh();
        
        Get.snackbar(
          'Order Completed',
          'Order $orderId has been marked as completed',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        AppLogger.success('Order completed successfully - moved to Completed tab');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to complete order');
      }
    } catch (e) {
      AppLogger.error('Error completing order: $e');
      Get.snackbar(
        'Error',
        'Failed to complete order: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Cancel order - change status to Cancelled
  Future<void> cancelOrder(String orderId) async {
    try {
      final orderIndex = orders.indexWhere((order) => order['id'] == orderId);
      
      if (orderIndex == -1) {
        Get.snackbar(
          'Error',
          'Order not found',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Get the actual order ID from raw data
      final rawData = orders[orderIndex]['raw_data'];
      final actualOrderId = rawData?['_id'] ?? orderId;
      
      AppLogger.info('Cancelling order: $actualOrderId');
      
      // Call API to update status
      final response = await _orderService.updateOrderStatus(
        orderId: actualOrderId,
        status: 'cancelled',
      );
      
      if (response.statusCode == 200) {
        // Update local state - change both display status and tab filter
        orders[orderIndex]['status'] = 'Cancelled';
        orders[orderIndex]['tab_filter'] = 'cancelled';
        
        // Update raw data if exists
        if (orders[orderIndex]['raw_data'] != null) {
          orders[orderIndex]['raw_data']['deliveryStatus'] = 'cancelled';
        }
        
        orders.refresh();
        
        Get.snackbar(
          'Order Cancelled',
          'Order $orderId has been cancelled',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        AppLogger.success('Order cancelled successfully - moved to Cancelled tab');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to cancel order');
      }
    } catch (e) {
      AppLogger.error('Error cancelling order: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel order: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
