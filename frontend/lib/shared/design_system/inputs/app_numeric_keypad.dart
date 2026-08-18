//**
// frontend/shared/design_system/inputs/app_numeric_keypad.dart
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

class AppNumericKeypad extends StatelessWidget {
  const AppNumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
    this.keySize = 64,
  });

  final ValueChanged<int> onDigit;

  final VoidCallback onBackspace;

  final bool enabled;

  final double keySize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, [1, 2, 3]),
        _row(context, [4, 5, 6]),
        _row(context, [7, 8, 9]),
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Expanded(child: _keypad(context, digit: 0)),
            Expanded(child: _backspaceKey(context)),
          ],
        ),
      ],
    );
  }

  Widget _row(BuildContext context, List<int> digits) {
    return Row(
      children: [
        for (final digit in digits)
          Expanded(child: _keypad(context, digit: digit)),
      ],
    );
  }

  Widget _keypad(BuildContext context, {required int digit}) {
    return _KeypadButton(
      size: keySize,
      enabled: enabled,
      onTap: () => onDigit(digit),
      child: Text(
        '$digit',
        style: AppTypeScale.titleLarge.copyWith(
          color: enabled
              ? context.appColors.textPrimary
              : context.appColors.textDisabled,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _backspaceKey(BuildContext context) {
    return _KeypadButton(
      size: keySize,
      enabled: enabled,
      onTap: onBackspace,
      child: Icon(
        Icons.backspace_outlined,
        size: AppIconSizes.lg,
        color: enabled
            ? context.appColors.textSecondary
            : context.appColors.textDisabled,
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.size,
    required this.enabled,
    required this.onTap,
    required this.child,
  });

  final double size;
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: InkResponse(
        onTap: enabled ? onTap : null,
        radius: size / 2,
        containedInkWell: false,
        highlightShape: BoxShape.circle,
        highlightColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.10),
        splashColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.08),
        child: Center(child: child),
      ),
    );
  }
}
