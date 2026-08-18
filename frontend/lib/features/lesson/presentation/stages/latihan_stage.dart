//**
// frontend/features/lesson/presentation/stages/latihan_stage.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/lesson_exercise.dart';
import '../widgets/exercises/lesson_exercise_view.dart';
import '../widgets/learning_navigation_bar.dart';

class LatihanStageView extends StatelessWidget {
  const LatihanStageView({
    super.key,
    required this.lesson,
    required this.exercise,
    this.onSuccess,
  });

  final CourseLesson lesson;
  final LessonExercise? exercise;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ResponsivePadding.horizontal(context),
          AppSpacing.md,
          ResponsivePadding.horizontal(context),
          LearningNavigationBar.reservedContentSpace,
        ),
        child: const AppEmptyState(
          compact: true,
          icon: Icons.assignment_outlined,
          title: 'Latihan Segera Hadir',
          message: 'Belum ada latihan untuk pelajaran ini.',
        ),
      );
    }

    if (exercise!.type == LessonExerciseType.codeWriting) {
      // Full screen workspace for code editor
      return Padding(
        padding: EdgeInsets.fromLTRB(
          ResponsivePadding.horizontal(context),
          AppSpacing.md,
          ResponsivePadding.horizontal(context),
          0,
        ),
        child: LessonExerciseView(
          key: ValueKey(exercise!.title ?? 'latihan'),
          exercise: exercise!,
          onSuccess: onSuccess,
        ),
      );
    }

    // Default scrollable view for non-editor exercises
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
          LessonExerciseView(
            key: ValueKey(exercise!.title ?? 'latihan'),
            exercise: exercise!,
            onSuccess: onSuccess,
          ),
        ],
      ),
    );
  }
}
