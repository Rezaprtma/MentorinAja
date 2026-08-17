import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../stages/lesson_stage.dart';

/// Subtle three-segment indicator for the [LessonStage] a learner is in.
///
/// Rendered below the player app bar. Segments up to [current] are filled with
/// the brand color; the rest stay muted. It communicates position without
/// inviting a tap, since stage changes happen through the floating control bar.
class LessonStageIndicator extends StatelessWidget {
  const LessonStageIndicator({
    super.key,
    required this.current,
    this.stages = const [
      LessonStage.materi,
      LessonStage.game,
      LessonStage.latihan,
    ],
  });

  /// Index of the active stage within [stages].
  final int current;

  /// Ordered stages to render, defaulting to the full lesson flow.
  final List<LessonStage> stages;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: AppDurations.fast,
                  height: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: i <= current
                        ? scheme.primary
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  stages[i].label,
                  style: AppTypeScale.labelSmall.copyWith(
                    color: i == current ? scheme.primary : ext.textSecondary,
                    fontWeight: i == current
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
