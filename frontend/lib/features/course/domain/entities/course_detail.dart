import 'package:frontend/shared/data/tech_brand_colors.dart';

import 'course_lesson.dart';

/// Full course record consumed by the Course Detail experience.
///
/// Carries identity, descriptive copy, learning outcomes and the structured
/// lesson outline. [progress] is an optional enrollment snapshot so a started
/// course can present a resume state without a backend.
class CourseDetail {
  const CourseDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.description,
    required this.learningOutcomes,
    required this.lessons,
    required this.iconPath,
    required this.brand,
    required this.rating,
    this.level,
    this.studentCount,
    this.estimatedMinutes,
    this.progress,
  });

  /// Stable slug identifying this course across entry points.
  final String id;

  final String title;

  /// Learning area, e.g. "Pemrograman".
  final String category;

  /// One-line preview used on cards.
  final String shortDescription;

  /// Longer copy covering what, who and what you will learn.
  final String description;

  /// Structured list of learning outcomes.
  final List<String> learningOutcomes;

  /// Ordered course outline.
  final List<CourseLesson> lessons;

  /// SVG asset path of the real technology logo.
  final String iconPath;

  /// Technology-brand-derived identity colors.
  final TechBrandColors brand;

  /// Learner rating shown next to the title.
  final double rating;

  /// Difficulty label, e.g. "Pemula".
  final String? level;

  /// Total enrolled learners (mock).
  final int? studentCount;

  /// Estimated total study time in minutes.
  final int? estimatedMinutes;

  /// Normalized completion 0.0–1.0 when the course has been started.
  final double? progress;

  int get lessonCount => lessons.length;

  /// Whether the learner has started this course (a progress record exists,
  /// even when no lesson is finished yet).
  bool get isEnrolled => progress != null;

  /// Copy with a live [progress] snapshot and/or a live [lessons] outline.
  ///
  /// The catalog records are immutable; the Lesson Experience enriches them
  /// with current state so every surface reads the same learner progress.
  CourseDetail copyWith({double? progress, List<CourseLesson>? lessons}) {
    return CourseDetail(
      id: id,
      title: title,
      category: category,
      shortDescription: shortDescription,
      description: description,
      learningOutcomes: learningOutcomes,
      lessons: lessons ?? this.lessons,
      iconPath: iconPath,
      brand: brand,
      rating: rating,
      level: level,
      studentCount: studentCount,
      estimatedMinutes: estimatedMinutes,
      progress: progress ?? this.progress,
    );
  }

  /// Number of lessons finished so far (used by the resume copy).
  int get completedLessonCount =>
      lessons.where((l) => l.state == CourseLessonState.completed).length;

  /// Title of the lesson queued next, when the course is in progress.
  String? get nextLessonTitle {
    if (progress == null) return null;
    for (final lesson in lessons) {
      if (lesson.state == CourseLessonState.current ||
          lesson.state == CourseLessonState.available) {
        return lesson.title;
      }
    }
    return null;
  }
}
