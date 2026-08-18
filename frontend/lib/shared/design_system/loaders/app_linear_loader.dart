//**
// frontend/shared/design_system/loaders/app_linear_loader.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
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

import '../../../core/theme/theme.dart';

class AppLinearLoader extends StatelessWidget {
  const AppLinearLoader({
    super.key,
    this.value,
    this.label,
    this.color,
    this.minHeight,
    this.backgroundColor,
  });

  final double? value;
  final String? label;
  final Color? color;
  final double? minHeight;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bar = LinearProgressIndicator(
      value: value,
      minHeight: minHeight,
      color: color ?? scheme.primary,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
    );

    if (label == null) return bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar,
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label!,
          style: AppTypeScale.bodySmall.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
