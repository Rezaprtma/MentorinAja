import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_snack_bar.dart';

/// Themed banner notification displayed at the top of the screen.
///
/// Wraps Material [MaterialBanner] with semantic color variants. Useful for
/// persistent, non-blocking notices that need more space than a snack bar
/// (e.g. connection lost, update available).
class AppBanner {
  AppBanner._();

  /// Shows a themed [MaterialBanner] via [ScaffoldMessenger].
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    AppFeedbackSeverity severity = AppFeedbackSeverity.info,
    List<Widget>? actions,
    Duration duration = const Duration(seconds: 6),
    bool autoDismiss = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final colors = _colors(scheme, ext, severity);

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: colors.$1,
        leading: Icon(_icon(severity), color: colors.$2, size: AppIconSizes.lg),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTypeScale.titleSmall.copyWith(color: colors.$2),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                message,
                style: AppTypeScale.bodySmall.copyWith(
                  color: colors.$2.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
        actions:
            (actions ??
                    [
                      TextButton(
                        onPressed: () => messenger.hideCurrentMaterialBanner(),
                        child: Text(
                          'Dismiss',
                          style: TextStyle(color: colors.$2),
                        ),
                      ),
                    ])
                .map(
                  (a) => DefaultTextStyle(
                    style: TextStyle(color: colors.$2),
                    child: a,
                  ),
                )
                .toList(),
      ),
    );

    if (autoDismiss) {
      Timer(duration, () => messenger.hideCurrentMaterialBanner());
    }
  }

  static (Color, Color) _colors(
    ColorScheme scheme,
    AppThemeExtension ext,
    AppFeedbackSeverity severity,
  ) {
    return switch (severity) {
      AppFeedbackSeverity.success => (
        ext.successContainer,
        ext.onSuccessContainer,
      ),
      AppFeedbackSeverity.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      AppFeedbackSeverity.warning => (
        ext.warningContainer,
        ext.onWarningContainer,
      ),
      AppFeedbackSeverity.info => (ext.infoContainer, ext.onInfoContainer),
      AppFeedbackSeverity.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
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
