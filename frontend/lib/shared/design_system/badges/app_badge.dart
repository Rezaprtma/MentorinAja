import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Small semantic status indicator.
///
/// Renders a pill-shaped label with background/text colors derived from
/// [variant]. Use inline next to titles, inside lists, or as trailing widgets
/// to communicate status at a glance.
enum AppBadgeVariant { success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
    this.size = AppBadgeSize.medium,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;
  final AppBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);
    final textStyle = size == AppBadgeSize.small
        ? AppTypeScale.labelSmall
        : AppTypeScale.labelMedium;
    final padding = size == AppBadgeSize.small
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: colors.$2),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            label,
            style: textStyle.copyWith(
              color: colors.$2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    return switch (variant) {
      AppBadgeVariant.success => (ext.successContainer, ext.onSuccessContainer),
      AppBadgeVariant.warning => (ext.warningContainer, ext.onWarningContainer),
      AppBadgeVariant.error => (scheme.errorContainer, scheme.onErrorContainer),
      AppBadgeVariant.info => (ext.infoContainer, ext.onInfoContainer),
      AppBadgeVariant.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
  }
}

enum AppBadgeSize { small, medium }
