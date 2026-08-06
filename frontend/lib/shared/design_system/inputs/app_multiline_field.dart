import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// Multi-line text input for longer content (messages, notes, descriptions).
///
/// Composes [AppTextField] with multi-line defaults: `maxLines` = 5,
/// `textInputAction` = newline, top-aligned text. For a single-line field with
/// character limit, use [AppTextField] with `maxLength` instead.
class AppMultilineField extends StatelessWidget {
  const AppMultilineField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.minLines = 3,
    this.maxLines = 5,
    this.maxLength,
    this.textInputAction,
    this.autofocus = false,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      label: label,
      hint: hint,
      helper: helper,
      error: error,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines ?? 5,
      maxLength: maxLength,
      textInputAction: textInputAction ?? TextInputAction.newline,
      autofocus: autofocus,
      readOnly: readOnly,
      textAlign: TextAlign.start,
    );
  }
}
