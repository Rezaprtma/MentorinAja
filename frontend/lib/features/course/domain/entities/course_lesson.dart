/// A single lesson inside a course, with its learning state.
///
/// The lesson state is a mock snapshot of a learning engine that does not exist
/// yet; when a real enrollment backend arrives this state becomes the source of
/// truth and the entity keeps its shape.
library;

/// Progress state of a lesson in the course outline.
enum CourseLessonState {
  /// The learner has not reached this lesson yet.
  locked,

  /// The learner may study this lesson.
  available,

  /// The lesson is finished.
  completed,

  /// The lesson the learner is currently studying next.
  current,
}

/// One entry of the course content outline.
class CourseLesson {
  const CourseLesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.summary,
    this.state = CourseLessonState.available,
  });

  /// Stable lesson identifier within the course.
  final String id;

  /// Human-readable lesson title.
  final String title;

  /// Estimated study time in minutes.
  final int durationMinutes;

  /// Optional one-line description of what the lesson covers.
  final String? summary;

  /// Learning state used to render the outline affordances.
  final CourseLessonState state;
}
