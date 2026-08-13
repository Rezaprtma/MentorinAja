/// Border-radius scale for the MentorinAja design system.
///
/// Radius values align with `docs/design/design-system.md`: rounded-friendly
/// surfaces for cards (16/24), a capsule shape for primary actions, and soft
/// corners for in-card elements. Combine with
/// `BorderRadius.circular(AppRadius.x)` or `RoundedRectangleBorder`.
abstract final class AppRadius {
  /// 8 — small chips and tags inside cards.
  static const double small = 8;

  /// 12 — inputs, chat bubbles, small surfaces.
  static const double medium = 12;

  /// 16 — standard cards and panels.
  static const double large = 16;

  /// 24 — hero surfaces, sheets, dialogs.
  static const double extraLarge = 24;

  /// 100 — fully-rounded capsule. Prefer `StadiumBorder` for buttons.
  static const double pill = 100;

  /// 999 — fully circular (avatars, indicators).
  static const double circle = 999;
}
