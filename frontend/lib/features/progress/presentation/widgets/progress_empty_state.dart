import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import 'progress_category_switch.dart';

/// Empty state for a [ProgressCategory] with no courses.
///
/// Orients the learner with a clear next step per category: studying courses
/// fall back to browsing Explore, while completed courses are a quiet note
/// that finished work surfaces here. Reuses [AppEmptyState].
class ProgressEmptyState extends StatelessWidget {
  const ProgressEmptyState({
    super.key,
    this.category = ProgressCategory.studying,
    this.onExplore,
  });

  /// Which category has no courses.
  final ProgressCategory category;

  /// Switches to the Explore tab to pick a first course.
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return switch (category) {
      ProgressCategory.studying => AppEmptyState(
        icon: Icons.school_outlined,
        title: 'Belum Ada Course',
        message: 'Mulai belajar dengan memilih course dari Explore.',
        actionLabel: 'Jelajahi Course',
        onAction: onExplore,
      ),
      ProgressCategory.completed => const AppEmptyState(
        icon: Icons.task_alt_outlined,
        title: 'Belum Ada Course Selesai',
        message: 'Course yang kamu selesaikan akan muncul di sini.',
      ),
    };
  }
}
