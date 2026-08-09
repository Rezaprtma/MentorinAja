import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/theme.dart';

/// One-time-password input controlled by a custom keypad.
///
/// Unlike a classic [TextField], the boxes are display-only and never open the
/// platform soft keyboard. Digits are appended through [AppOtpInputState]
/// (driven by a keypad) or via hardware keys / paste, and are reported through
/// [onChanged] and [onCompleted]. Only numeric characters are accepted and the
/// code can never exceed [length] digits.
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

  /// Number of digit boxes.
  final int length;

  /// Horizontal space available for all boxes (used to derive their size).
  final double maxWidth;

  /// Whether interaction is allowed (e.g. while verifying the code).
  final bool enabled;

  /// Highlights the boxes with the error color.
  final bool hasError;

  /// Called on every change with the current aggregated code.
  final ValueChanged<String>? onChanged;

  /// Called when all digits are filled.
  final ValueChanged<String>? onCompleted;

  /// Horizontal gap between boxes.
  final double spacing;

  @override
  State<AppOtpInput> createState() => AppOtpInputState();
}

class AppOtpInputState extends State<AppOtpInput> {
  String _code = '';
  final FocusNode _focusNode = FocusNode();

  /// Current value of the code.
  String get value => _code;

  /// Inserts a single [digit], moving the cursor forward.
  void append(int digit) {
    if (!mounted || !widget.enabled || _code.length >= widget.length) return;
    _setCode(_code + digit.toString());
  }

  /// Removes the last digit.
  void removeLast() {
    if (!mounted || _code.isEmpty) return;
    _setCode(_code.substring(0, _code.length - 1));
  }

  /// Clears every digit.
  void clear() {
    if (!mounted || _code.isEmpty) return;
    _setCode('');
  }

  /// Inserts as many numeric characters from [raw] as fit, up to [length].
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
