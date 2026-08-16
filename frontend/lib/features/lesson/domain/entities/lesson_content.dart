import 'lesson_exercise.dart';

/// Visual kind of a lesson content block.
enum LessonContentBlockType {
  /// A prose paragraph of explanation.
  paragraph,

  /// A monospaced code/example block.
  code,

  /// A bulleted list of goals or steps.
  bulletList,

  /// A highlighted tip or note.
  tip,

  /// An interactive exercise (see [LessonExercise]).
  exercise,

  /// A section heading.
  heading,

  /// A sub-section heading.
  subheading,

  /// A numbered/ordered list of steps.
  numberedList,

  /// A caution or warning callout.
  warning,

  /// A worked example illustration.
  example,

  /// A concise summary or key takeaway.
  summary,

  /// A checklist of actionable items.
  checklist,
}

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
