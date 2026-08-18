//**
// frontend/features/lesson/presentation/widgets/stages/stage_intro_card.dart
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

import '../../stages/lesson_stage.dart';

class StageIntroCard extends StatelessWidget {
  const StageIntroCard({super.key, required this.stage});

  final LessonStage stage;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppIconSizes.xxl,
                height: AppIconSizes.xxl,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  stage.icon,
                  size: AppIconSizes.lg,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  stage.label,
                  style: AppTypeScale.labelSmall.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            stage.description,
            style: AppTypeScale.bodySmall.copyWith(
              color: ext.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
