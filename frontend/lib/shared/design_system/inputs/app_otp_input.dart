//**
// frontend/shared/design_system/inputs/app_otp_input.dart
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

class AppOtpInput extends StatefulWidget {
  const AppOtpInput({
    super.key,
    this.length = 6,
    this.maxWidth = double.infinity,
    this.enabled = true,
    this.hasError = false,
    this.onChanged,
    this.onCompleted,
    this.spacing = AppSpacing.xs,
  });

  final int length;

  final double maxWidth;

  final bool enabled;

  final bool hasError;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onCompleted;

  final double spacing;

  @override
  State<AppOtpInput> createState() => AppOtpInputState();
}

class AppOtpInputState extends State<AppOtpInput> {
  String _code = '';
  final FocusNode _focusNode = FocusNode();

  String get value => _code;

  void append(int digit) {
    if (!mounted || !widget.enabled || _code.length >= widget.length) return;
    _setCode(_code + digit.toString());
  }

  void removeLast() {
    if (!mounted || _code.isEmpty) return;
    _setCode(_code.substring(0, _code.length - 1));
  }

  void clear() {
    if (!mounted || _code.isEmpty) return;
    _setCode('');
  }

  void pasteValue(String raw) {
    if (!mounted || !widget.enabled) return;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;
    final room = widget.length - _code.length;
    _setCode(_code + digits.substring(0, digits.length.clamp(0, room)));
  }

  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backspace) {
        removeLast();
        return true;
      }
      final digit = _digitForKey(key);
      if (digit != null) {
        append(digit);
        return true;
      }
    }
    return false;
  }

  static int? _digitForKey(LogicalKeyboardKey key) {
    return switch (key) {
      LogicalKeyboardKey.digit0 => 0,
      LogicalKeyboardKey.digit1 => 1,
      LogicalKeyboardKey.digit2 => 2,
      LogicalKeyboardKey.digit3 => 3,
      LogicalKeyboardKey.digit4 => 4,
      LogicalKeyboardKey.digit5 => 5,
      LogicalKeyboardKey.digit6 => 6,
      LogicalKeyboardKey.digit7 => 7,
      LogicalKeyboardKey.digit8 => 8,
      LogicalKeyboardKey.digit9 => 9,
      LogicalKeyboardKey.numpad0 => 0,
      LogicalKeyboardKey.numpad1 => 1,
      LogicalKeyboardKey.numpad2 => 2,
      LogicalKeyboardKey.numpad3 => 3,
      LogicalKeyboardKey.numpad4 => 4,
      LogicalKeyboardKey.numpad5 => 5,
      LogicalKeyboardKey.numpad6 => 6,
      LogicalKeyboardKey.numpad7 => 7,
      LogicalKeyboardKey.numpad8 => 8,
      LogicalKeyboardKey.numpad9 => 9,
      _ => null,
    };
  }

  void _setCode(String value) {
    setState(() => _code = value);
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode..canRequestFocus = widget.enabled,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Builder(
        builder: (context) {
          final available = widget.maxWidth.isFinite
              ? widget.maxWidth
              : MediaQuery.sizeOf(context).width;
          final gap = widget.length > 1
              ? widget.spacing * (widget.length - 1)
              : 0.0;
          final boxWidth = ((available - gap) / widget.length).clamp(
            40.0,
            64.0,
          );
          final boxHeight = boxWidth + 10;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (i) {
              final box = _OtpBox(
                digit: i < _code.length ? _code[i] : null,
                active: !widget.hasError && i == _code.length,
                error: widget.hasError,
                enabled: widget.enabled,
                size: Size(boxWidth, boxHeight),
              );
              if (i == 0) return box;
              return Padding(
                padding: EdgeInsets.only(left: widget.spacing),
                child: box,
              );
            }),
          );
        },
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.digit,
    required this.active,
    required this.error,
    required this.enabled,
    required this.size,
  });

  final String? digit;
  final bool active;
  final bool error;
  final bool enabled;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;

    final borderColor = error ? scheme.error : ext.border;
    final fillColor = error
        ? scheme.error.withValues(alpha: 0.05)
        : active
        ? scheme.primaryContainer
        : ext.background;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppEasing.decelerate,
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: active ? scheme.primary : borderColor,
          width: active ? 2 : 1,
        ),
      ),
      child: Text(
        digit ?? '',
        style: AppTypeScale.titleLarge.copyWith(
          color: enabled ? ext.textPrimary : ext.textDisabled,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
