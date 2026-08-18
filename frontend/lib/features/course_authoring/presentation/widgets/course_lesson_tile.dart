//**
// frontend/features/course_authoring/presentation/widgets/course_lesson_tile.dart
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
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/lesson_draft.dart';

class CourseLessonTile extends StatelessWidget {
  const CourseLessonTile({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.onDelete,
  });

  final LessonDraft lesson;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final hasPdf =
        lesson.materialPdfPath != null &&
        lesson.materialPdfPath!.trim().isNotEmpty;

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypeScale.titleMedium.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      lesson.description.isNotEmpty
                          ? lesson.description
                          : 'Tidak ada deskripsi modul.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypeScale.bodySmall.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: AppIconSizes.md,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ReadinessBadge(label: 'Materi PDF', ready: hasPdf),
        ],
      ),
    );
  }
}

class _ReadinessBadge extends StatelessWidget {
  const _ReadinessBadge({required this.label, required this.ready});

  final String label;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final background = ready
        ? ext.successContainer
        : scheme.surfaceContainerHighest;
    final foreground = ready ? ext.onSuccessContainer : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ready ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 12,
            color: foreground,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTypeScale.labelSmall.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
