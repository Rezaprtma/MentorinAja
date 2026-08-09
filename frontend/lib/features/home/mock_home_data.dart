import 'package:flutter/material.dart';

/// Accent role for a single learning-stat tile.
enum LearningAccent {
  /// Brand primary accent (streak and highlights).
  primary,

  /// Secondary brand accent.
  secondary,

  /// Neutral, muted accent.
  neutral,
}

/// One compact metric shown in the learning-stats strip.
class LearningStat {
  const LearningStat({
    required this.value,
    required this.label,
    required this.icon,
    this.accent = LearningAccent.neutral,
  });

  final String value;
  final String label;
  final IconData icon;
  final LearningAccent accent;
}

/// Recommended course preview shown on the Home screen.
class MockCourse {
  const MockCourse({
    required this.title,
    required this.category,
    required this.lessonCount,
    required this.icon,
  });

  final String title;
  final String category;
  final int lessonCount;
  final IconData icon;
}

/// Temporary local data powering the Home screen.
///
/// These values are mock data used only for UI development. They are replaced
/// by authentication, catalog and progress endpoints in a later phase, so
/// screens must never branch on this module's specifics.
abstract final class MockHomeData {
  /// Mock learner identity shown in the greeting.
  static const String displayName = 'Rina';

  /// In-progress course shown in the "Continue learning" card.
  static const String courseTitle = 'Python Fundamentals';

  /// Current lesson summary shown under the course title.
  static const String lessonLabel = 'Lesson 12 of 20 • Functions';

  /// Normalized course completion in the range 0.0–1.0.
  static const double courseProgress = 0.72;

  /// Weekly learning metrics rendered in the stats strip.
  static const List<LearningStat> learningStats = [
    LearningStat(
      value: '7',
      label: 'day streak',
      icon: Icons.local_fire_department,
      accent: LearningAccent.primary,
    ),
    LearningStat(
      value: '3',
      label: 'lessons this week',
      icon: Icons.menu_book_outlined,
      accent: LearningAccent.secondary,
    ),
    LearningStat(
      value: '4h 20m',
      label: 'learning this week',
      icon: Icons.schedule_outlined,
    ),
  ];

  /// Courses surfaced in the "Recommended for you" feed.
  static const List<MockCourse> recommendedCourses = [
    MockCourse(
      title: 'Public Speaking for Beginners',
      category: 'Communication',
      lessonCount: 12,
      icon: Icons.record_voice_over_outlined,
    ),
    MockCourse(
      title: 'Statistics for Data Science',
      category: 'Data',
      lessonCount: 18,
      icon: Icons.insights_outlined,
    ),
    MockCourse(
      title: 'Product Thinking 101',
      category: 'Career',
      lessonCount: 10,
      icon: Icons.lightbulb_outline,
    ),
  ];
}
