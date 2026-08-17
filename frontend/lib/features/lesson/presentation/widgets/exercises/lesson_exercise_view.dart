import 'package:flutter/material.dart';

import '../../../domain/entities/lesson_exercise.dart';
import 'code_completion_exercise.dart';
import 'code_correction_exercise.dart';
import 'code_explanation_exercise.dart';
import 'code_writing_exercise.dart';

/// Dispatches a [LessonExercise] to its reusable interactive widget.
///
/// The Course Player only renders [LessonExerciseView]. Adding a new exercise
/// type means adding its model value and renderer here, not rewriting the
/// player page. With [selfEvaluate] the exercise checks the answer the moment
/// the learner completes it, instead of waiting for a submit button.
class LessonExerciseView extends StatelessWidget {
  const LessonExerciseView({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
  });

  final LessonExercise exercise;

  /// Whether the answer is evaluated immediately on completion. The Game stage
  /// enables this for instant challenge feedback; Latihan keeps the submit
  /// button for deliberate practice.
  final bool selfEvaluate;

  @override
  Widget build(BuildContext context) {
    return switch (exercise.type) {
      LessonExerciseType.codeCompletion => CodeCompletionExercise(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
      LessonExerciseType.codeCorrection => CodeCorrectionExercise(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
      LessonExerciseType.codeExplanation => CodeExplanationExercise(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
      LessonExerciseType.codeWriting => CodeWritingExercise(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
    };
  }
}
