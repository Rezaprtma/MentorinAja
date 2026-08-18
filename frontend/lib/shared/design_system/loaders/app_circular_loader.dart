//**
// frontend/shared/design_system/loaders/app_circular_loader.dart
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

class AppCircularLoader extends StatelessWidget {
  const AppCircularLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.4,
    this.label,
    this.centered = true,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final String? label;
  final bool centered;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );

    if (!centered && label == null) return loader;

    Widget widget = loader;
    if (label != null) {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: AppSpacing.sm),
          Text(
            label!,
            style: AppTypeScale.bodySmall.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      );
    }

    if (centered) {
      widget = Center(child: widget);
    }

    return widget;
  }
}
