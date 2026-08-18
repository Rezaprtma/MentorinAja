//**
// frontend/features/progress/presentation/widgets/filtered_course_list.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_progress_data.dart';
import 'active_course_card.dart';
import 'completed_course_card.dart';
import 'progress_category_switch.dart';
import 'progress_empty_state.dart';

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

  final ProgressCategory category;

  final List<MockProgressCourse> activeCourses;

  final List<MockProgressCourse> completedCourses;

  final ValueChanged<MockProgressCourse>? onCourseTap;

  final ValueChanged<MockProgressCourse>? onContinue;

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
