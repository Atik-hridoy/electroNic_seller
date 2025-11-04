import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_service.dart';

// Notification Item Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isHighlighted;
  final String? type;
  final Map<String, dynamic>? rawData;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isHighlighted,
    this.type,
    this.rawData,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    // Handle both 'read' and 'isRead' fields
    bool isUnread = false;
    if (json.containsKey('read')) {
      isUnread = json['read'] == false;
    } else if (json.containsKey('isRead')) {
      isUnread = json['isRead'] == false;
    }
    
    return NotificationItem(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? '',
      time: _formatTime(json['createdAt']?.toString() ?? ''),
      isHighlighted: isUnread,
      type: json['referenceModel']?.toString() ?? json['type']?.toString(),
      rawData: json,
    );
  }

  static String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }
}

// Notification Controller
class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    
    try {
      final response = await _notificationService.getNotifications();
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        print('🔍 Response structure: ${data.runtimeType}');
        print('🔍 Data keys: ${data is Map ? data.keys.toList() : "Not a Map"}');
        
        // Handle different response structures
        List<dynamic> notificationsList = [];
        
        if (data is List) {
          notificationsList = data;
        } else if (data is Map) {
          // Check for nested data.result structure
          if (data['data'] is Map && data['data']['result'] is List) {
            notificationsList = data['data']['result'] as List<dynamic>;
            print('🔍 Found in data.result: ${notificationsList.length} items');
          }
          // If response is wrapped in { success: true, data: [...] }
          else if (data['data'] is List) {
            notificationsList = data['data'] as List<dynamic>;
            print('🔍 Found in data: ${notificationsList.length} items');
          } 
          // If response is { notifications: [...] }
          else if (data['notifications'] is List) {
            notificationsList = data['notifications'] as List<dynamic>;
            print('🔍 Found in notifications: ${notificationsList.length} items');
          }
          // If response has result key directly
          else if (data['result'] is List) {
            notificationsList = data['result'] as List<dynamic>;
            print('🔍 Found in result: ${notificationsList.length} items');
          }
        }
        
        // Convert to NotificationItem objects
        notifications.value = notificationsList
            .map((json) => NotificationItem.fromJson(json as Map<String, dynamic>))
            .toList();
        
        print('✅ Loaded ${notifications.length} notifications');
      } else {
        print('❌ Failed to load notifications: ${response.statusCode}');
        _loadDemoNotifications();
      }
    } catch (e) {
      print('❌ Error loading notifications: $e');
      _loadDemoNotifications();
      
      Get.snackbar(
        'Error',
        'Failed to load notifications',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDemoNotifications() {
    // Fallback demo data
    notifications.value = [
      NotificationItem(
        id: '1',
        title: 'Your order is submitted',
        message: "Your device 'Trkli Tracker' is in Panidns stage now",
        time: '2:30 am',
        isHighlighted: true,
      ),
      NotificationItem(
        id: '2164165',
        title: 'Your order 2164165 in processing',
        message: "Your device 'Trkli Tracker' is in Panidns stage now",
        time: '2:30 am',
        isHighlighted: false,
      ),
    ];
  }

  void deleteNotification(String id) {
    notifications.removeWhere((notification) => notification.id == id);
    Get.snackbar(
      'Deleted',
      'Notification deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        time: notification.time,
        isHighlighted: false, // Mark as read by removing highlight
      );
      
      Get.snackbar(
        'Marked as read',
        'Notification marked as read',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
    }
  }

  void showNotificationOptions(BuildContext context, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.mark_email_read, 
                color: notification.isHighlighted ? Colors.blue : Colors.grey,
              ),
              title: Text(
                notification.isHighlighted ? 'Mark as read' : 'Already read',
                style: TextStyle(
                  color: notification.isHighlighted ? Colors.black : Colors.grey,
                ),
              ),
              onTap: notification.isHighlighted ? () {
                Navigator.pop(context);
                markAsRead(notification.id);
              } : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                deleteNotification(notification.id);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void refreshNotifications() {
    loadNotifications();
  }

  Future<void> markAllAsRead() async {
    // Count unread notifications
    final unreadCount = notifications.where((n) => n.isHighlighted).length;
    
    if (unreadCount == 0) {
      Get.snackbar(
        'No Unread',
        'All notifications are already read',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
      return;
    }
    
    Get.dialog(
      AlertDialog(
        title: const Text('Mark All as Read'),
        content: Text('Mark $unreadCount notification${unreadCount > 1 ? 's' : ''} as read?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              
              // Show loading
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );
              
              try {
                // Call API to mark all as read
                final response = await _notificationService.markAllNotificationsAsRead();
                
                if (response.statusCode == 200) {
                  // Update local notifications
                  final updatedNotifications = notifications.map((notification) {
                    return NotificationItem(
                      id: notification.id,
                      title: notification.title,
                      message: notification.message,
                      time: notification.time,
                      isHighlighted: false, // Mark as read
                      type: notification.type,
                      rawData: notification.rawData,
                    );
                  }).toList();
                  
                  notifications.value = updatedNotifications;
                  
                  // Close loading
                  Get.back();
                  
                  Get.snackbar(
                    'All Read',
                    '$unreadCount notification${unreadCount > 1 ? 's' : ''} marked as read',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green.shade100,
                    colorText: Colors.green.shade800,
                    icon: const Icon(Icons.done_all, color: Colors.green),
                  );
                } else {
                  // Close loading
                  Get.back();
                  
                  Get.snackbar(
                    'Error',
                    'Failed to mark notifications as read',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade800,
                  );
                }
              } catch (e) {
                // Close loading
                Get.back();
                
                print('❌ Error marking all as read: $e');
                
                Get.snackbar(
                  'Error',
                  'Failed to mark notifications as read',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.red.shade800,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Mark All'),
          ),
        ],
      ),
    );
  }

  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifications.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All notifications cleared',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.orange.shade100,
                colorText: Colors.orange.shade800,
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}