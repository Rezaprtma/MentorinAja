/// Icon size scale for the MentorinAja design system.
///
/// Keeps icon rendering consistent across the app. The default Material icon
/// size is 24 ([AppIconSizes.lg]); use the smaller tiers for dense UI and the
/// larger tiers for empty states and feature highlights.
abstract final class AppIconSizes {
  /// 16 — inline metadata icons.
  static const double xs = 16;

  /// 18 — compact list trailing icons.
  static const double sm = 18;

  /// 20 — field and menu icons.
  static const double md = 20;

  /// 24 — default interactive icon size.
  static const double lg = 24;

  /// 28 — emphasized list or tab icons.
  static const double xl = 28;

  /// 32 — section headers and featured actions.
  static const double xxl = 32;

  /// 40 — empty-state illustrations in icon form.
  static const double xxxl = 40;

  /// 48 — hero or onboarding icons.
  static const double xxxxl = 48;
}
