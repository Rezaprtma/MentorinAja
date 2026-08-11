import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_home_data.dart';
import 'horizontal_course_rail.dart';
import 'recommended_course_card.dart';

/// Recommended-courses block on the Home screen.
///
/// Sits below the resume card so discovery content stays lower in the visual
/// hierarchy. Renders a "Untuk Kamu" header with a "Lihat Semua" action above a
/// horizontally scrolling rail whose cards peek the next item.
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key, this.onSeeAll, this.onCourseTap});

  /// Opens the full catalog surface.
  final VoidCallback? onSeeAll;

  /// Opens a specific course; receives its mock title.
  final ValueChanged<String>? onCourseTap;

  /// Uniform height kept for every card in the rail.
  static const double _cardHeight = 216;

  @override
  Widget build(BuildContext context) {
    final courses = MockHomeData.recommendedCourses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title: 'Untuk Kamu',
          trailing: TextButton(
            onPressed: onSeeAll,
            child: const Text('Lihat Semua'),
          ),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (courses.isEmpty)
          AppEmptyState(
            compact: true,
            icon: Icons.rocket_launch_outlined,
            title: 'Mulai Perjalanan Belajarmu',
            message: 'Pilih kursus dan mulailah berkembang.',
            actionLabel: 'Jelajahi Kursus',
            onAction: onSeeAll,
          )
        else
          HorizontalCourseRail(
            cardHeight: _cardHeight,
            itemCount: courses.length,
            itemBuilder: (context, index) => RecommendedCourseCard(
              course: courses[index],
              onTap: onCourseTap == null
                  ? null
                  : () => onCourseTap!(courses[index].title),
            ),
          ),
      ],
    );
  }
}
