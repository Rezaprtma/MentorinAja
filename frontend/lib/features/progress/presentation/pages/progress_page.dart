import 'package:flutter/material.dart';

import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_progress_data.dart';
import '../widgets/filtered_course_list.dart';
import '../widgets/progress_category_switch.dart';
import '../widgets/progress_header.dart';
import '../widgets/progress_stats_panel.dart';

/// Progress tab root — the learner's enrolled courses and their completion.
///
/// Leads with one [ProgressStatsPanel] that summarizes the whole catalog, then
/// a [ProgressCategorySwitch] that picks which [FilteredCourseList] renders.
/// Only the selected category's cards are built, so the completed list stays
/// cheap as it grows. The page scrolls and supports pull-to-refresh through the
/// shared [mockRefresh] seam. All values come from [MockProgressData]; the
/// layout constrains itself with [ResponsiveContainer] so tablet line lengths
/// stay readable.
class ProgressPage extends StatefulWidget {
  const ProgressPage({
    super.key,
    this.onExplore,
    this.onCourseTap,
    this.onContinue,
  });

  /// Switches the shell to the Explore tab (used by the empty-state CTA).
  final VoidCallback? onExplore;

  /// Opens a course, receiving the tapped [MockProgressCourse].
  final ValueChanged<MockProgressCourse>? onCourseTap;

  /// Resumes a course's next lesson.
  final ValueChanged<MockProgressCourse>? onContinue;

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  ProgressCategory _category = ProgressCategory.studying;

  @override
  Widget build(BuildContext context) {
    final stats = _ProgressStats.fromMockData();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: AppSafeArea(
        child: RefreshIndicator(
          onRefresh: mockRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxxl + AppSpacing.md,
            ),
            child: ResponsiveContainer(
              maxWidth: 720,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.horizontal(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProgressHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  ProgressStatsPanel(
                    totalCount: stats.total,
                    activeCount: stats.active,
                    completedCount: stats.completed,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ProgressCategorySwitch(
                    value: _category,
                    onChanged: (category) =>
                        setState(() => _category = category),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilteredCourseList(
                    category: _category,
                    activeCourses: stats.activeCourses,
                    completedCourses: stats.completedCourses,
                    onCourseTap: widget.onCourseTap,
                    onContinue: widget.onContinue,
                    onExplore: widget.onExplore,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Derived course statistics computed from the mock catalog.
///
/// Total counts every course, "active" means progress strictly between zero and
/// a hundred percent and "completed" means progress reached one hundred percent.
class _ProgressStats {
  const _ProgressStats({
    required this.total,
    required this.active,
    required this.completed,
    required this.activeCourses,
    required this.completedCourses,
  });

  final int total;
  final int active;
  final int completed;

  /// Active courses ordered by most progress first.
  final List<MockProgressCourse> activeCourses;

  /// Courses finished at 100 percent.
  final List<MockProgressCourse> completedCourses;

  factory _ProgressStats.fromMockData() {
    final all = [
      ...MockProgressData.activeCourses,
      ...MockProgressData.completedCourses,
    ];
    final active = all.where((c) => c.progress > 0 && c.progress < 1.0).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    final finished = all.where((c) => c.progress >= 1.0).toList();

    return _ProgressStats(
      total: all.length,
      active: active.length,
      completed: finished.length,
      activeCourses: active,
      completedCourses: finished,
    );
  }
}
