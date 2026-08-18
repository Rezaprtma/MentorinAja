//**
// frontend/features/onboarding/presentation/widgets/onboarding_indicator.dart
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

import 'package:frontend/core/theme/theme.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.accent,
    required this.current,
    this.total = 3,
    this.inactiveColor,
  });

  final Color accent;
  final int current;
  final int total;

  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final quietColor = inactiveColor ?? scheme.surfaceContainerHighest;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppEasing.standard,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          width: isActive ? AppSpacing.xl : AppSpacing.xs,
          height: AppSpacing.xs,
          decoration: BoxDecoration(
            color: isActive ? accent : quietColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }
}
