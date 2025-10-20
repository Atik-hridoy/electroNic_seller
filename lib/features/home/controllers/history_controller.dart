import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Observable list of orders
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load orders when controller initializes
    loadOrders();
  }

  // Load orders (in real app, this would be an API call)
  Future<void> loadOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Demo data
    final demoOrders = [
      {
        'id': '#1458118',
        'status': 'Pending',
        'product_name': 'Luggage Tag',
        'quantity': 2,
        'total': 18.0,
        'date': '25 Aug, 2025',
        'address': '20 Cooper Square, Newyork',
      },
      {
        'id': '#1458119',
        'status': 'To Ship',
        'product_name': 'Travel Backpack',
        'quantity': 1,
        'total': 89.99,
        'date': '24 Aug, 2025',
        'address': '123 Main St, Newyork',
      },
      {
        'id': '#1458120',
        'status': 'Completed',
        'product_name': 'Phone Case',
        'quantity': 3,
        'total': 36.99,
        'date': '20 Aug, 2025',
        'address': '456 Park Ave, Newyork',
      },
      {
        'id': '#1458121',
        'status': 'Cancelled',
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
}
