//**
// frontend/features/lesson/presentation/widgets/exercises/lesson_exercise_view.dart
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

import '../../../domain/entities/lesson_exercise.dart';
import 'code_completion_exercise.dart';
import 'code_correction_exercise.dart';
import 'code_explanation_exercise.dart';
import 'code_writing_exercise.dart';

class LessonExerciseView extends StatelessWidget {
  const LessonExerciseView({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
    this.onSuccess,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final VoidCallback? onSuccess;

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
        onSuccess: onSuccess,
      ),
    };
  }
}
