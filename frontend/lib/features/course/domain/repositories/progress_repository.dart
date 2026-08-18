//**
// frontend/features/course/domain/repositories/progress_repository.dart
//
// frontend:
// Repository interface. Mendefinisikan kontrak data untuk feature.
//
// backend:
// Future: akan diimplementasikan dengan real backend calls.
//
// api:
// Future: akan menjadi integration point untuk backend APIs.
//
// qa:
// QA perlu memvalidasi data flow dan error handling.
//**
import '../entities/course_progress.dart';

abstract class ProgressRepository {
  CourseProgress? progressFor(String courseId);

  Set<String> completedLessonIds(String courseId);

  String? currentLessonId(String courseId);

  void startCourse(String courseId);

  void completeLesson(String courseId, String lessonId);

  void resetAll();
}
