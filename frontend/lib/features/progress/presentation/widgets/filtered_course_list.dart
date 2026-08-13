import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_progress_data.dart';
import 'active_course_card.dart';
import 'completed_course_card.dart';
import 'progress_category_switch.dart';
import 'progress_empty_state.dart';

/// Renders exactly the courses of the selected [ProgressCategory].
///
/// Selects the source collection first and only then builds cards, so the
/// untouched category is never constructed — important as the completed list
/// grows. Each category falls back to its own [ProgressEmptyState] copy.
class FilteredCourseList extends StatelessWidget {
  const FilteredCourseList({
    super.key,
    required this.category,
    required this.activeCourses,
    required this.completedCourses,
    this.onCourseTap,
    this.onContinue,
    this.onExplore,
  });

  /// The category whose courses should be visible.
  final ProgressCategory category;

  /// Courses with progress strictly between 0 and 100 percent.
  final List<MockProgressCourse> activeCourses;

  /// Courses finished at 100 percent.
  final List<MockProgressCourse> completedCourses;

  /// Opens a course, receiving the tapped [MockProgressCourse].
  final ValueChanged<MockProgressCourse>? onCourseTap;

  /// Resumes a course's next lesson.
  final ValueChanged<MockProgressCourse>? onContinue;

  /// Switches to the Explore tab (used by the studying empty state).
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final courses = category == ProgressCategory.studying
        ? activeCourses
        : completedCourses;

    if (courses.isEmpty) {
      return ProgressEmptyState(category: category, onExplore: onExplore);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < courses.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _buildCard(courses[i]),
        ],
      ],
    );
  }

  Widget _buildCard(MockProgressCourse course) {
    if (category == ProgressCategory.studying) {
      return ActiveCourseCard(
        course: course,
        onTap: onCourseTap == null ? null : () => onCourseTap!(course),
        onContinue: onContinue == null ? null : () => onContinue!(course),
      );
    }
    return CompletedCourseCard(
      course: course,
      onTap: onCourseTap == null ? null : () => onCourseTap!(course),
    );
  }
}
