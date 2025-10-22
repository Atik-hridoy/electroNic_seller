// ignore_for_file: use_super_parameters

import 'dart:developer' as developer;
import 'package:electronic/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);
  
  // Get the controller instance with error handling
  AccountController get _accountController {
    try {
      return Get.find<AccountController>();
    } catch (e) {
      developer.log('Error getting AccountController: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Access controller to ensure it's initialized
        final controller = _accountController;
        developer.log('AccountController initialized: ${controller.runtimeType}');
      } catch (e) {
        developer.log('Failed to initialize AccountController: $e');
        Get.snackbar('Error', 'Failed to load account information');
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Header Section
          GestureDetector(
            onTap: () {
              try {
                final controller = _accountController;
                developer.log('Navigating to edit account');
                Get.toNamed(Routes.editAccount);
              } catch (e) {
                developer.log('Navigation error: $e');
                Get.snackbar('Error', 'Unable to edit account. Please try again.');
              }
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

          // Menu Items
        
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              // Navigate to about
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
    );
  }

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
                controller.logout();
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
