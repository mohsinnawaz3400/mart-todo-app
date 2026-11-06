
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

class AppSnackBar {
  AppSnackBar._();


  static Future<void> show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
        Duration duration = const Duration(seconds: 3),
      }) async {

    debugPrint('SNACKBAR: Function called');
    debugPrint('SNACKBAR MESSAGE: $message');
    debugPrint('SNACKBAR TYPE: $type');

    try {
      debugPrint('SNACKBAR: Creating Flushbar');

      await Flushbar(
        messageText: Row(
          children: [
            Icon(
              _getIcon(type),
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getColor(type),
        duration: duration,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(14),
        padding: const EdgeInsets.all(16),
      ).show(context);

      debugPrint('SNACKBAR: Flushbar completed');

    } catch (e, stackTrace) {
      debugPrint('SNACKBAR ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }


  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.error_rounded;
      case SnackBarType.warning:
        return Icons.warning_rounded;
      case SnackBarType.info:
        return Icons.info_rounded;
    }
  }

  static Color _getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF16A34A);
      case SnackBarType.error:
        return const Color(0xFFDC2626);
      case SnackBarType.warning:
        return const Color(0xFFE69B18);
      case SnackBarType.info:
        return const Color(0xFF6C63FF);
    }
  }
}
