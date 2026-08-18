//**
// frontend/shared/design_system/inputs/app_checkbox.dart
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

  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final String? label;

  final String? subtitle;

  final bool enabled;

  final bool autofocus;

  final EdgeInsetsGeometry? contentPadding;

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
