import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Centered circular progress indicator with optional label.
///
/// Wraps [CircularProgressIndicator] with consistent sizing, color and
/// semantic labeling. Use inside [FutureBuilder]s and async page states.
class AppCircularLoader extends StatelessWidget {
  const AppCircularLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.4,
    this.label,
    this.centered = true,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final String? label;
  final bool centered;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );

    if (!centered && label == null) return loader;

    Widget widget = loader;
    if (label != null) {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: AppSpacing.sm),
          Text(
            label!,
            style: AppTypeScale.bodySmall.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      );
    }

    if (centered) {
      widget = Center(child: widget);
    }

    return widget;
  }
}
