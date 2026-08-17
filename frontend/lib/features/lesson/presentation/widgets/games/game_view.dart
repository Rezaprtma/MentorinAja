/// Game view dispatcher — routes a [LessonExercise] to its game-specific
/// interactive widget based on the exercise's [gameType].
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import 'code_ordering_game.dart';
import 'token_completion_game.dart';

/// Dispatches a [LessonExercise] to its game-specific interactive widget.
///
/// Uses the exercise's [gameType] to determine which game to render.
/// If [gameType] is null, falls back to a generic token completion game.
class GameView extends StatelessWidget {
  const GameView({super.key, required this.exercise, this.selfEvaluate = true});

  final LessonExercise exercise;
  final bool selfEvaluate;

  @override
  Widget build(BuildContext context) {
    final gameType = exercise.gameType ?? GameType.tokenCompletion;

    return switch (gameType) {
      GameType.tokenCompletion => TokenCompletionGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
      GameType.codeOrdering => CodeOrderingGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
      ),
      GameType.multipleChoice => _Placeholder(name: gameType.name),
      GameType.identifyError => _Placeholder(name: gameType.name),
      GameType.outputPrediction => _Placeholder(name: gameType.name),
    };
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      compact: true,
      icon: Icons.videogame_asset_outlined,
      title: 'Game Segera Hadir',
      message: 'Game $name belum tersedia.',
    );
  }
}
