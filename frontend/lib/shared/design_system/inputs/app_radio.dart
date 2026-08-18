//**
// frontend/shared/design_system/inputs/app_radio.dart
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

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.options,
    this.enabled = true,
    this.direction = Axis.vertical,
    this.spacing = AppSpacing.xs,
  });

  final T? groupValue;

  final ValueChanged<T?> onChanged;

  final List<AppRadioOption<T>> options;

  final bool enabled;

  final Axis direction;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      child: direction == Axis.vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _spaced(options, spacing),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: _spacedH(options, spacing),
            ),
    );
  }

  List<Widget> _spaced(List<AppRadioOption<T>> opts, double gap) {
    final result = <Widget>[];
    for (var i = 0; i < opts.length; i++) {
      if (i > 0) result.add(SizedBox(height: gap));
      result.add(opts[i]);
    }
    return result;
  }

  List<Widget> _spacedH(List<AppRadioOption<T>> opts, double gap) {
    final result = <Widget>[];
    for (var i = 0; i < opts.length; i++) {
      if (i > 0) result.add(SizedBox(width: gap));
      result.add(opts[i]);
    }
    return result;
  }
}

class AppRadioOption<T> extends StatelessWidget {
  const AppRadioOption({
    super.key,
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  final T value;

  final String label;

  final String? subtitle;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return InkWell(
      onTap: enabled ? () {} : null,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(value: value),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
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
            ),
          ],
        ),
      ),
    );
  }
}
