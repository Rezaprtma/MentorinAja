//**
// frontend/shared/design_system/inputs/app_otp_field.dart
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
import 'package:flutter/services.dart';

import '../../../core/theme/theme.dart';

class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.error,
    this.autofocus = false,
    this.autofillHints = const <String>[],
    this.spacing = AppSpacing.sm,
  });

  final int length;

  final ValueChanged<String>? onCompleted;

  final ValueChanged<String>? onChanged;

  final bool enabled;

  final String? error;

  final bool autofocus;

  final List<String> autofillHints;

  final double spacing;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final chars = value.split('');
      for (var i = 0; i < chars.length && (index + i) < widget.length; i++) {
        _controllers[index + i].text = chars[i];
      }
      final next = (index + chars.length).clamp(0, widget.length - 1);
      _focusNodes[next].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    widget.onChanged?.call(_value);

    if (_value.length == widget.length) {
      widget.onCompleted?.call(_value);
    }
  }

  void _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      widget.onChanged?.call(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final hasError = widget.error != null;
    final borderColor = hasError ? scheme.error : ext.border;
    final focusBorderColor = hasError ? scheme.error : scheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (i) {
            final box = _OtpBox(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              enabled: widget.enabled,
              autofocus: i == 0 && widget.autofocus,
              autofillHints: i == 0 ? widget.autofillHints : const <String>[],
              borderColor: borderColor,
              focusBorderColor: focusBorderColor,
              onChanged: (v) => _onChanged(i, v),
              onKey: (e) => _onKey(i, e),
            );
            if (i > 0) {
              return Padding(
                padding: EdgeInsets.only(left: widget.spacing),
                child: box,
              );
            }
            return box;
          }),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xxs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              widget.error!,
              style: AppTypeScale.bodySmall.copyWith(color: scheme.error),
            ),
          ),
        ],
      ],
    );
  }
}

class _OtpBox extends StatefulWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.autofocus,
    required this.autofillHints,
    required this.borderColor,
    required this.focusBorderColor,
    required this.onChanged,
    required this.onKey,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool autofocus;
  final List<String> autofillHints;
  final Color borderColor;
  final Color focusBorderColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKey;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_OtpBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: widget.onKey,
      child: SizedBox(
        width: 48,
        height: 56,
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          autofillHints: widget.autofillHints.isEmpty
              ? null
              : widget.autofillHints,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTypeScale.headlineSmall.copyWith(
            color: context.appColors.textPrimary,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: widget.focusBorderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            filled: true,
            fillColor: _focused
                ? context.appColors.card
                : context.appColors.background,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
