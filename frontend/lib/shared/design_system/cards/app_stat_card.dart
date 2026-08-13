import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_base_card.dart';

/// A single stat metric: icon + value + label, optionally with a trend
/// indicator.
///
/// Used on dashboards and profile screens to surface key numbers at a glance
/// (courses completed, hours studied, streak count). The icon sits in a
/// tinted container so it stands out without competing with the value.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.trend,
    this.trendUp,
    this.onTap,
    this.color,
    this.width,
    this.height,
  });

  /// The primary metric (e.g. "12", "84h", "95%").
  final String value;

  /// Descriptive label below the value.
  final String label;

  /// Optional leading icon rendered in a tinted circle.
  final IconData? icon;

  /// Optional trend text (e.g. "+12%").
  final String? trend;

  /// Whether the trend is positive (green) or negative (red).
  final bool? trendUp;

  final VoidCallback? onTap;

  /// Accent color for the icon tint and optional value color.
  final Color? color;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final accent = color ?? scheme.primary;

    return AppBaseCard(
      onTap: onTap,
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: AppIconSizes.xxxxl,
              height: AppIconSizes.xxxxl,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: AppIconSizes.xl),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypeScale.headlineSmall.copyWith(
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  label,
                  style: AppTypeScale.bodySmall.copyWith(
                    color: ext.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trend != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: (trendUp == true ? ext.success : scheme.error)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                trend!,
                style: AppTypeScale.labelSmall.copyWith(
                  color: trendUp == true ? ext.success : scheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
