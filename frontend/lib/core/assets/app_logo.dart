/// Logo and brandmark asset paths.
///
/// Organized by use-case so screens pick the correct variant without
/// guessing. Every path is a compile-time constant — typos become errors.
///
/// The primary logo asset is `assets/icons/icon.png` — the only logo
/// file that should ever be used. If this asset is missing or invalid,
/// the splash screen fails gracefully with a reported error.
abstract final class AppLogo {
  const AppLogo._();

  // -------------------------------------------------------------------------
  // Primary logo (the only logo asset)
  // -------------------------------------------------------------------------

  /// MentorinAja logo — the single source of truth for all logo display.
  ///
  /// Asset path: `assets/icons/icon.png`
  /// This is the only logo file in the project.
  /// Do not create placeholder or generated variants of this asset.
  static const String primary = 'assets/icons/icon.png';

  // -------------------------------------------------------------------------
  // Splash
  // -------------------------------------------------------------------------

  /// Splash screen logo — resolves to [primary].
  ///
  /// The splash screen displays this asset centered with the brand name.
  /// If this asset cannot be decoded, the splash reports the error and
  /// stops rather than fabricating a replacement.
  static const String splash = 'assets/icons/icon.png';
}
