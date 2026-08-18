//**
// frontend/features/lesson/presentation/stages/game_stage.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/lesson_exercise.dart';
import '../widgets/games/game_view.dart';
import '../widgets/learning_navigation_bar.dart';

class GameStageView extends StatelessWidget {
  const GameStageView({
    super.key,
    required this.lesson,
    required this.lessonNumber,
    required this.games,
    required this.gameIndex,
  });

  final CourseLesson lesson;

  final int lessonNumber;

  final List<LessonExercise> games;

  final int gameIndex;

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
          Text(
            'Game Tantangan',
            style: AppTypeScale.titleSmall.copyWith(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (games.isEmpty)
            const AppEmptyState(
              compact: true,
              icon: Icons.videogame_asset_outlined,
              title: 'Tantangan Segera Hadir',
              message: 'Belum ada tantangan untuk pelajaran ini.',
            )
          else
            ...List.generate(games.length, (idx) {
              final activeExercise = games[idx];
              final countStr = '${idx + 1}'.padLeft(2, '0');
              final totalStr = '${games.length}'.padLeft(2, '0');
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                child: GameView(
                  key: ValueKey(activeExercise.title ?? 'game-$idx'),
                  exercise: activeExercise,
                  selfEvaluate: true,
                  gameCounter: '$countStr / $totalStr',
                ),
              );
            }),
        ],
      ),
    );
  }
}
