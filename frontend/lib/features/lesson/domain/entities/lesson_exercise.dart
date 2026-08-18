//**
// frontend/features/lesson/domain/entities/lesson_exercise.dart
//
// frontend:
// Entity/model. Mendefinisikan data structures untuk feature.
//
// backend:
// Future: akan sesuai dengan backend data models.
//
// api:
// Future: akan menjadi frontend expected contract untuk APIs.
//
// qa:
// QA perlu memvalidasi data validation dan edge cases.
//**
library;

import 'package:frontend/shared/enums/enums.dart';

export 'package:frontend/shared/enums/enums.dart'
    show LessonExerciseType, GameType;

class CodeCompletionBlank {
  const CodeCompletionBlank({required this.token, this.accept = const []});

  final String token;

  final List<String> accept;
}

class ExerciseChoice {
  const ExerciseChoice({required this.label, required this.isCorrect});

  final String label;

  final bool isCorrect;
}

class LessonExercise {
  const LessonExercise({
    required this.type,
    this.title,
    this.instruction,
    this.code,
    this.correctedCode,
    this.blanks = const [],
    this.options = const [],
    this.choices = const [],
    this.hint,
    this.explanation,
    this.gameType,
    this.correctOrder,
    this.expectedAnswer,
  });

  final LessonExerciseType type;

  final String? title;

  final String? instruction;

  final String? code;

  final String? correctedCode;

  final List<CodeCompletionBlank> blanks;

  final List<String> options;

  final List<ExerciseChoice> choices;

  final String? hint;

  final String? explanation;

  final GameType? gameType;

  final List<int>? correctOrder;

  final String? expectedAnswer;

  LessonExercise copyWith({
    LessonExerciseType? type,
    String? title,
    String? instruction,
    String? code,
    String? correctedCode,
    List<CodeCompletionBlank>? blanks,
    List<String>? options,
    List<ExerciseChoice>? choices,
    String? hint,
    String? explanation,
    GameType? gameType,
    List<int>? correctOrder,
    String? expectedAnswer,
  }) {
    return LessonExercise(
      type: type ?? this.type,
      title: title ?? this.title,
      instruction: instruction ?? this.instruction,
      code: code ?? this.code,
      correctedCode: correctedCode ?? this.correctedCode,
      blanks: blanks ?? this.blanks,
      options: options ?? this.options,
      choices: choices ?? this.choices,
      hint: hint ?? this.hint,
      explanation: explanation ?? this.explanation,
      gameType: gameType ?? this.gameType,
      correctOrder: correctOrder ?? this.correctOrder,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
    );
  }
}
