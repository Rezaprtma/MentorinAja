//**
// frontend/shared/design_system/cards/app_stat_card.dart
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
import 'app_base_card.dart';

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

  final String value;

  final String label;

  final IconData? icon;

  final String? trend;

  final bool? trendUp;

  final VoidCallback? onTap;

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
