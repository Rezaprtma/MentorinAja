import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Modal dialog that blocks interaction while a background task runs.
///
/// Uses `showDialog` with `barrierDismissible: false` and `PopScope` to
/// prevent back-button dismissal. Call [AppLoadingDialog.hide] when the
/// operation completes.
class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({super.key, this.message});

  final String? message;

  /// Displays a non-dismissible loading dialog.
  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          PopScope(canPop: false, child: AppLoadingDialog(message: message)),
    );
  }

  /// Pops the currently displayed loading dialog.
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AlertDialog(
      backgroundColor: ext.card,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
