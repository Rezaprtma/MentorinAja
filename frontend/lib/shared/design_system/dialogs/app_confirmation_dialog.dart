//**
// frontend/shared/design_system/dialogs/app_confirmation_dialog.dart
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
import '../buttons/app_button.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    this.title,
    this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.isConfirmLoading = false,
    this.icon,
  });

  final String? title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final bool isConfirmLoading;
  final Widget? icon;

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    bool isConfirmLoading = false,
    Widget? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: !isConfirmLoading,
      builder: (_) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        isConfirmLoading: isConfirmLoading,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title: title != null ? Text(title!) : null,
      content: message != null ? Text(message!) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        AppButton(
          label: confirmLabel,
          variant: isDestructive
              ? AppButtonVariant.danger
              : AppButtonVariant.primary,
          isLoading: isConfirmLoading,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
