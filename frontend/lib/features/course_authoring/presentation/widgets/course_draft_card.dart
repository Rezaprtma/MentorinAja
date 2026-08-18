//**
// frontend/features/course_authoring/presentation/widgets/course_draft_card.dart
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
import 'package:frontend/shared/enums/enums.dart';
import 'package:frontend/shared/widgets/asset/app_svg.dart';

import '../../domain/entities/course_authoring_draft.dart';
import '../pages/course_list_page.dart';

class CourseDraftCard extends StatelessWidget {
  const CourseDraftCard({super.key, required this.draft, required this.onTap});

  final CourseAuthoringDraft draft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final lang = ProgrammingLanguage.fromString(draft.language);

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      lang?.brandColors.background ?? scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: lang != null
                    ? AppSvg(lang.iconPath)
                    : Icon(
                        Icons.code_rounded,
                        size: AppIconSizes.md,
                        color: scheme.onPrimaryContainer,
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypeScale.titleMedium.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      draft.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypeScale.bodySmall.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.play_lesson_outlined,
                size: AppIconSizes.xs,
                color: ext.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${draft.lessons.length} Pelajaran',
                style: AppTypeScale.labelMedium.copyWith(
                  color: ext.textSecondary,
                ),
              ),
              const Spacer(),
              AppBadge(label: draft.status.label, variant: draft.status.badge),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            draftUpdatedLabel(draft.updatedAt),
            style: AppTypeScale.labelSmall.copyWith(color: ext.textDisabled),
          ),
        ],
      ),
    );
  }
}
