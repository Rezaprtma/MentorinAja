import 'package:flutter/foundation.dart';

import '../data/mock_course_repository.dart';
import '../data/mock_progress_repository.dart';
import '../domain/entities/course_detail.dart';
import '../domain/entities/course_lesson.dart';
import '../domain/entities/course_progress.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/repositories/progress_repository.dart';

/// Application-level access point for live course progress.
///
/// Owns the [ProgressRepository] seam and the course catalog, deriving lesson
/// states and next-step conveniences for the Lesson Player, Course Detail and
/// Progress surfaces. Mirrors the notification feature's controller pattern:
/// a singleton that notifies listeners after every mutation so any screen can
/// rebuild from the same source of truth.
class LearningProgressController extends ChangeNotifier {
  LearningProgressController({
    ProgressRepository? repository,
    CourseRepository? courses,
  }) : _repository = repository ?? MockProgressRepository(),
       _courses = courses ?? MockCourseRepository();

  /// Shared instance used by every screen and the lesson player.
  static final LearningProgressController instance =
      LearningProgressController();

  final ProgressRepository _repository;
  final CourseRepository _courses;

  /// Live progress record for [courseId]; null when not started.
  CourseProgress? progressFor(String courseId) =>
      _repository.progressFor(courseId);

  /// Whether [courseId] has been finished.
  bool isCompleted(String courseId) =>
      _repository.progressFor(courseId)?.isCompleted ?? false;

  /// The next lesson to study for [courseId]; null when finished or unstarted.
  String? currentLessonId(String courseId) =>
      _repository.currentLessonId(courseId);

  /// Marks [courseId] as started and queues its first lesson.
  void beginCourse(String courseId) => _repository.startCourse(courseId);

  /// Marks [lessonId] finished and advances the course.
  void completeLesson(String courseId, String lessonId) {
    _repository.completeLesson(courseId, lessonId);
    notifyListeners();
  }

  /// Clears all stored progress (used by previews and tests).
  void resetAll() {
    _repository.resetAll();
    notifyListeners();
  }

  /// The course outline with states computed from live progress.
  ///
  /// Completed lessons keep their success mark, the queued lesson becomes
  /// "current", and everything after it is locked until reached.
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

  /// The catalog course enriched with live [progress] and lesson states.
  ///
  /// Surfaces that render [CourseDetail] directly (identity header, outline)
  /// use this instead of the immutable catalog record.
  CourseDetail? liveCourse(String courseId) {
    final course = _courses.findById(courseId);
    if (course == null) return null;
    return course.copyWith(
      progress: progressFor(courseId)?.progress,
      lessons: lessonStates(courseId),
    );
  }
}
