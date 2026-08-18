//**
// frontend/features/lesson/presentation/widgets/exercises/exercise_feedback.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
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

import 'package:frontend/shared/design_system/design_system.dart';

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
    final Color backgroundColor = isCorrect
        ? ext.successContainer.withValues(alpha: 0.25)
        : scheme.errorContainer.withValues(alpha: 0.25);
    final Color textColor = isCorrect
        ? ext.onSuccessContainer
        : scheme.onErrorContainer;
    final Color borderColor = isCorrect
        ? ext.success.withValues(alpha: 0.4)
        : scheme.error.withValues(alpha: 0.4);
    final icon = isCorrect ? Icons.check_circle_rounded : Icons.error_rounded;

    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: Container(
        key: ValueKey('$isCorrect-$message'),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: AppIconSizes.md, color: textColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: textColor,
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
                    color: textColor.withValues(alpha: 0.95),
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
                    foregroundColor: textColor,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 40),
                  ),
                  child: Text(
                    'Lihat Petunjuk',
                    style: AppTypeScale.labelLarge.copyWith(
                      color: textColor,
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
