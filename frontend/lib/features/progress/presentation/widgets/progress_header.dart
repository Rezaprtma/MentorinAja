import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Page header for the Progress tab.
///
/// A short title and one supporting line, kept deliberately slim so the
/// course-progress content below stays the visual focus of the screen.
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Progres Belajar',
          style: AppTypeScale.headlineLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Lihat perkembangan belajarmu.',
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
      ],
    );
  }
}
