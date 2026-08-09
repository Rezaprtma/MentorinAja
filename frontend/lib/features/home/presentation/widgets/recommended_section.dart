import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_home_data.dart';
import 'recommended_course_card.dart';

/// Recommended-courses block on the Home screen.
///
/// Sits below the "Continue learning" hero and the open weekly stats so catalog
/// content stays lower in the visual hierarchy. Renders a generous header and
/// one grouped surface holding all [RecommendedCourseCard] rows separated by
/// hairline dividers — a single curated list rather than repeated boxed cards.
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key, this.onSeeAll, this.onCourseTap});

  /// Opens the full catalog surface.
  final VoidCallback? onSeeAll;

  /// Opens a specific course; receives its mock title.
  final ValueChanged<String>? onCourseTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final courses = MockHomeData.recommendedCourses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title: 'Recommended for you',
          trailing: TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
          padding: const EdgeInsets.only(top: AppSpacing.lg),
        ),
        AppBaseCard(
          color: ext.card,
          elevation: AppElevation.flat,
          radius: AppRadius.extraLarge,
          borderSide: BorderSide(color: ext.border),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (var i = 0; i < courses.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: AppDivider(
                      height: AppSpacing.xs,
                      indent: RecommendedCourseCard.iconSize + AppSpacing.sm,
                    ),
                  ),
                RecommendedCourseCard(
                  course: courses[i],
                  onTap: onCourseTap == null
                      ? null
                      : () => onCourseTap!(courses[i].title),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
