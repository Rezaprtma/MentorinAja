/// Content block models for the Lesson Player.
library;

import 'package:frontend/shared/enums/enums.dart';

import 'lesson_exercise.dart';

export 'package:frontend/shared/enums/enums.dart' show LessonContentBlockType;

/// One renderable block inside a lesson.
///
/// A block is a plain-text payload typed by [type]; the player maps each kind
/// onto the matching design-system surface. [heading] labels the phase the
/// block belongs to (e.g. "LIHAT CONTOH"), while [exercise] carries the full
/// interactive exercise for [LessonContentBlockType.exercise]. Mock content is
/// generated locally — a future backend returns structured lesson bodies in
/// the same shape.
class LessonContentBlock {
  const LessonContentBlock({
    required this.type,
    this.text,
    this.label,
    this.items = const [],
    this.heading,
    this.exercise,
  });

  final LessonContentBlockType type;

  /// Body text for paragraphs, code and tips.
  final String? text;

  /// Optional caption for a code block (e.g. a language tag).
  final String? label;

  /// Items for a bullet list.
  final List<String> items;

  /// Optional phase label rendered as an eyebrow above the block.
  final String? heading;

  /// Interactive payload for [LessonContentBlockType.exercise].
  final LessonExercise? exercise;
}
