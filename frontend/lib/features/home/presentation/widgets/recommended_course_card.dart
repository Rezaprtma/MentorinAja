import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_home_data.dart';

/// Vivid course card used in the Home "Untuk Kamu" recommendation rail.
///
/// The card surface is the course's brand accent with the real technology logo
/// rendered directly on it — no mini container behind the icon. A soft white
/// circle and a faint cropped copy of the logo decorate the background, and the
/// footer carries the lesson count and rating in the brand's on-color.
class RecommendedCourseCard extends StatelessWidget {
  const RecommendedCourseCard({super.key, required this.course, this.onTap});

  /// The recommended course to display.
  final MockCourse course;

  /// Opens the course detail.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = course.brand;
    final palette = brand ?? _palette(context);
    final surface = palette.accent;
    final onColor = palette.onAccent;

    return AppBaseCard(
      onTap: onTap,
      clipBehavior: Clip.antiAlias,
      color: surface,
      radius: AppRadius.large,
      elevation: AppElevation.xs,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -24,
            right: -32,
            child: Opacity(
              opacity: 0.14,
              child: AppSvg(course.iconPath, width: 96, height: 96),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppSvg(
                      course.iconPath,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        course.title,
                        style: AppTypeScale.titleLarge.copyWith(
                          color: onColor,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  course.description,
                  style: AppTypeScale.bodySmall.copyWith(
                    color: onColor.withValues(alpha: 0.80),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: AppIconSizes.sm,
                      color: onColor.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        '${course.lessonCount} pelajaran',
                        style: AppTypeScale.labelMedium.copyWith(
                          color: onColor.withValues(alpha: 0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.star_rounded,
                      size: AppIconSizes.sm,
                      color: onColor,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: AppTypeScale.labelMedium.copyWith(
                        color: onColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback palette used when the course has no brand colors.
  TechBrandColors _palette(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (course.accent) {
      CourseAccent.primary => TechBrandColors(
        background: scheme.primaryContainer,
        accent: scheme.primary,
        onAccent: scheme.onPrimary,
      ),
      CourseAccent.secondary => TechBrandColors(
        background: scheme.secondaryContainer,
        accent: scheme.secondary,
        onAccent: scheme.onSecondary,
      ),
      CourseAccent.neutral => TechBrandColors(
        background: scheme.surfaceContainerLow,
        accent: scheme.primary,
        onAccent: scheme.onPrimary,
      ),
    };
  }
}
