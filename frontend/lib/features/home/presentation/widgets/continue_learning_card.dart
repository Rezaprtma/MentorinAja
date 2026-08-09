import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Primary "Continue learning" hero on the Home screen.
///
/// Carries the highest priority of the Home dashboard: a soft orange hero
/// surface holds the section eyebrow, a dominant course title and a circular
/// play badge, then a white progress panel and an orange CTA. The layered
/// composition — tinted hero, white inner surface, full-width button — makes
/// the resume point the deliberate visual anchor of the page.
class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.courseTitle,
    required this.lessonLabel,
    required this.progress,
    required this.onContinue,
  });

  /// Course name being resumed.
  final String courseTitle;

  /// Current lesson line, e.g. "Lesson 12 of 20 • Functions".
  final String lessonLabel;

  /// Completion fraction in the range 0.0–1.0.
  final double progress;

  /// Resumes the lesson.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final percent = (progress * 100).round();

    return AppContainer(
      color: scheme.primaryContainer,
      radius: AppRadius.extraLarge,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continue learning',
                      style: AppTypeScale.labelLarge.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      courseTitle,
                      style: AppTypeScale.headlineSmall.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      lessonLabel,
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ext.card,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: scheme.primary,
                  size: AppIconSizes.xl,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppContainer(
            color: ext.card,
            radius: AppRadius.large,
            borderColor: ext.border,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppLinearLoader(
                    value: progress,
                    minHeight: AppSpacing.xs,
                    color: scheme.primary,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$percent%',
                  style: AppTypeScale.labelLarge.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Continue lesson',
            leadingIcon: Icons.play_arrow_rounded,
            onPressed: onContinue,
            isFullWidth: true,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }
}
