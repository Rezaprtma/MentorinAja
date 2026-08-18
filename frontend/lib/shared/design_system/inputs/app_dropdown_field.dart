//**
// frontend/shared/design_system/inputs/app_dropdown_field.dart
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

  final T? initialValue;

  final List<DropdownMenuItem<T>> items;

  final String? label;

  final String? hint;

  final String? helper;

  final String? error;

  final FormFieldValidator<T>? validator;

  final ValueChanged<T?>? onChanged;

  final bool enabled;

  final bool isExpanded;

  final Widget? icon;

  final InputDecoration? decoration;

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
