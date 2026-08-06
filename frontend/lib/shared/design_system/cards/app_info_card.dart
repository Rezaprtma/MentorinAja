import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_base_card.dart';

/// Semantic info card with tinted background.
///
/// Used to display informational messages, tips, warnings or success notices.
/// The [variant] controls the tint and icon color so every info card is
/// consistent with the semantic color palette.
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.variant = AppInfoCardVariant.info,
    this.action,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  /// Leading icon; defaults to a variant-appropriate icon.
  final IconData? icon;

  /// Primary title text.
  final String title;

  /// Optional supporting message.
  final String? message;

  /// Semantic variant controlling tint and icon color.
  final AppInfoCardVariant variant;

  /// Optional action widget rendered at the end (e.g. a TextButton).
  final Widget? action;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final colors = _variantColors(scheme, ext);

    return AppBaseCard(
      onTap: onTap,
      padding: padding,
      color: colors.$1,
      elevation: AppElevation.flat,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? colors.$3, color: colors.$2, size: AppIconSizes.xl),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
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
                    message!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: colors.$2.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }

  /// Returns (containerColor, foregroundColor, defaultIcon).
  (Color, Color, IconData) _variantColors(
    ColorScheme scheme,
    AppThemeExtension ext,
  ) {
    return switch (variant) {
      AppInfoCardVariant.info => (
        ext.infoContainer,
        ext.onInfoContainer,
        Icons.info_outline,
      ),
      AppInfoCardVariant.success => (
        ext.successContainer,
        ext.onSuccessContainer,
        Icons.check_circle_outline,
      ),
      AppInfoCardVariant.warning => (
        ext.warningContainer,
        ext.onWarningContainer,
        Icons.warning_amber_rounded,
      ),
      AppInfoCardVariant.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.error_outline,
      ),
    };
  }
}

enum AppInfoCardVariant { info, success, warning, error }
