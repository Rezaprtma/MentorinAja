import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/tech/tech_logo.dart';
import 'package:frontend/shared/widgets/widgets.dart';

/// Celebratory landing shown when the last lesson of a course is finished.
///
/// Reads the live progress record to confirm the course reached 100 percent,
/// summarizes the finished work and offers two exits: back to the course
/// outline or all the way home. The success tint is the only semantic accent,
/// keeping the completion moment warm without extra decoration.
class CourseCompletedPage extends StatelessWidget {
  const CourseCompletedPage({super.key, required this.courseId});

  /// Stable course identifier (see [CourseIdentifier]).
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return ListenableBuilder(
      listenable: LearningProgressController.instance,
      builder: (context, _) {
        final course = LearningProgressController.instance.liveCourse(courseId);
        if (course == null) {
          return Scaffold(
            backgroundColor: ext.background,
            appBar: const AppAppBar(title: 'Course Selesai'),
            body: Center(
              child: AppEmptyState(
                icon: Icons.search_off_rounded,
                title: 'Course Tidak Ditemukan',
                message: 'Course ini belum tersedia. Coba pilih course lain.',
                actionLabel: 'Kembali',
                onAction: () => Navigator.of(context).maybePop(),
              ),
            ),
          );
        }

        final progress = LearningProgressController.instance.progressFor(
          courseId,
        );
        final percent = ((progress?.progress ?? 1) * 100).round();

        return Scaffold(
          backgroundColor: ext.background,
          appBar: const AppAppBar(title: 'Course Selesai'),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xl,
              ),
              child: ResponsiveContainer(
                maxWidth: 480,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsivePadding.horizontal(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CompletionSeal(isCompleted: progress?.isCompleted ?? true),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Selamat, Course Selesai!',
                      textAlign: TextAlign.center,
                      style: AppTypeScale.headlineSmall.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Kamu telah menyelesaikan "${course.title}" hingga '
                      'tuntas. Pertahankan semangat belajarmu!',
                      textAlign: TextAlign.center,
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SummaryCard(
                      course: course,
                      percent: percent,
                      isCompleted: progress?.isCompleted ?? true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Lihat Course',
                      isFullWidth: true,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: 'Kembali ke Home',
                      variant: AppButtonVariant.outlined,
                      isFullWidth: true,
                      onPressed: () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Success seal — a check inside a soft success circle.
class _CompletionSeal extends StatelessWidget {
  const _CompletionSeal({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final color = isCompleted ? ext.success : ext.textDisabled;

    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: isCompleted
              ? ext.successContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isCompleted
              ? Icons.check_circle_rounded
              : Icons.emoji_events_outlined,
          size: 56,
          color: color,
        ),
      ),
    );
  }
}

/// Course summary: identity, full progress bar and lesson count.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.course,
    required this.percent,
    required this.isCompleted,
  });

  final CourseDetail course;
  final int percent;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TechLogo(
                assetPath: course.iconPath,
                background: course.brand.background,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: AppTypeScale.titleSmall.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${course.lessonCount} pelajaran',
                      style: AppTypeScale.bodySmall.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$percent%',
                style: AppTypeScale.titleMedium.copyWith(
                  color: isCompleted ? ext.success : scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppLinearLoader(
            value: isCompleted ? 1 : (percent / 100),
            minHeight: AppSpacing.xs,
            color: isCompleted ? ext.success : scheme.primary,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
