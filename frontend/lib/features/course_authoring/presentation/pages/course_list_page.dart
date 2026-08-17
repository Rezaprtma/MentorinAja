/// Mentor course list — the landing screen of the authoring flow.
///
/// Fetches authored drafts from [CourseAuthoringRepository] and renders them
/// as tappable cards showing title, lesson count and publication status. A
/// prominent CTA opens the course creation form. Empty state invites the
/// mentor to build the first course.
library;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/draft_status.dart';
import '../../domain/repositories/course_authoring_repository.dart';
import '../widgets/course_draft_card.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key, this.repository, this.onOpenCourse});

  /// Injected for tests; defaults to the shared in-memory mock repository.
  final CourseAuthoringRepository? repository;

  /// Overrides navigation to the editor (used by tests).
  final void Function(String courseId)? onOpenCourse;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? MockCourseAuthoringRepository.instance;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: const AppAppBar(title: 'Kelola Course'),
      floatingActionButton: AppFloatingActionButton.extended(
        icon: Icons.add,
        label: 'Buat Course',
        onPressed: () => _openCreate(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: AppSpacing.xxxl,
        ),
        children: [
          ResponsiveContainer(
            maxWidth: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppPageHeader(
                  title: 'Course Kamu',
                  subtitle:
                      'Buat, susun, dan publikasikan course untuk para pelajar.',
                ),
                const SizedBox(height: AppSpacing.sm),
                if (repo.allDrafts().isEmpty)
                  const AppEmptyState(
                    icon: Icons.school_outlined,
                    title: 'Belum Ada Course',
                    message:
                        'Mulai course pertamamu dengan menekan tombol Buat '
                        'Course.',
                  )
                else
                  for (final draft in repo.allDrafts()) ...[
                    CourseDraftCard(
                      draft: draft,
                      onTap: () => _openCourse(context, draft.id),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCourse(BuildContext context, String courseId) {
    if (onOpenCourse != null) {
      onOpenCourse!(courseId);
      return;
    }
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.mentorCourseEditor, {'courseId': courseId}),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.mentorCourseCreate);
  }
}

/// Determines the status label and badge variant for a course draft.
extension CourseDraftStatusUi on DraftStatus {
  String get label => switch (this) {
    DraftStatus.draft => 'Draft',
    DraftStatus.published => 'Published',
  };

  AppBadgeVariant get badge => switch (this) {
    DraftStatus.draft => AppBadgeVariant.neutral,
    DraftStatus.published => AppBadgeVariant.success,
  };
}

/// Formats a draft's last-updated time as a short Indonesian label.
String draftUpdatedLabel(DateTime updatedAt) {
  final now = DateTime.now();
  final difference = now.difference(updatedAt);
  if (difference.inMinutes < 1) return 'Baru saja diperbarui';
  if (difference.inHours < 1) {
    return 'Diperbarui ${difference.inMinutes} menit lalu';
  }
  if (difference.inDays < 1) {
    return 'Diperbarui ${difference.inHours} jam lalu';
  }
  if (difference.inDays < 7) {
    return 'Diperbarui ${difference.inDays} hari lalu';
  }
  final month = switch (updatedAt.month) {
    1 => 'Januari',
    2 => 'Februari',
    3 => 'Maret',
    4 => 'April',
    5 => 'Mei',
    6 => 'Juni',
    7 => 'Juli',
    8 => 'Agustus',
    9 => 'September',
    10 => 'Oktober',
    11 => 'November',
    _ => 'Desember',
  };
  return 'Diperbarui ${updatedAt.day} $month ${updatedAt.year}';
}
