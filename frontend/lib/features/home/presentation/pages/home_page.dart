import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/models/course_identifier.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_home_data.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/hero_banner_carousel.dart';
import '../widgets/home_header.dart';
import '../widgets/recommended_section.dart';

/// Home screen root — a calm, scrollable learning backdrop.
///
/// Composes the greeting header, a swipeable flat-brand hero carousel carrying
/// today's streak, the dominant "Progres Saya" resume card and a horizontally
/// scrollable programming recommendation rail into one vertical scroll. The
/// page ends after the rail; nothing decorative is added below it. All values
/// come from [MockHomeData]; the layout constrains itself with
/// [ResponsiveContainer] so tablet line lengths stay readable.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onExplore});

  /// Switches the shell to the Explore tab (used by "Lihat Semua" targets).
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
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
                  HomeHeader(
                    displayName: MockHomeData.displayName,
                    onNotificationsPressed: () => _openNotifications(context),
                  ),
                  const AppGap.v(AppSpacing.lg),
                  HeroBannerCarousel(
                    banners: MockHomeData.homeBanners,
                    onCta: onExplore,
                  ),
                  const AppGap.v(AppSpacing.xl),
                  _ProgressSection(
                    onSeeAll: onExplore,
                    onOpenCourse: (id) => _openCourse(context, id),
                  ),
                  const AppGap.v(AppSpacing.xl),
                  RecommendedSection(
                    onSeeAll: onExplore,
                    onCourseTap: (title) =>
                        _openCourse(context, CourseIdentifier.slug(title)),
                  ),
                  const AppGap.v(AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.notifications);
  }

  void _openCourse(BuildContext context, String courseId) {
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.courseDetail, {'courseId': courseId}),
    );
  }
}

/// "Progres Saya" section header plus the resume card.
class _ProgressSection extends StatelessWidget {
  const _ProgressSection({this.onSeeAll, this.onOpenCourse});

  /// Opens the full catalog surface.
  final VoidCallback? onSeeAll;

  /// Opens the enrolled course on the shared detail page.
  final ValueChanged<String>? onOpenCourse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title: 'Progres Saya',
          trailing: TextButton(
            onPressed: onSeeAll,
            child: const Text('Lihat Semua'),
          ),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (MockHomeData.courseTitle.trim().isEmpty)
          AppEmptyState(
            compact: true,
            icon: Icons.rocket_launch_outlined,
            title: 'Mulai Perjalanan Belajarmu',
            message: 'Pilih kursus dan mulailah berkembang.',
            actionLabel: 'Jelajahi Kursus',
            onAction: onSeeAll,
          )
        else
          ContinueLearningCard(
            courseTitle: MockHomeData.courseTitle,
            lessonLabel: MockHomeData.lessonLabel,
            progress: MockHomeData.courseProgress,
            onContinue: () => onOpenCourse?.call(
              CourseIdentifier.slug(MockHomeData.courseTitle),
            ),
          ),
      ],
    );
  }
}
