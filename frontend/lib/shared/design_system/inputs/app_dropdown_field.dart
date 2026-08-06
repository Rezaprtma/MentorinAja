import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Styled dropdown selection field.
///
/// Wraps [DropdownButtonFormField] with the design tokens. Accepts a list of
/// [DropdownMenuItem]s and an [initialValue] (the modern API — `value` is
/// deprecated in this Flutter version). The dropdown surface, shape and text
/// styles are inherited from the global [InputDecorationTheme] set in
/// [AppTheme].
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.initialValue,
    required this.items,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.isExpanded = true,
    this.icon,
    this.decoration,
    this.autovalidateMode,
  });

  /// Pre-selected value. Must match one of [items] or be null.
  final T? initialValue;

  /// The list of selectable items.
  final List<DropdownMenuItem<T>> items;

  /// Field label text.
  final String? label;

  /// Placeholder when nothing is selected.
  final String? hint;

  /// Helper text below the field.
  final String? helper;

  /// Inline error text.
  final String? error;

  /// Validation callback for [Form] integration.
  final FormFieldValidator<T>? validator;

  /// Called when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the dropdown is interactive.
  final bool enabled;

  /// Whether the dropdown menu stretches to the field width.
  final bool isExpanded;

  /// Custom dropdown arrow icon.
  final Widget? icon;

  /// Optional [InputDecoration] override.
  final InputDecoration? decoration;

  /// Auto-validation mode for [Form].
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      icon: icon,
      autovalidateMode: autovalidateMode,
      decoration:
          decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            helperText: helper,
            errorText: error,
          ),
      style: AppTypeScale.bodyLarge.copyWith(color: ext.textPrimary),
      borderRadius: BorderRadius.circular(AppRadius.medium),
      dropdownColor: ext.card,
    );
  }

  /// Convenience factory for simple string items.
  static AppDropdownField<String> strings({
    Key? key,
    String? initialValue,
    required List<String> items,
    String? label,
    String? hint,
    String? helper,
    String? error,
    FormFieldValidator<String>? validator,
    ValueChanged<String?>? onChanged,
    bool enabled = true,
  }) {
    return AppDropdownField<String>(
      key: key,
      initialValue: initialValue,
      label: label,
      hint: hint,
      helper: helper,
      error: error,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }
}
