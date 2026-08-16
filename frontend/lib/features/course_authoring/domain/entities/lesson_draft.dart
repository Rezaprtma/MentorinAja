/// An authored lesson inside a course draft.
library;

import 'exercise_draft.dart';
import 'game_draft.dart';
import 'material_block_draft.dart';

class LessonDraft {
  const LessonDraft({
    required this.id,
    required this.title,
    required this.description,
    this.objective,
    this.estimatedMinutes = 10,
    this.order = 0,
    this.materialBlocks = const [],
    this.games = const [],
    this.exercises = const [],
  });

  final String id;
  final String title;
  final String description;
  final String? objective;
  final int estimatedMinutes;
  final int order;
  final List<MaterialBlockDraft> materialBlocks;
  final List<GameDraft> games;
  final List<ExerciseDraft> exercises;

  LessonDraft copyWith({
    String? id,
    String? title,
    String? description,
    String? objective,
    int? estimatedMinutes,
    int? order,
    List<MaterialBlockDraft>? materialBlocks,
    List<GameDraft>? games,
    List<ExerciseDraft>? exercises,
  }) {
    return LessonDraft(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      objective: objective ?? this.objective,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      order: order ?? this.order,
      materialBlocks: materialBlocks ?? this.materialBlocks,
      games: games ?? this.games,
      exercises: exercises ?? this.exercises,
    );
  }
}
