import '../entities/course_progress.dart';

/// Data source seam for per-course learning progress.
///
/// Screens depend on this interface so a real enrollment backend can replace
/// the in-memory mock later without touching presentation. Implementations own
/// the completed/current lesson bookkeeping for a single learner.
abstract class ProgressRepository {
  /// Live progress for [courseId]; null when the course has no record.
  CourseProgress? progressFor(String courseId);

  /// Finished lesson ids for [courseId] (empty when not started).
  Set<String> completedLessonIds(String courseId);

  /// The next lesson to study for [courseId]; null when finished or unstarted.
  String? currentLessonId(String courseId);

  /// Marks [courseId] as started, queuing its first lesson.
  void startCourse(String courseId);

  /// Marks [lessonId] finished and advances to the next open lesson.
  void completeLesson(String courseId, String lessonId);

  /// Clears every stored record (used by previews and tests).
  void resetAll();
}
