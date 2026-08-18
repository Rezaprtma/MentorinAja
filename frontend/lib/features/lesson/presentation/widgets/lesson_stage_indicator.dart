//**
// frontend/features/lesson/presentation/widgets/lesson_stage_indicator.dart
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

import '../stages/lesson_stage.dart';

class LessonStageIndicator extends StatelessWidget {
  const LessonStageIndicator({
    super.key,
    required this.current,
    this.stages = const [
      LessonStage.materi,
      LessonStage.game,
      LessonStage.latihan,
    ],
  });

  final int current;

  final List<LessonStage> stages;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: AppDurations.fast,
                  height: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: i <= current
                        ? scheme.primary
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  stages[i].label,
                  style: AppTypeScale.labelSmall.copyWith(
                    color: i == current ? scheme.primary : ext.textSecondary,
                    fontWeight: i == current
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
