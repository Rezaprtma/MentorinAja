/// An authored exercise block inside a lesson draft.
library;

import 'package:frontend/features/lesson/domain/entities/lesson_exercise.dart';

import 'blank_draft.dart';
import 'game_choice_draft.dart';

class ExerciseDraft {
  const ExerciseDraft({
    required this.id,
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
    this.order = 0,
  });

  final String id;
  final LessonExerciseType type;
  final String? title;
  final String? instruction;
  final String? code;
  final String? correctedCode;
  final List<BlankDraft> blanks;
  final List<String> options;
  final List<GameChoiceDraft> choices;
  final String? hint;
  final String? explanation;
  final int order;

  ExerciseDraft copyWith({
    String? id,
    LessonExerciseType? type,
    String? title,
    String? instruction,
    String? code,
    String? correctedCode,
    List<BlankDraft>? blanks,
    List<String>? options,
    List<GameChoiceDraft>? choices,
    String? hint,
    String? explanation,
    int? order,
  }) {
    return ExerciseDraft(
      id: id ?? this.id,
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
      order: order ?? this.order,
    );
  }
}
