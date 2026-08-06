import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_tile.dart';

/// Settings screen tile with a leading icon container and a trailing chevron.
///
/// Follows the standard iOS/Android settings pattern: icon on the left, label
/// + optional subtitle in the center, and a navigation chevron on the right.
/// The [destructive] flag tints the leading icon and title in the error color.
class AppSettingsTile extends StatelessWidget {
  const AppSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.enabled = true,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;
  final bool enabled;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final iconColor = destructive ? scheme.error : ext.textSecondary;
    final tileTrailing =
        trailing ??
        (onTap != null
            ? Icon(
                Icons.chevron_right,
                color: ext.textDisabled,
                size: AppIconSizes.lg,
              )
            : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTile(
          leading: icon != null
              ? Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (destructive ? scheme.error : scheme.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Icon(icon, color: iconColor, size: AppIconSizes.md),
                )
              : null,
          title: title,
          subtitle: subtitle,
          trailing: tileTrailing,
          onTap: onTap,
          enabled: enabled,
          titleTextStyle: AppTypeScale.bodyLarge.copyWith(
            color: destructive
                ? scheme.error
                : enabled
                ? ext.textPrimary
                : ext.textDisabled,
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppSpacing.md + 36 + AppSpacing.xs,
            color: ext.divider,
          ),
      ],
    );
  }
}
