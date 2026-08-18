//**
// frontend/features/progress/presentation/widgets/active_course_card.dart
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

class ActiveCourseCard extends StatelessWidget {
  const ActiveCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onContinue,
  });

  final MockProgressCourse course;

  final VoidCallback? onTap;

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final percent = (course.progress * 100).round();

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
              Text(
                '$percent%',
                style: AppTypeScale.titleLarge.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
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
            course.lessonLabel,
            style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          AppLinearLoader(
            value: course.progress,
            minHeight: AppSpacing.xs,
            color: scheme.primary,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Pelajaran berikutnya',
            style: AppTypeScale.labelSmall.copyWith(color: ext.textDisabled),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            course.nextLesson,
            style: AppTypeScale.titleSmall.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Lanjutkan',
            size: AppButtonSize.small,
            isFullWidth: true,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
