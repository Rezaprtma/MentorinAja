/// Settings row for the Profile tab.
///
/// Icon, title and an optional current-value label arranged in one flat row on
/// the page background. Rows meet the design-system 56 px minimum height for
/// comfortable touch targets. Leading icons use the brand indigo so settings
/// stay colorful and consistent with the app's brand-tinted accents; only
/// destructive rows turn red. The trailing value reports the current state
/// (e.g. the active theme) and a chevron signals navigation when the row is
/// tappable.
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

  /// Horizontal space the leading icon occupies so dividers and values align
  /// with the row title.
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

/// A short current-state label shown as a settings row trailing value.
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
