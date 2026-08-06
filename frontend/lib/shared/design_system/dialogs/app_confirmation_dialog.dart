import 'package:flutter/material.dart';
import '../buttons/app_button.dart';

/// Confirmation dialog that returns a boolean result.
///
/// Presents a title, message and confirm/cancel buttons. The confirm button
/// uses [AppButton.danger] when [isDestructive] is true. Returns `true` when
/// confirmed, `false` when cancelled.
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

  /// Shows a confirmation dialog and returns `true` if confirmed.
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
