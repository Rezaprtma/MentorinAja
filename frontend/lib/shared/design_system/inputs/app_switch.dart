import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Labeled toggle switch.
///
/// A compact [SwitchListTile] wrapper that adds consistent label, subtitle
/// and semantic support. The switch respects the current [Theme] colors
/// (primary for active, onSurface for inactive).
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

  /// Current toggle state.
  final bool value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Label text next to the switch.
  final String? label;

  /// Secondary text below the label.
  final String? subtitle;

  /// Whether the switch is interactive.
  final bool enabled;

  final EdgeInsetsGeometry? contentPadding;

  /// Active track color; defaults to theme primary.
  final Color? activeColor;

  /// Inactive track color.
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
