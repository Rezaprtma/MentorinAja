//**
// frontend/features/lesson/presentation/widgets/games/game_view.dart
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
library;

import 'package:flutter/material.dart';

import '../../../domain/entities/lesson_exercise.dart';
import 'code_ordering_game.dart';
import 'identify_error_game.dart';
import 'multiple_choice_game.dart';
import 'output_prediction_game.dart';
import 'token_completion_game.dart';

class GameView extends StatelessWidget {
  const GameView({
    super.key,
    required this.exercise,
    this.selfEvaluate = true,
    this.gameCounter,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final String? gameCounter;

  @override
  Widget build(BuildContext context) {
    final gameType = exercise.gameType ?? GameType.tokenCompletion;

    return switch (gameType) {
      GameType.tokenCompletion => TokenCompletionGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
        gameCounter: gameCounter,
      ),
      GameType.codeOrdering => CodeOrderingGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
        gameCounter: gameCounter,
      ),
      GameType.multipleChoice => MultipleChoiceGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
        gameCounter: gameCounter,
      ),
      GameType.identifyError => IdentifyErrorGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
        gameCounter: gameCounter,
      ),
      GameType.outputPrediction => OutputPredictionGame(
        exercise: exercise,
        selfEvaluate: selfEvaluate,
        gameCounter: gameCounter,
      ),
    };
  }
}
