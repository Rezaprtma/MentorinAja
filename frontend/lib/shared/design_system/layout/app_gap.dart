import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Spacing placeholder that consumes the 8-point scale.
///
/// Use instead of ad-hoc `SizedBox` widths/heights so spacing rhythm stays
/// consistent and is trivially searchable.
///
/// ```dart
/// AppGap.v(AppSpacing.md);   // vertical space
/// AppGap.h(AppSpacing.sm);   // horizontal space
/// AppGap(AppSpacing.lg);     // square space
/// ```
class AppGap extends StatelessWidget {
  const AppGap(this.size, {super.key}) : _width = size, _height = size;

  /// A gap of fixed [width].
  const AppGap.h(double width, {super.key})
    : _width = width,
      _height = null,
      size = null;

  /// A gap of fixed [height].
  const AppGap.v(double height, {super.key})
    : _width = null,
      _height = height,
      size = null;

  final double? _width;
  final double? _height;
  final double? size;

  /// 4.0 — smallest inline gap.
  static const AppGap xxs = AppGap(AppSpacing.xxs);

  /// 8.0 — default compact gap.
  static const AppGap xs = AppGap(AppSpacing.xs);

  /// 12.0 — small gap between related elements.
  static const AppGap sm = AppGap(AppSpacing.sm);

  /// 16.0 — standard gap.
  static const AppGap md = AppGap(AppSpacing.md);

  /// 24.0 — group gap.
  static const AppGap lg = AppGap(AppSpacing.lg);

  /// 32.0 — section gap.
  static const AppGap xl = AppGap(AppSpacing.xl);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: _width ?? size, height: _height ?? size);
  }
}
