//**
// frontend/features/profile/presentation/widgets/profile_setting_row.dart
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

class ProfileSettingRow extends StatelessWidget {
  const ProfileSettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.showChevron = true,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? value;
  final bool showChevron;
  final VoidCallback? onTap;
  final bool destructive;

  static const double leadingWidth = AppIconSizes.md + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppIconSizes.md,
              color: destructive ? scheme.error : scheme.secondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypeScale.bodyLarge.copyWith(
                  color: destructive ? scheme.error : ext.textPrimary,
                ),
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                fit: FlexFit.loose,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ProfileSettingValue(value!),
                ),
              ),
            ],
            if (showChevron) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right,
                size: AppIconSizes.lg,
                color: ext.textDisabled,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfileSettingValue extends StatelessWidget {
  const ProfileSettingValue(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypeScale.bodyMedium.copyWith(
        color: context.appColors.textSecondary,
      ),
    );
  }
}
