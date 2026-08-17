import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/lesson_exercise.dart';
import '../widgets/learning_navigation_bar.dart';
import '../widgets/exercises/lesson_exercise_view.dart';
import '../widgets/stages/stage_intro_card.dart';
import 'lesson_stage.dart';

/// Latihan stage — application and reinforcement exercises.
///
/// Renders the stage intro and the application exercises (correction and
/// explanation) stacked with breathing room. Exercises keep their submit
/// button for deliberate practice. Bottom padding reserves space so the
/// floating session controls never cover an exercise.
class LatihanStageView extends StatelessWidget {
  const LatihanStageView({
    super.key,
    required this.lesson,
    required this.exercises,
  });

  final CourseLesson lesson;

  /// Application exercises for this lesson.
  final List<LessonExercise> exercises;

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
          const StageIntroCard(stage: LessonStage.latihan),
          const SizedBox(height: AppSpacing.md),
          if (exercises.isEmpty)
            const AppEmptyState(
              compact: true,
              icon: Icons.assignment_outlined,
              title: 'Latihan Segera Hadir',
              message: 'Belum ada latihan untuk pelajaran ini.',
            )
          else
            for (final exercise in exercises) ...[
              LessonExerciseView(exercise: exercise),
              const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}
