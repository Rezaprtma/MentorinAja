/// A titled group of settings rows for the Profile tab.
///
/// Renders an uppercase category label above the given rows, drawing a
/// hairline divider between each pair aligned to the row title. The group
/// rests directly on the page background so content reads as clean,
/// card-free sections.
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
