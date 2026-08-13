/// Spacing scale for the MentorinAja design system.
///
/// Follows the 8-point grid defined in `docs/design/design-system.md`
/// (4, 8, 12, 16, 24, 32, 40, 48). Use these tokens instead of raw doubles so
/// rhythm stays consistent and refactoring the scale is a one-file change.
abstract final class AppSpacing {
  /// 4 — smallest inset; tight alignment details.
  static const double xxs = 4;

  /// 8 — default inner padding for compact controls.
  static const double xs = 8;

  /// 12 — small gaps between related elements.
  static const double sm = 12;

  /// 16 — standard screen padding and card insets.
  static const double md = 16;

  /// 24 — grouping between distinct blocks.
  static const double lg = 24;

  /// 32 — section spacing on wider layouts.
  static const double xl = 32;

  /// 40 — generous screen-level spacing.
  static const double xxl = 40;

  /// 48 — large hero/empty-state spacing.
  static const double xxxl = 48;
}
