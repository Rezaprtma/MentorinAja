/// Logo and brandmark asset paths.
///
/// Organized by use surface so screens pick the correct variant without
/// guessing. Every path is a compile-time constant — typos become errors.
///
/// The brand creates two SVG logomarks of the same mascot: a full-color
/// orange mark for light surfaces and a pale, monochrome mark for the brand
/// orange surface. Use [onLight] and [onBrand] instead of a raw asset path.
abstract final class AppLogo {
  const AppLogo._();

  // -------------------------------------------------------------------------
  // Brand logomark variants
  // -------------------------------------------------------------------------

  /// Full-color orange mark — for white and other light surfaces.
  static const String onLight = 'assets/icons/icon-w.svg';

  /// Pale monochrome mark — for brand and colored surfaces (indigo, orange).
  static const String onBrand = 'assets/icons/icon.svg';

  // -------------------------------------------------------------------------
  // Primary logo asset
  // -------------------------------------------------------------------------

  /// Legacy single-source logo constant; prefer [onLight]/[onBrand].
  static const String primary = 'assets/icons/icon.svg';

  // -------------------------------------------------------------------------
  // Splash
  // -------------------------------------------------------------------------

  /// Splash screen logo.
  static const String splash = 'assets/icons/icon.svg';
}
