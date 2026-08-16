/// Interactive exercise model for the Lesson Player.
///
/// A lesson body mixes prose blocks with hands-on exercises. Each exercise
/// carries its own prompt, code surface, options and feedback copy, so the
/// player renders it without knowing how the exercise is solved.
library;

/// Kind of an interactive lesson exercise.
enum LessonExerciseType {
  /// Fill the blanks of an incomplete code snippet with the right tokens.
  codeCompletion,

  /// Spot and fix an error in a buggy code snippet.
  codeCorrection,

  /// Explain what a line or block of code does.
  codeExplanation,
}

/// One fill-in-the-blank inside a [LessonExerciseType.codeCompletion] exercise.
class CodeCompletionBlank {
  const CodeCompletionBlank({required this.token, this.accept = const []});

  /// The exact token that fills this blank.
  final String token;

  /// Optional alternates accepted as correct.
  final List<String> accept;
}

/// One selectable answer in a correction or explanation exercise.
class ExerciseChoice {
  const ExerciseChoice({required this.label, required this.isCorrect});

  /// Human-readable answer text shown on the option.
  final String label;

  /// Whether choosing this answer solves the exercise.
  final bool isCorrect;
}

/// A structured exercise block inside a lesson.
///
/// Fields are typed by [type]; exercises are created with the fields their
/// kind needs and ignore the rest. A future backend returns the same shape.
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
  });

  final LessonExerciseType type;

  /// Short prompt that leads the exercise.
  final String? title;

  /// One sentence telling the learner what to do.
  final String? instruction;

  /// The code surface: incomplete for completion, buggy for correction, or
  /// the line under question for explanation.
  final String? code;

  /// The fixed snippet revealed after a correct correction answer.
  final String? correctedCode;

  /// Ordered blanks for [LessonExerciseType.codeCompletion].
  final List<CodeCompletionBlank> blanks;

  /// Pool of tokens the learner can place into blanks.
  final List<String> options;

  /// Answer options for [LessonExerciseType.codeCorrection] and
  /// [LessonExerciseType.codeExplanation].
  final List<ExerciseChoice> choices;

  /// Friendly nudge shown on request after a wrong answer.
  final String? hint;

  /// Why the correct answer is correct.
  final String? explanation;
}
