import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/tech/tech_logo.dart';

import '../../mock_progress_data.dart';

/// Card for a finished course.
///
/// Belongs to the same white card language as the active course cards: identical
/// container, spacing, typography and logo treatment, with a subtle "Selesai"
/// success badge and a fully filled green progress bar as the only differences.
class CompletedCourseCard extends StatelessWidget {
  const CompletedCourseCard({super.key, required this.course, this.onTap});

  /// The finished course to display.
  final MockProgressCourse course;

  /// Reopens the completed course.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TechLogo(
                assetPath: course.iconPath,
                background: scheme.primaryContainer,
                size: AppIconSizes.xxxxl,
              ),
              const Spacer(),
              const AppBadge(
                label: 'Selesai',
                variant: AppBadgeVariant.success,
                icon: Icons.check_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            course.title,
            style: AppTypeScale.headlineSmall.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${course.completedLessons} dari ${course.lessonCount} pelajaran',
            style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          AppLinearLoader(
            value: 1.0,
            minHeight: AppSpacing.xs,
            color: ext.success,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
