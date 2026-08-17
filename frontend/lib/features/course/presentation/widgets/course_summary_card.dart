import 'package:flutter/material.dart';

import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/tech/tech_logo.dart';

/// Compact course preview card reused across discovery surfaces.
///
/// Composes a technology logo tile, category pill, title, short description
/// and lesson meta on a flat white surface. The technology accent appears only
/// on the logo tile, the category pill and a faint border so the card reads
/// clean and consistent next to any other card.
class CourseSummaryCard extends StatelessWidget {
  const CourseSummaryCard({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.iconPath,
    required this.brand,
    required this.lessonCount,
    required this.rating,
    this.onTap,
  });

  final String title;
  final String category;
  final String description;
  final String iconPath;
  final TechBrandColors brand;
  final int lessonCount;
  final double rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      onTap: onTap,
      clipBehavior: Clip.antiAlias,
      color: ext.card,
      radius: AppRadius.large,
      elevation: AppElevation.xs,
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderSide: BorderSide(color: brand.accent.withValues(alpha: 0.16)),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brand.accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TechLogo(
                    assetPath: iconPath,
                    size: 34,
                    background: brand.background,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    color: ext.warning,
                    size: AppIconSizes.xs,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTypeScale.labelSmall.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _CategoryPill(label: category, brand: brand),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: AppTypeScale.titleSmall.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    color: ext.textDisabled,
                    size: AppIconSizes.xs,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Flexible(
                    child: Text(
                      '$lessonCount pelajaran',
                      style: AppTypeScale.labelSmall.copyWith(
                        color: ext.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small brand-tinted category label used by course cards.
class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, required this.brand});

  final String label;
  final TechBrandColors brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: brand.accent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypeScale.labelSmall.copyWith(
          color: brand.onAccent,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
