import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';

/// Shared card shell for every interactive lesson exercise.
///
/// Leads with a "COBA SENDIRI" phase eyebrow, the exercise title and a short
/// instruction, then renders the exercise-specific [child] below. All exercise
/// types reuse this shell so the lesson keeps one visual rhythm.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise, required this.child});

  final LessonExercise exercise;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'COBA SENDIRI',
            style: AppTypeScale.labelSmall.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            exercise.title ?? 'Latihan',
            style: AppTypeScale.titleMedium.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (exercise.instruction != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              exercise.instruction!,
              style: AppTypeScale.bodySmall.copyWith(
                color: ext.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
