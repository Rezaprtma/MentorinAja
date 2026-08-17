/// Domain models for the contextual AI Tutor panel.
library;

/// Speaker role in the tutor conversation.
enum TutorMessageRole { assistant, learner }

/// Lesson context passed to the future AI backend seam.
class TutorLessonContext {
  const TutorLessonContext({
    required this.courseId,
    required this.courseTitle,
    required this.lessonId,
    required this.lessonTitle,
    this.stageTitle,
  });

  final String courseId;
  final String courseTitle;
  final String lessonId;
  final String lessonTitle;

  /// Friendly name of the active lesson stage, e.g. "tantangan Game".
  final String? stageTitle;
}

/// One chat message in the local AI Tutor UI.
class TutorMessage {
  const TutorMessage({
    required this.role,
    required this.text,
    required this.createdAt,
    this.code,
    this.codeLabel,
  });

  final TutorMessageRole role;
  final String text;
  final DateTime createdAt;

  /// Optional code snippet rendered in a code block below the message.
  final String? code;

  /// Optional language label for [code].
  final String? codeLabel;
}
