//**
// frontend/features/course/presentation/widgets/course_identity_header.dart
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

import '../../domain/entities/course_detail.dart';

class CourseIdentityHeader extends StatelessWidget {
  const CourseIdentityHeader({super.key, required this.course});

  final CourseDetail course;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final brand = course.brand;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Stack(
        children: [
          Positioned(
            top: -AppSpacing.lg,
            right: -AppSpacing.lg,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brand.accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TechLogo(
                    assetPath: course.iconPath,
                    size: 64,
                    background: brand.background,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: ext.warning,
                        size: AppIconSizes.sm,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: AppTypeScale.labelLarge.copyWith(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                course.title,
                style: AppTypeScale.headlineSmall.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                course.shortDescription,
                style: AppTypeScale.bodyMedium.copyWith(
                  color: ext.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  _MetaItem(
                    icon: Icons.schedule_outlined,
                    label: _formatDuration(course.estimatedMinutes),
                  ),
                  _MetaItem(
                    icon: Icons.menu_book_outlined,
                    label: '${course.lessonCount} pelajaran',
                  ),
                  if (course.level != null)
                    _MetaItem(
                      icon: Icons.signal_cellular_alt,
                      label: course.level!,
                    ),
                  if (course.studentCount != null)
                    _MetaItem(
                      icon: Icons.groups_outlined,
                      label: _formatStudents(course.studentCount!),
                    ),
                ],
              ),
              if (course.isEnrolled) ...[
                const SizedBox(height: AppSpacing.lg),
                _EnrollmentProgress(course: course, scheme: scheme, ext: ext),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDuration(int? minutes) {
    if (minutes == null) return 'Estimasi';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    if (hours == 0) return '$minutes menit';
    if (rest == 0) return '$hours jam';
    return '$hours jam $rest menit';
  }

  static String _formatStudents(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}rb siswa';
    return '$count siswa';
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppIconSizes.sm, color: ext.textSecondary),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: Text(
            label,
            style: AppTypeScale.labelMedium.copyWith(color: ext.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EnrollmentProgress extends StatelessWidget {
  const _EnrollmentProgress({
    required this.course,
    required this.scheme,
    required this.ext,
  });

  final CourseDetail course;
  final ColorScheme scheme;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final percent = ((course.progress ?? 0) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLinearLoader(
          value: course.progress,
          minHeight: AppSpacing.xs,
          color: scheme.primary,
          backgroundColor: scheme.surfaceContainerHighest,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: Text(
                course.nextLessonTitle == null
                    ? 'Kamu sudah menyelesaikan course ini.'
                    : 'Lanjutkan di ${course.nextLessonTitle}',
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$percent%',
              style: AppTypeScale.labelLarge.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
