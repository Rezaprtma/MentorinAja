/// Brand identity constants for MentorinAja.
///
/// Every brand-facing string lives here. Screens reference these constants
/// instead of hardcoding the app name, tagline, or other identity text.
/// When the brand evolves, only this file changes.
abstract final class AppBrand {
  const AppBrand._();

  /// Product name as displayed to users.
  static const String name = 'MentorinAja';

  /// Short name for compact UI (e.g. nav bar, about screen).
  static const String shortName = 'Mentorin';

  /// Tagline or slogan.
  static const String tagline = 'Learn Without Limits';

  /// App Store / Play Store package identifier.
  static const String bundleId = 'com.mentorin.aja';

  /// Support email.
  static const String supportEmail = 'support@mentorinaja.com';

  /// Website URL.
  static const String website = 'https://mentorinaja.com';

  /// Social media handles.
  static const String instagram = '@mentorinaja';
  static const String twitter = '@mentorinaja';
  static const String youtube = 'MentorinAja';
}
