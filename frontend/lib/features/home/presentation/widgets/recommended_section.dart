//**
// frontend/features/home/presentation/widgets/recommended_section.dart
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

import '../../mock_home_data.dart';
import 'horizontal_course_rail.dart';
import 'recommended_course_card.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key, this.onSeeAll, this.onCourseTap});

  final VoidCallback? onSeeAll;

  final ValueChanged<String>? onCourseTap;

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
