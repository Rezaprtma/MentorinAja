import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Responsive horizontal padding that adapts to screen width.
///
/// On phones: 16dp. On tablets: 24dp. On desktop: clamped to max-width with
/// auto-centering. Screens never hardcode padding — they call
/// `ResponsivePadding.horizontal(context)`.
abstract final class ResponsivePadding {
  /// Returns the standard horizontal padding for the current screen width.
  static double horizontal(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return AppSpacing.xl; // 32
    if (width >= 840) return AppSpacing.lg; // 24
    return AppSpacing.md; // 16
  }

  /// Returns the standard vertical padding for the current screen width.
  static double vertical(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.xl; // 32
    return AppSpacing.lg; // 24
  }

  /// Returns the standard symmetric [EdgeInsets] for the current screen.
  static EdgeInsets symmetric(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontal(context),
      vertical: vertical(context),
    );
  }
}

/// Responsive spacing that adapts to screen width.
abstract final class ResponsiveSpacing {
  /// Returns the standard gap between sections for the current screen.
  static double sectionGap(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.xl; // 32
    return AppSpacing.lg; // 24
  }

  /// Returns the standard gap between items in a list/grid.
  static double itemGap(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.md; // 16
    return AppSpacing.sm; // 12
  }
}
