/// Font family name registry.
///
/// Maps semantic font roles to their family names. These names must match
/// the `family` entries in `pubspec.yaml` under `flutter/fonts` once font
/// files are added to `assets/fonts/`.
///
/// Currently all families are `null` — the platform default font is used.
/// When fonts are added, set the family names here and the entire type scale
/// (via [AppTypography]) picks them up automatically.
abstract final class AppFonts {
  const AppFonts._();

  /// Primary heading / display font (Plus Jakarta Sans).
  ///
  /// Used for: display text, headlines, hero sections.
  /// Character: geometric, modern, confident.
  static const String heading = 'PlusJakartaSans';

  /// Body / UI font (Inter).
  ///
  /// Used for: body text, labels, buttons, input fields.
  /// Character: neutral, highly legible, excellent at small sizes.
  static const String body = 'Inter';

  /// Monospace / code font (JetBrains Mono).
  ///
  /// Used for: code blocks, technical content, debug info.
  /// Character: distinct ligatures, clear letter differentiation.
  static const String mono = 'JetBrainsMono';

  /// Display / decorative font for hero sections.
  ///
  /// Can be the same as [heading] or a distinct display face.
  static const String display = heading;

  /// Fallback font when the primary fonts are unavailable.
  static const String fallback = '.SF Pro Display';

  /// All registered font families for precaching.
  static const List<String> allFamilies = [heading, body, mono];
}
