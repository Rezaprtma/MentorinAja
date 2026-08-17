/// Draft course card for the mentor course list.
///
/// Shows the course title, description, lesson count, status badge and the
/// last-updated time on a tappable [AppBaseCard]. The whole surface navigates
/// to the course editor.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

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
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
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
