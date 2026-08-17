import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../application/learning_progress_controller.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/course_lesson.dart';
import '../widgets/course_identity_header.dart';
import '../widgets/course_outline_tile.dart';

/// The single Course Detail experience for every entry point.
///
/// Home, Explore, Progress, Category and Notifications all resolve to this page
/// through a stable course id. It leads with the identity header, then the long
/// description, structured learning outcomes and the lesson outline, and ends
/// with a sticky action bar offering save and start/continue. Save state is
/// local only. Course state is live — the outline, the progress bar and the
/// action reflect [LearningProgressController] so completing lessons upstream
/// (or in the Lesson Player) is visible the moment the page rebuilds.
class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key, required this.courseId});

  /// Stable id of the course to display (see [CourseIdentifier]).
  final String courseId;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final LearningProgressController _progress =
      LearningProgressController.instance;

  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _progress,
      builder: (context, _) {
        final course = _progress.liveCourse(widget.courseId);
        final isCompleted = _progress.isCompleted(widget.courseId);

        return Scaffold(
          backgroundColor: context.appColors.background,
          appBar: const AppAppBar(title: 'Detail Course'),
          body: course == null
              ? const _NotFound()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.md,
                          bottom: AppSpacing.xl,
                        ),
                        child: ResponsiveContainer(
                          maxWidth: 720,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsivePadding.horizontal(context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CourseIdentityHeader(course: course),
                              const SizedBox(height: AppSpacing.lg),
                              _DescriptionSection(course: course),
                              const SizedBox(height: AppSpacing.lg),
                              _LearningOutcomesSection(course: course),
                              const SizedBox(height: AppSpacing.lg),
                              _OutlineSection(
                                course: course,
                                onLessonTap: (lesson) =>
                                    _openLesson(course, lesson),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _ActionBar(
                      saved: _saved,
                      isEnrolled: course.isEnrolled,
                      isCompleted: isCompleted,
                      onSave: () => _toggleSaved(),
                      onStart: () => _startCourse(course),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _toggleSaved() {
    setState(() => _saved = !_saved);
    AppToast.show(
      context,
      title: _saved ? 'Course Disimpan' : 'Dihapus dari Simpanan',
      message: _saved
          ? 'Course tersimpan untuk dipelajari nanti.'
          : 'Course dihapus dari daftar simpanan.',
      severity: _saved
          ? AppFeedbackSeverity.success
          : AppFeedbackSeverity.neutral,
    );
  }

  void _startCourse(CourseDetail course) {
    if (_progress.isCompleted(course.id)) {
      Navigator.of(context).pushNamed(
        AppRoutes.resolve(AppRoutes.courseCompleted, {'courseId': course.id}),
      );
      return;
    }

    if (!course.isEnrolled) {
      _progress.beginCourse(course.id);
    }

    final lessonId = _progress.currentLessonId(course.id);
    if (lessonId == null) return;

    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.lessonDetail, {
        'courseId': course.id,
        'lessonId': lessonId,
      }),
    );
  }

  void _openLesson(CourseDetail course, CourseLesson lesson) {
    if (lesson.state == CourseLessonState.locked) {
      AppToast.show(
        context,
        title: 'Belum Terbuka',
        message: 'Selesaikan pelajaran sebelumnya untuk membukanya.',
        severity: AppFeedbackSeverity.neutral,
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.lessonDetail, {
        'courseId': course.id,
        'lessonId': lesson.id,
      }),
    );
  }
}

/// Long description block.
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.course});

  final CourseDetail course;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Tentang Course Ini',
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppBaseCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          elevation: AppElevation.flat,
          radius: AppRadius.large,
          borderSide: BorderSide(color: ext.border),
          child: Text(
            course.description,
            style: AppTypeScale.bodyMedium.copyWith(
              color: ext.textPrimary,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

/// Structured list of learning outcomes.
class _LearningOutcomesSection extends StatelessWidget {
  const _LearningOutcomesSection({required this.course});

  final CourseDetail course;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionHeader(
          title: 'Yang Akan Kamu Pelajari',
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppBaseCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          elevation: AppElevation.flat,
          radius: AppRadius.large,
          borderSide: BorderSide(color: ext.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < course.learningOutcomes.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: ext.successContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: AppIconSizes.xs,
                        color: ext.onSuccessContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        course.learningOutcomes[i],
                        style: AppTypeScale.bodyMedium.copyWith(
                          color: ext.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Structured, tappable course outline.
class _OutlineSection extends StatelessWidget {
  const _OutlineSection({required this.course, this.onLessonTap});

  final CourseDetail course;

  /// Opens a lesson in the Lesson Player.
  final ValueChanged<CourseLesson>? onLessonTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title: 'Materi Course',
          subtitle: '${course.lessonCount} pelajaran',
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppBaseCard(
          padding: EdgeInsets.zero,
          elevation: AppElevation.flat,
          radius: AppRadius.large,
          borderSide: BorderSide(color: ext.border),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < course.lessons.length; i++)
                CourseOutlineTile(
                  number: i + 1,
                  lesson: course.lessons[i],
                  isLast: i == course.lessons.length - 1,
                  onTap: onLessonTap == null
                      ? null
                      : () => onLessonTap!(course.lessons[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sticky save + start/continue action bar.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.saved,
    required this.isEnrolled,
    required this.isCompleted,
    required this.onSave,
    required this.onStart,
  });

  final bool saved;
  final bool isEnrolled;
  final bool isCompleted;
  final VoidCallback onSave;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final label = isCompleted
        ? 'Lihat Course'
        : isEnrolled
        ? 'Lanjutkan Course'
        : 'Mulai Course';

    return Material(
      color: ext.card,
      elevation: AppElevation.md,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: ResponsiveContainer(
            maxWidth: 720,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.horizontal(context),
            ),
            child: Row(
              children: [
                AppIconButton(
                  icon: saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  tooltip: saved ? 'Hapus dari Simpanan' : 'Simpan Course',
                  color: saved
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                  backgroundColor: saved ? scheme.primaryContainer : null,
                  onPressed: onSave,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    label: label,
                    isFullWidth: true,
                    onPressed: onStart,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when the resolved course does not exist in the catalog.
class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'Course Tidak Ditemukan',
        message: 'Course ini belum tersedia. Coba pilih course lain.',
        actionLabel: 'Kembali',
        onAction: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
