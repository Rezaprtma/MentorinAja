import 'package:flutter/material.dart';

/// Themed alert dialog with a static [show] helper.
///
/// Renders a Material 3 [AlertDialog] with the design tokens and wraps it in a
/// standard `showDialog` call. The static helper keeps dialog presentation
/// consistent and reduces boilerplate at call sites.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    this.title,
    this.icon,
    this.message,
    this.content,
    this.actions,
    this.dismissible = true,
  });

  final String? title;
  final Widget? icon;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final bool dismissible;

  /// Displays a themed alert dialog.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? icon,
    String? message,
    Widget? content,
    List<Widget>? actions,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => AppAlertDialog(
        title: title,
        icon: icon,
        message: message,
        content: content,
        actions: actions,
        dismissible: dismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveActions =
        actions ??
        [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ];

    return AlertDialog(
      icon: icon,
      title: title != null ? Text(title!) : null,
      content: content ?? (message != null ? Text(message!) : null),
      actions: effectiveActions,
      iconPadding: icon != null ? null : EdgeInsets.zero,
    );
  }
}
