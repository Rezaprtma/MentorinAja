import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Horizontal progress indicator with optional label.
class AppLinearLoader extends StatelessWidget {
  const AppLinearLoader({
    super.key,
    this.value,
    this.label,
    this.color,
    this.minHeight,
    this.backgroundColor,
  });

  /// 0.0–1.0; null renders an indeterminate bar.
  final double? value;
  final String? label;
  final Color? color;
  final double? minHeight;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bar = LinearProgressIndicator(
      value: value,
      minHeight: minHeight,
      color: color ?? scheme.primary,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
    );

    if (label == null) return bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar,
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label!,
          style: AppTypeScale.bodySmall.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
