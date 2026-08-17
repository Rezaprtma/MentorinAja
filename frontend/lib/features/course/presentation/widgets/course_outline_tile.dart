import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/course_lesson.dart';

/// One row of the course outline.
///
/// Renders the lesson number, title and estimated time, plus a state icon that
/// communicates completed (success), current (brand), locked (disabled) or
/// available (neutral). The row is a quiet surface — the state icon is the only
/// signal and never relies on color alone.
class CourseOutlineTile extends StatelessWidget {
  const CourseOutlineTile({
    super.key,
    required this.number,
    required this.lesson,
    this.isLast = false,
    this.onTap,
  });

  /// One-based position in the outline, rendered as "01".
  final int number;

  final CourseLesson lesson;

  /// Whether this row is the last in the outline (hides the divider).
  final bool isLast;

  /// Opens the lesson in the Lesson Player (locked lessons are blocked by the
  /// caller); null renders the row without ink feedback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final stateColor = _stateColor(ext, scheme);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    number.toString().padLeft(2, '0'),
                    style: AppTypeScale.labelMedium.copyWith(
                      color: lesson.state == CourseLessonState.completed
                          ? ext.success
                          : ext.textDisabled,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTypeScale.bodyMedium.copyWith(
                          color: lesson.state == CourseLessonState.locked
                              ? ext.textDisabled
                              : ext.textPrimary,
                          fontWeight: lesson.state == CourseLessonState.current
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: AppIconSizes.xs,
                            color: ext.textDisabled,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${lesson.durationMinutes} menit',
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
                ),
                const SizedBox(width: AppSpacing.xs),
                if (lesson.state == CourseLessonState.current)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Lanjutkan',
                          style: AppTypeScale.labelSmall.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                  ),
                Icon(_stateIcon, size: AppIconSizes.md, color: stateColor),
              ],
            ),
          ),
          if (!isLast)
            const AppDivider(
              height: 1,
              indent: AppSpacing.md + 32 + AppSpacing.sm,
            ),
        ],
      ),
    );
  }

  IconData get _stateIcon => switch (lesson.state) {
    CourseLessonState.completed => Icons.check_circle_rounded,
    CourseLessonState.current => Icons.play_circle_rounded,
    CourseLessonState.locked => Icons.lock_outline_rounded,
    CourseLessonState.available => Icons.play_circle_outline,
  };

  Color _stateColor(AppThemeExtension ext, ColorScheme scheme) {
    return switch (lesson.state) {
      CourseLessonState.completed => ext.success,
      CourseLessonState.current => scheme.primary,
      CourseLessonState.locked => ext.textDisabled,
      CourseLessonState.available => ext.textDisabled,
    };
  }
}
