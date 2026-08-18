//**
// frontend/shared/design_system/inputs/app_switch.dart
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

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.contentPadding,
    this.activeColor,
    this.inactiveColor,
  });

  final bool value;

  final ValueChanged<bool>? onChanged;

  final String? label;

  final String? subtitle;

  final bool enabled;

  final EdgeInsetsGeometry? contentPadding;

  final Color? activeColor;

  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;

    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: label != null
          ? Text(
              label!,
              style: AppTypeScale.bodyLarge.copyWith(
                color: enabled ? ext.textPrimary : ext.textDisabled,
              ),
            )
          : null,
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypeScale.bodySmall.copyWith(color: ext.textSecondary),
            )
          : null,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      activeThumbColor: activeColor ?? scheme.primary,
      inactiveTrackColor: inactiveColor ?? scheme.surfaceContainerHighest,
      inactiveThumbColor: scheme.onSurface,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
