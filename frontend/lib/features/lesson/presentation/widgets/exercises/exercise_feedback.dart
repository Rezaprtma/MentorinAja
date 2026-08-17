import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Indigo hint callout revealed on request after a wrong answer.
class ExerciseHintView extends StatelessWidget {
  const ExerciseHintView({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: Container(
        key: const ValueKey('exercise-hint'),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: AppIconSizes.md,
              color: scheme.onSecondaryContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                hint,
                style: AppTypeScale.bodyMedium.copyWith(
                  color: scheme.onSecondaryContainer,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Feedback panel shown after an exercise is answered.
///
/// Correct answers sit on a success container with a check mark; incorrect
/// answers use the error container and offer an optional hint reveal. State is
/// never communicated by color alone — an icon and text accompany every state.
class ExerciseFeedbackPanel extends StatelessWidget {
  const ExerciseFeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.message,
    this.explanation,
    this.hint,
    this.onShowHint,
  });

  final bool isCorrect;
  final String message;
  final String? explanation;
  final String? hint;
  final VoidCallback? onShowHint;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final container = isCorrect ? ext.successContainer : scheme.errorContainer;
    final onContainer = isCorrect
        ? ext.onSuccessContainer
        : scheme.onErrorContainer;
    final icon = isCorrect ? Icons.check_circle_rounded : Icons.error_rounded;

    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: Container(
        key: ValueKey('$isCorrect-$message'),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: container,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: AppIconSizes.md, color: onContainer),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: onContainer,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            if (explanation != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppIconSizes.md + AppSpacing.sm,
                ),
                child: Text(
                  explanation!,
                  style: AppTypeScale.bodySmall.copyWith(
                    color: onContainer.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
              ),
            ],
            if (!isCorrect && hint != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppIconSizes.md + AppSpacing.sm,
                ),
                child: TextButton(
                  onPressed: onShowHint,
                  style: TextButton.styleFrom(
                    foregroundColor: onContainer,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 40),
                  ),
                  child: Text(
                    'Lihat Petunjuk',
                    style: AppTypeScale.labelLarge.copyWith(
                      color: onContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
