//**
// frontend/features/course/domain/entities/course_lesson.dart
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

enum CourseLessonState { locked, available, completed, current }

class CourseLesson {
  const CourseLesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.summary,
    this.state = CourseLessonState.available,
    this.materialPdfPath,
  });

  final String id;

  final String title;

  final int durationMinutes;

  final String? summary;

  final CourseLessonState state;

  final String? materialPdfPath;
}
