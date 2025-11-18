import 'package:flutter/material.dart';

class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String title, String message) {
    _showSnackBar(title, message, Colors.green[50], Colors.green[900]);
  }

  static void showError(String title, String message) {
    _showSnackBar(title, message, Colors.red[50], Colors.red[900]);
  }

  static void showWarning(String title, String message) {
    _showSnackBar(title, message, Colors.orange[50], Colors.orange[900]);
  }

  static void _showSnackBar(
    String title,
    String message,
    Color? background,
    Color? foreground,
  ) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background ?? Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: foreground ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(color: foreground ?? Colors.white),
              ),
            ],
          ),
        ),
      );
  }
}
