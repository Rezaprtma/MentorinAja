import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';

/// A course the learner is enrolled in, carrying study progress.
///
/// [progress] is an explicit snapshot of overall completion (lessons, quizzes
/// and reading combined), so it is kept separate from the raw lesson counter
/// that feeds the "Pelajaran X dari Y" line. This mirrors how the Home screen
/// already reports progress alongside a lesson label.
class MockProgressCourse {
  const MockProgressCourse({
    required this.title,
    required this.completedLessons,
    required this.lessonCount,
    required this.currentLesson,
    required this.nextLesson,
    required this.progress,
    required this.iconPath,
    required this.brand,
  });

  final String title;

  /// Lessons finished so far.
  final int completedLessons;

  /// Total lessons in the course.
  final int lessonCount;

  /// The last lesson the learner studied.
  final String currentLesson;

  /// The lesson queued to study next.
  final String nextLesson;

  /// Normalized completion in the range 0.0–1.0.
  final double progress;

  /// SVG asset path of the real technology logo (see [AppIconPaths]).
  final String iconPath;

  /// Technology-brand-derived card colors.
  final TechBrandColors brand;

  /// Short lesson summary, e.g. "Pelajaran 12 dari 20 • Fungsi".
  String get lessonLabel =>
      'Pelajaran $completedLessons dari $lessonCount • $currentLesson';
}

/// Temporary local data powering the Progress screen.
///
/// These values mirror the courses already used on Home and Explore so the
/// feature reads as one consistent catalog. Replaced by progress endpoints in
/// a later phase; screens must never branch on this module's specifics.
abstract final class MockProgressData {
  /// Courses currently being studied, ordered by most progress first.
  static const List<MockProgressCourse> activeCourses = [
    MockProgressCourse(
      title: 'Dasar Python',
      completedLessons: 12,
      lessonCount: 20,
      currentLesson: 'Fungsi',
      nextLesson: 'Function Parameters',
      progress: 0.72,
      iconPath: AppIconPaths.techPython,
      brand: TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockProgressCourse(
      title: 'JavaScript Modern',
      completedLessons: 8,
      lessonCount: 18,
      currentLesson: 'Array Methods',
      nextLesson: 'DOM Manipulation',
      progress: 0.45,
      iconPath: AppIconPaths.techJavascript,
      brand: TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
    ),
    MockProgressCourse(
      title: 'MySQL Dasar',
      completedLessons: 4,
      lessonCount: 16,
      currentLesson: 'Query Dasar',
      nextLesson: 'Filtering Data',
      progress: 0.28,
      iconPath: AppIconPaths.techMysql,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];

  /// Courses the learner already finished.
  static const List<MockProgressCourse> completedCourses = [
    MockProgressCourse(
      title: 'Laravel untuk Pemula',
      completedLessons: 15,
      lessonCount: 15,
      currentLesson: 'Membuat Proyek Pertama',
      nextLesson: '',
      progress: 1.0,
      iconPath: AppIconPaths.techLaravel,
      brand: TechBrandColors(
        background: Color(0xFFFCE4EC),
        accent: Color(0xFFF05340),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];
}
