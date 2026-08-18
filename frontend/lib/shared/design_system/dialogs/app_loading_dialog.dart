//**
// frontend/shared/design_system/dialogs/app_loading_dialog.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({super.key, this.message});

  final String? message;

  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          PopScope(canPop: false, child: AppLoadingDialog(message: message)),
    );
  }

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
