//**
// frontend/shared/design_system/feedback/app_snack_bar.dart
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

enum AppFeedbackSeverity { success, error, warning, info, neutral }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    AppFeedbackSeverity severity = AppFeedbackSeverity.neutral,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showIcon = true,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();

    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final colors = _colors(scheme, ext, severity);
    final icon = _icon(severity);

    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showIcon) ...[
              Icon(icon, color: colors.$2, size: AppIconSizes.md),
              const SizedBox(width: AppSpacing.xs),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTypeScale.bodyMedium.copyWith(color: colors.$2),
              ),
            ),
          ],
        ),
        backgroundColor: colors.$1,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colors.$2,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  static (Color, Color) _colors(
    ColorScheme scheme,
    AppThemeExtension ext,
    AppFeedbackSeverity severity,
  ) {
    return switch (severity) {
      AppFeedbackSeverity.success => (ext.success, ext.onSuccess),
      AppFeedbackSeverity.error => (scheme.error, scheme.onError),
      AppFeedbackSeverity.warning => (ext.warning, ext.onWarning),
      AppFeedbackSeverity.info => (ext.info, ext.onInfo),
      AppFeedbackSeverity.neutral => (
        scheme.inverseSurface,
        scheme.onInverseSurface,
      ),
    };
  }

  static IconData _icon(AppFeedbackSeverity severity) {
    return switch (severity) {
      AppFeedbackSeverity.success => Icons.check_circle_outline,
      AppFeedbackSeverity.error => Icons.error_outline,
      AppFeedbackSeverity.warning => Icons.warning_amber_rounded,
      AppFeedbackSeverity.info => Icons.info_outline,
      AppFeedbackSeverity.neutral => Icons.info_outline,
    };
  }
}
