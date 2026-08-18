//**
// frontend/features/course/domain/entities/course_progress.dart
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
class CourseProgress {
  const CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    this.currentLessonId,
  });

  final String courseId;

  final int completedLessons;

  final int totalLessons;

  final double progress;

  final String? currentLessonId;

  bool get isCompleted => completedLessons >= totalLessons && totalLessons > 0;
}
