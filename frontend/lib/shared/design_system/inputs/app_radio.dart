import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// A group of radio options using the modern [RadioGroup] API.
///
/// In Flutter 3.44+ the old radio button parameters are deprecated.
/// This widget wraps [RadioGroup] + a column of labeled [Radio] rows so
/// callers only need to supply options, the current [groupValue], and an
/// [onChanged] callback.
///
/// ```dart
/// AppRadioGroup<String>(
///   groupValue: _selected,
///   onChanged: (v) => setState(() => _selected = v),
///   options: [
///     AppRadioOption(value: 'a', label: 'Option A'),
///     AppRadioOption(value: 'b', label: 'Option B'),
///   ],
/// )
/// ```
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

  /// Currently selected value.
  final T? groupValue;

  /// Called when a new option is selected.
  final ValueChanged<T?> onChanged;

  /// The list of radio options.
  final List<AppRadioOption<T>> options;

  /// Whether all options are interactive.
  final bool enabled;

  /// Layout direction; defaults to vertical.
  final Axis direction;

  /// Gap between options.
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

/// A single radio option — must be placed inside an [AppRadioGroup].
class AppRadioOption<T> extends StatelessWidget {
  const AppRadioOption({
    super.key,
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  /// The value this option represents.
  final T value;

  /// Label text shown next to the radio button.
  final String label;

  /// Optional secondary text below the label.
  final String? subtitle;

  /// Whether this specific option is interactive.
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
