//**
// frontend/features/lesson/presentation/widgets/exercises/exercise_card.dart
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

import '../../../domain/entities/lesson_exercise.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.child,
    this.isGame = false,
    this.gameCounter,
  });

  final LessonExercise exercise;
  final Widget child;
  final bool isGame;
  final String? gameCounter;

  String _getGameTitle() {
    if (exercise.title != null &&
        exercise.title!.isNotEmpty &&
        exercise.title != 'Latihan') {
      return exercise.title!;
    }
    final gameType = exercise.gameType ?? GameType.tokenCompletion;
    return switch (gameType) {
      GameType.codeOrdering => 'Susun Kode',
      GameType.tokenCompletion => 'Lengkapi Kode',
      GameType.multipleChoice => 'Pilih Jawaban',
      GameType.identifyError => 'Temukan Kesalahan',
      GameType.outputPrediction => 'Tebak Output',
    };
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    final title = isGame
        ? _getGameTitle()
        : (exercise.title ?? 'Latihan Coding');

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypeScale.titleMedium.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (isGame && gameCounter != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  gameCounter!.replaceAll('0', '').trim(),
                  style: AppTypeScale.labelMedium.copyWith(
                    color: ext.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          if (exercise.instruction != null) ...[
            const SizedBox(height: AppSpacing.xs),
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
