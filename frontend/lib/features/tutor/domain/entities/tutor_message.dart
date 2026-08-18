//**
// frontend/features/tutor/domain/entities/tutor_message.dart
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

enum TutorMessageRole { assistant, learner }

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

  final String? stageTitle;
}

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

  final String? code;

  final String? codeLabel;
}
