/// Page header for the Profile tab.
///
/// A short title and one supporting line, mirroring the Progress/Explore
/// headers so all three tabs open with the same slim intro treatment.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Profil',
          style: AppTypeScale.headlineLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Kelola akun dan preferensi belajarmu.',
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
      ],
    );
  }
}
