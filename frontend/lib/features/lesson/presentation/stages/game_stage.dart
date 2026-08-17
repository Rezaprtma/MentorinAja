import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/lesson_exercise.dart';
import '../widgets/learning_navigation_bar.dart';
import '../widgets/games/game_view.dart';
import '../widgets/stages/stage_intro_card.dart';
import 'lesson_stage.dart';

/// Game stage — a hands-on code challenge wrapped in a playful frame.
///
/// Renders the stage intro, a challenge strip that frames the exercise as a
/// level, and the completion exercise in self-evaluate mode so the learner
/// gets instant inline feedback. Bottom padding reserves space so the floating
/// session controls never cover the challenge.
class GameStageView extends StatelessWidget {
  const GameStageView({
    super.key,
    required this.lesson,
    required this.lessonNumber,
    required this.exercise,
  });

  final CourseLesson lesson;

  /// 1-based position of this lesson inside the course.
  final int lessonNumber;

  /// The completion challenge for this lesson, or null when none exists.
  final LessonExercise? exercise;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsivePadding.horizontal(context),
        AppSpacing.md,
        ResponsivePadding.horizontal(context),
        LearningNavigationBar.reservedContentSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StageIntroCard(stage: LessonStage.game),
          const SizedBox(height: AppSpacing.md),
          _ChallengeStrip(level: lessonNumber),
          const SizedBox(height: AppSpacing.md),
          if (exercise == null)
            const AppEmptyState(
              compact: true,
              icon: Icons.videogame_asset_outlined,
              title: 'Tantangan Segera Hadir',
              message: 'Belum ada tantangan untuk pelajaran ini.',
            )
          else
            GameView(exercise: exercise!, selfEvaluate: true),
        ],
      ),
    );
  }
}

/// Playful header framing the challenge as a level with a brand chip.
class _ChallengeStrip extends StatelessWidget {
  const _ChallengeStrip({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bolt_rounded,
            size: AppIconSizes.md,
            color: scheme.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Level $level',
              style: AppTypeScale.labelLarge.copyWith(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'TANTANGAN',
              style: AppTypeScale.labelSmall.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
