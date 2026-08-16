/// Shared enums used across lesson and course-authoring features.
library;

enum LessonContentBlockType {
  paragraph,
  code,
  bulletList,
  tip,
  exercise,
  heading,
  subheading,
  numberedList,
  warning,
  example,
  summary,
  checklist,
}

enum LessonExerciseType {
  codeCompletion,
  codeCorrection,
  codeExplanation,
  codeWriting,
}

enum GameType {
  codeOrdering,
  tokenCompletion,
  multipleChoice,
  identifyError,
  outputPrediction,
}
