//**
// frontend/shared/design_system/inputs/app_text_field.dart
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

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.autofillHints = const <String>[],
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textAlign = TextAlign.start,
    this.enableSuggestions = true,
    this.obscuringCharacter = '•',
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final List<String> autofillHints;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final TextAlign textAlign;
  final bool enableSuggestions;
  final String obscuringCharacter;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _internalController;
  late final bool _ownsController;
  late final FocusNode _internalFocusNode;
  late final bool _ownsFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _internalController = TextEditingController(
      text: widget.initialValue ?? '',
    );
    _internalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == null && widget.controller != null) {
      _internalController.dispose();
    }
  }

  @override
  void dispose() {
    if (_ownsController) _internalController.dispose();
    if (_ownsFocusNode) _internalFocusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final showClear =
            widget.showClearButton && widget.enabled && value.text.isNotEmpty;

        final clearButton = showClear
            ? Semantics(
                label: 'Clear',
                button: true,
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: AppIconSizes.md,
                    color: scheme.onSurfaceVariant,
                  ),
                  onPressed: _clear,
                ),
              )
            : null;

        return TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscure,
          obscuringCharacter: widget.obscuringCharacter,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          autofillHints: widget.autofillHints.isEmpty
              ? null
              : widget.autofillHints,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          textAlign: widget.textAlign,
          enableSuggestions: widget.enableSuggestions,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.helper,
            errorText: widget.error,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon ?? (showClear ? clearButton : null),
            errorMaxLines: 2,
          ),
        );
      },
    );
  }
}
