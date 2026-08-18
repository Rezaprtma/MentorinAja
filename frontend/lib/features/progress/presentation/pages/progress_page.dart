//**
// frontend/features/progress/presentation/pages/progress_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_progress_data.dart';
import '../widgets/filtered_course_list.dart';
import '../widgets/progress_category_switch.dart';
import '../widgets/progress_header.dart';
import '../widgets/progress_stats_panel.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({
    super.key,
    this.onExplore,
    this.onCourseTap,
    this.onContinue,
  });

  final VoidCallback? onExplore;

  final ValueChanged<MockProgressCourse>? onCourseTap;

  final ValueChanged<MockProgressCourse>? onContinue;

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  ProgressCategory _category = ProgressCategory.studying;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LearningProgressController.instance,
      builder: (context, _) {
        final stats = _ProgressStats.fromLiveData(
          LearningProgressController.instance,
        );

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
      },
    );
  }
}

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

  final List<MockProgressCourse> activeCourses;

  final List<MockProgressCourse> completedCourses;

  factory _ProgressStats.fromLiveData(LearningProgressController progress) {
    final repository = MockCourseRepository();
    final items = <MockProgressCourse>[];

    for (final course in repository.all()) {
      final record = progress.progressFor(course.id);
      if (record == null || record.completedLessons == 0) continue;
      items.add(_toProgressCourse(course, record));
    }

    final active =
        items.where((c) => c.progress > 0 && c.progress < 1.0).toList()
          ..sort((a, b) => b.progress.compareTo(a.progress));
    final finished = items.where((c) => c.progress >= 1.0).toList();

    return _ProgressStats(
      total: items.length,
      active: active.length,
      completed: finished.length,
      activeCourses: active,
      completedCourses: finished,
    );
  }

  static MockProgressCourse _toProgressCourse(
    CourseDetail course,
    CourseProgress record,
  ) {
    final lessons = course.lessons;
    var currentTitle = lessons.isEmpty ? '' : lessons.last.title;
    var nextTitle = '';

    final currentId = record.currentLessonId;
    if (currentId != null) {
      final currentIndex = lessons.indexWhere((l) => l.id == currentId);
      if (currentIndex >= 0) {
        currentTitle = lessons[currentIndex].title;
        if (currentIndex + 1 < lessons.length) {
          nextTitle = lessons[currentIndex + 1].title;
        }
      }
    }

    return MockProgressCourse(
      title: course.title,
      completedLessons: record.completedLessons,
      lessonCount: course.lessonCount,
      currentLesson: currentTitle,
      nextLesson: nextTitle,
      progress: record.progress,
      iconPath: course.iconPath,
      brand: course.brand,
    );
  }
}
