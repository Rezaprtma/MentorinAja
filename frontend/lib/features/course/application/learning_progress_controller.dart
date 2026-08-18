//**
// frontend/features/course/application/learning_progress_controller.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'package:flutter/foundation.dart';

import '../data/mock_course_repository.dart';
import '../data/mock_progress_repository.dart';
import '../domain/entities/course_detail.dart';
import '../domain/entities/course_lesson.dart';
import '../domain/entities/course_progress.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/repositories/progress_repository.dart';

class LearningProgressController extends ChangeNotifier {
  LearningProgressController({
    ProgressRepository? repository,
    CourseRepository? courses,
  }) : _repository = repository ?? MockProgressRepository(),
       _courses = courses ?? MockCourseRepository();

  static final LearningProgressController instance =
      LearningProgressController();

  final ProgressRepository _repository;
  final CourseRepository _courses;

  CourseProgress? progressFor(String courseId) =>
      _repository.progressFor(courseId);

  bool isCompleted(String courseId) =>
      _repository.progressFor(courseId)?.isCompleted ?? false;

  String? currentLessonId(String courseId) =>
      _repository.currentLessonId(courseId);

  void beginCourse(String courseId) => _repository.startCourse(courseId);

  void completeLesson(String courseId, String lessonId) {
    _repository.completeLesson(courseId, lessonId);
    notifyListeners();
  }

  void resetAll() {
    _repository.resetAll();
    notifyListeners();
  }

  List<CourseLesson> lessonStates(String courseId) {
    final course = _courses.findById(courseId);
    if (course == null) return const [];

    final completed = _repository.completedLessonIds(courseId);
    final currentId = _repository.currentLessonId(courseId);
    final currentIndex = course.lessons.indexWhere(
      (lesson) => lesson.id == currentId,
    );

    return [
      for (var i = 0; i < course.lessons.length; i++)
        CourseLesson(
          id: course.lessons[i].id,
          title: course.lessons[i].title,
          durationMinutes: course.lessons[i].durationMinutes,
          summary: course.lessons[i].summary,
          state: completed.contains(course.lessons[i].id)
              ? CourseLessonState.completed
              : course.lessons[i].id == currentId
              ? CourseLessonState.current
              : currentIndex >= 0 && i > currentIndex
              ? CourseLessonState.locked
              : CourseLessonState.available,
        ),
    ];
  }

  CourseDetail? liveCourse(String courseId) {
    final course = _courses.findById(courseId);
    if (course == null) return null;
    return course.copyWith(
      progress: progressFor(courseId)?.progress,
      lessons: lessonStates(courseId),
    );
  }
}
