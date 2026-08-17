/// Live learning progress for a single course.
///
/// Represents the enrollment state of one course as seen by the lesson player,
/// the Course Detail page and the Progress tab. [progress] is the normalized
/// completion computed from finished lessons; a real backend would replace the
/// mock store with the same shape.
class CourseProgress {
  const CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    this.currentLessonId,
  });

  /// Stable course identifier (see [CourseIdentifier]).
  final String courseId;

  /// Lessons finished so far.
  final int completedLessons;

  /// Total lessons in the course outline.
  final int totalLessons;

  /// Normalized completion in the range 0.0–1.0.
  final double progress;

  /// The lesson queued to study next; null when the course is finished.
  final String? currentLessonId;

  /// Whether every lesson has been finished.
  bool get isCompleted => completedLessons >= totalLessons && totalLessons > 0;
}
