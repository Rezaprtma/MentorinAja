import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Themed horizontal divider.
///
/// Wraps the Material [Divider] so stroke color, thickness and vertical rhythm
/// always come from the design tokens rather than ad-hoc values.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = AppSpacing.md,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  /// Space reserved above and below the line.
  final double height;

  /// Stroke width; falls back to the theme divider thickness.
  final double? thickness;

  /// Left inset before the line.
  final double indent;

  /// Right inset after the line.
  final double endIndent;

  /// Optional stroke color; defaults to `appColors.divider`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.appColors.divider,
    );
  }
}
