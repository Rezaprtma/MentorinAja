import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Labeled checkbox.
///
/// The entire row is tappable via an [InkWell] so the label acts as a click
/// target. Color and shape come from the Material 3 theme defaults for visual
/// consistency.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.autofocus = false,
    this.contentPadding,
    this.controlAffinity = ListTileControlAffinity.leading,
  });

  /// Current checked state; null means indeterminate (three-state).
  final bool? value;

  /// Called when the user toggles the checkbox.
  final ValueChanged<bool?>? onChanged;

  /// Primary label text next to the checkbox.
  final String? label;

  /// Secondary text below the label.
  final String? subtitle;

  /// Whether the checkbox is interactive.
  final bool enabled;

  final bool autofocus;

  final EdgeInsetsGeometry? contentPadding;

  /// Whether the checkbox appears before or after the label.
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    final checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      autofocus: autofocus,
    );

    final textContent = label != null
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label!,
                  style: AppTypeScale.bodyLarge.copyWith(
                    color: enabled ? ext.textPrimary : ext.textDisabled,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          )
        : const SizedBox.shrink();

    return InkWell(
      onTap: enabled ? () => onChanged?.call(!(value ?? false)) : null,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding:
            contentPadding ??
            const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: controlAffinity == ListTileControlAffinity.leading
              ? [checkbox, const SizedBox(width: AppSpacing.xs), textContent]
              : [textContent, const SizedBox(width: AppSpacing.xs), checkbox],
        ),
      ),
    );
  }
}
