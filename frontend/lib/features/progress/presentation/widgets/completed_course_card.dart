//**
// frontend/features/progress/presentation/widgets/completed_course_card.dart
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
import 'package:frontend/shared/widgets/tech/tech_logo.dart';

import '../../mock_progress_data.dart';

class CompletedCourseCard extends StatelessWidget {
  const CompletedCourseCard({super.key, required this.course, this.onTap});

  final MockProgressCourse course;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TechLogo(
                assetPath: course.iconPath,
                background: scheme.primaryContainer,
                size: AppIconSizes.xxxxl,
              ),
              const Spacer(),
              const AppBadge(
                label: 'Selesai',
                variant: AppBadgeVariant.success,
                icon: Icons.check_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            course.title,
            style: AppTypeScale.headlineSmall.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${course.completedLessons} dari ${course.lessonCount} pelajaran',
            style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          AppLinearLoader(
            value: 1.0,
            minHeight: AppSpacing.xs,
            color: ext.success,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
