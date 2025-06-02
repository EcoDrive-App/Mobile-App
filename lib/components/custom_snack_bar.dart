import 'package:flutter/material.dart';

class CustomSnackBar {
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required String text,
    required IconData icon,
    Color? backgroundColor,
    int durationSeconds = 2,
    double bottomMargin = 150,
  }) {
    if (_isVisible) return;

    final theme = Theme.of(context).colorScheme;

    _isVisible = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: theme.onPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: theme.onPrimary, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: backgroundColor ?? theme.secondary,
        elevation: 8,
        duration: Duration(seconds: durationSeconds),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    ).closed.then((_) {
      _isVisible = false;
    });
  }
}