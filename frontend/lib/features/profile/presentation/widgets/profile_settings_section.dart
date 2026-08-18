//**
// frontend/features/profile/presentation/widgets/profile_settings_section.dart
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

import 'profile_setting_row.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.xs,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppTypeScale.labelMedium.copyWith(
              color: ext.textSecondary,
              letterSpacing: 1.25,
            ),
          ),
        ),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0)
            const AppDivider(height: 1, indent: ProfileSettingRow.leadingWidth),
          rows[i],
        ],
      ],
    );
  }
}
