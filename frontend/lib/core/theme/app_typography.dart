import 'package:flutter/material.dart';

/// Font families reserved by the design system.
///
/// These names must match the `family` entries in `pubspec.yaml` under
/// `flutter/fonts` once font files are added to `assets/fonts/`.
///
/// Currently the families resolve to `null` and the platform default is
/// used. When fonts are added, set these to the registered family names
/// and the [AppTypography] builder picks them up everywhere.
///
/// The canonical source for font family names is [AppFonts] in
/// `core/assets/app_fonts.dart`. This class mirrors those values to
/// avoid circular imports between `core/theme/` and `core/assets/`.
abstract final class AppFontFamilies {
  /// Heading / display family (Plus Jakarta Sans).
  static const String heading = 'PlusJakartaSans';

  /// Body / UI family (Inter).
  static const String body = 'Inter';

  /// Code / monospace family (JetBrains Mono).
  static const String code = 'JetBrainsMono';
}

/// Static type-scale tokens — sizes, weights, line heights, letter spacing.
///
/// Keeping the raw values here means the [TextTheme] (and every style that
/// builds on it) derives from a single source of truth. Line heights are
/// generous to support long-form educational reading.
abstract final class AppTypeScale {
  // Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    height: 1.12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    height: 1.16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    height: 1.22,
    fontWeight: FontWeight.w400,
  );

  // Headline
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    height: 1.29,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w600,
  );

  // Title
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 1.45,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.50,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
}

/// Typography entry point.
///
/// [textTheme] builds a Material 3 compatible [TextTheme] from [AppTypeScale].
/// Semantic aliases ([AppTypography.display], [AppTypography.body], ...) give
/// screens a short, intention-revealing way to grab the default of each tier.
abstract final class AppTypography {
  /// Full Material 3 [TextTheme] with every role populated.
  static TextTheme textTheme() => const TextTheme(
    displayLarge: AppTypeScale.displayLarge,
    displayMedium: AppTypeScale.displayMedium,
    displaySmall: AppTypeScale.displaySmall,
    headlineLarge: AppTypeScale.headlineLarge,
    headlineMedium: AppTypeScale.headlineMedium,
    headlineSmall: AppTypeScale.headlineSmall,
    titleLarge: AppTypeScale.titleLarge,
    titleMedium: AppTypeScale.titleMedium,
    titleSmall: AppTypeScale.titleSmall,
    bodyLarge: AppTypeScale.bodyLarge,
    bodyMedium: AppTypeScale.bodyMedium,
    bodySmall: AppTypeScale.bodySmall,
    labelLarge: AppTypeScale.labelLarge,
    labelMedium: AppTypeScale.labelMedium,
    labelSmall: AppTypeScale.labelSmall,
  );

  /// Default display style (hero headings, lesson titles).
  static TextStyle get display => AppTypeScale.displayMedium;

  /// Default headline style (section titles, card headers).
  static TextStyle get headline => AppTypeScale.headlineMedium;

  /// Default title style (page titles, list titles).
  static TextStyle get title => AppTypeScale.titleLarge;

  /// Default body style (explanatory content, descriptions).
  static TextStyle get body => AppTypeScale.bodyLarge;

  /// Default label style (controls, metadata, input labels).
  static TextStyle get label => AppTypeScale.labelLarge;

  /// Default caption style (helper text, timestamps).
  static TextStyle get caption => AppTypeScale.caption;
}
