import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import 'tech_logo.dart';

/// Compact "Progres Saya" card on the Home screen.
///
/// A calm white card led by the course's real technology logo, the title and a
/// compact lesson line. The progress bar shares a row with the percentage and a
/// small play action that resumes the lesson — the whole card stays one dense,
/// scannable learning-progress item without a large call-to-action button.
class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.courseTitle,
    required this.lessonLabel,
    required this.progress,
    required this.onContinue,
  });

  /// Course name being resumed.
  final String courseTitle;

  /// Current lesson line, e.g. "Pelajaran 12 dari 20 • Fungsi".
  final String lessonLabel;

  /// Completion fraction in the range 0.0–1.0.
  final double progress;

  /// Resumes the lesson.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final percent = (progress * 100).round();

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TechLogo(
                assetPath: AppIconPaths.techPython,
                background: scheme.primaryContainer,
                size: 56,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      courseTitle,
                      style: AppTypeScale.headlineSmall.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      lessonLabel,
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppIconButton(
                icon: Icons.play_arrow_rounded,
                tooltip: 'Lanjutkan pelajaran',
                color: scheme.onPrimary,
                backgroundColor: scheme.primary,
                iconSize: AppIconSizes.md,
                visualDensity: VisualDensity.compact,
                onPressed: onContinue,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppLinearLoader(
                  value: progress,
                  minHeight: AppSpacing.xs,
                  color: scheme.primary,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
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
      ),
    );
  }
}
