//**
// frontend/shared/design_system/lists/app_tile.dart
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

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.dense = false,
    this.isThreeLine = false,
    this.contentPadding,
    this.leadingIconColor,
    this.titleTextStyle,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool dense;
  final bool isThreeLine;
  final EdgeInsetsGeometry? contentPadding;
  final Color? leadingIconColor;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return ListTile(
      leading: leading,
      title: title != null
          ? Text(
              title!,
              style:
                  titleTextStyle ??
                  AppTypeScale.bodyLarge.copyWith(
                    color: enabled ? ext.textPrimary : ext.textDisabled,
                  ),
              maxLines: isThreeLine ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypeScale.bodySmall.copyWith(color: ext.textSecondary),
              maxLines: isThreeLine ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      dense: dense,
      isThreeLine: isThreeLine,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs,
          ),
      iconColor: leadingIconColor ?? ext.textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    );
  }
}
