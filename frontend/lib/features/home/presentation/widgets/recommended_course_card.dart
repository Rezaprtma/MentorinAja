import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_home_data.dart';

/// Compact clickable course row used in the Home recommendations.
///
/// Renders a soft indigo icon chip, the course title, a category • lesson
/// count line and a trailing chevron. Rows carry no own surface and are meant
/// to live as siblings inside a single grouped surface, separated by hairlines,
/// so the curated feed reads as one lightweight list instead of stacked cards.
class RecommendedCourseCard extends StatelessWidget {
  const RecommendedCourseCard({super.key, required this.course, this.onTap});

  /// The recommended course to display.
  final MockCourse course;

  /// Opens the course detail.
  final VoidCallback? onTap;

  /// Icon chip height and width.
  static const double iconSize = 46;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                course.icon,
                color: scheme.secondary,
                size: AppIconSizes.lg,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    style: AppTypeScale.titleSmall.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${course.category} • ${course.lessonCount} lessons',
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right_rounded,
              color: ext.textSecondary,
              size: AppIconSizes.md,
            ),
          ],
        ),
      ),
    );
  }
}
