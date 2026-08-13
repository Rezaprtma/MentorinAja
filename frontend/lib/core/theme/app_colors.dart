import 'package:flutter/painting.dart';

/// Raw color palette for the MentorinAja design system.
///
/// This file is the **single source of truth** for color hex values in the
/// light theme. Components and screens must never hardcode colors; they should
/// reference the Material 3 [ColorScheme], an [AppThemeExtension] semantic
/// token, or these palette constants.
///
/// Light mode follows the brand direction in
/// `docs/design/brandidentity.md`: an energetic orange primary on calm, warm
/// neutrals.
abstract final class AppColors {
  /// Seed used to derive dynamic Material 3 tonal palettes.
  static const int seed = 0xFFF97316;

  // -------------------------------------------------------------------------
  // Brand
  // -------------------------------------------------------------------------

  /// Primary call-to-action, active highlights, progress.
  static const Color primary = Color(0xFFF97316);

  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Soft primary tint: selected states, user chat bubbles, highlighted cards.
  static const Color primaryContainer = Color(0xFFFFF7ED);

  static const Color onPrimaryContainer = Color(0xFF7A2E00);

  /// Primary hover state.
  static const Color primaryHover = Color(0xFFEA580C);

  /// Primary pressed state.
  static const Color primaryPressed = Color(0xFFC2410C);

  /// Primary subtle tint used on pale brand surfaces.
  static const Color primarySubtle = Color(0xFFFFFBF7);

  // -------------------------------------------------------------------------
  // Secondary (indigo)
  // -------------------------------------------------------------------------

  static const Color secondary = Color(0xFF514AF8);

  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color secondaryContainer = Color(0xFFEEEDFF);

  static const Color onSecondaryContainer = Color(0xFF3730A3);

  /// Secondary hover state.
  static const Color secondaryHover = Color(0xFF4338CA);

  /// Secondary pressed state.
  static const Color secondaryPressed = Color(0xFF3730A3);

  /// Subtle tint used on secondary isolated surfaces.
  static const Color secondarySubtle = Color(0xFFF5F3FF);

  // -------------------------------------------------------------------------
  // Semantic
  // -------------------------------------------------------------------------

  /// Correct answers, completion states.
  static const Color success = Color(0xFF17B26A);

  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color successContainer = Color(0xFFD8F6E6);

  static const Color onSuccessContainer = Color(0xFF0A5C36);

  /// Caution and review prompts.
  static const Color warning = Color(0xFFF79009);

  static const Color onWarning = Color(0xFFFFFFFF);

  static const Color warningContainer = Color(0xFFFDEBD0);

  static const Color onWarningContainer = Color(0xFF7A4400);

  /// Failure and destructive states.
  static const Color error = Color(0xFFF04438);

  static const Color onError = Color(0xFFFFFFFF);

  static const Color errorContainer = Color(0xFFFDE3E1);

  static const Color onErrorContainer = Color(0xFF7A1711);

  /// Informational accents and guidance.
  static const Color info = Color(0xFF2E90FA);

  static const Color onInfo = Color(0xFFFFFFFF);

  static const Color infoContainer = Color(0xFFD6EAFF);

  static const Color onInfoContainer = Color(0xFF0B4C85);

  // -------------------------------------------------------------------------
  // Neutral / surface
  // -------------------------------------------------------------------------

  /// App background — slightly off-white to reduce glare.
  static const Color background = Color(0xFFFCFDFD);
  static const Color onBackground = Color(0xFF1D2939);

  /// Elevated surfaces such as cards and sheets.
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1D2939);

  /// Explicit "card" surface, kept distinct from page [background].
  static const Color card = Color(0xFFFFFFFF);
  static const Color onCard = Color(0xFF1D2939);

  static const Color surfaceVariant = Color(0xFFF2F4F7);
  static const Color onSurfaceVariant = Color(0xFF667085);

  // Material 3 surface-container tones (used by nav bars, fields, dialogs).
  static const Color surfaceContainerLowest = Color(0xFFFCFDFD);
  static const Color surfaceContainerLow = Color(0xFFF6F8F9);
  static const Color surfaceContainer = Color(0xFFEFF2F4);
  static const Color surfaceContainerHigh = Color(0xFFE9ECEF);
  static const Color surfaceContainerHighest = Color(0xFFE4E7EB);

  // -------------------------------------------------------------------------
  // Outline
  // -------------------------------------------------------------------------

  /// Hairline borders and dividers (soft, minimal).
  static const Color border = Color(0xFFEAECF0);
  static const Color divider = Color(0xFFEAECF0);

  /// Structural outline for InputDecorator and emphasized edges.
  static const Color outline = Color(0xFFD0D5DD);
  static const Color outlineVariant = Color(0xFFEAECF0);

  // -------------------------------------------------------------------------
  // Text
  // -------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF1D2939);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textDisabled = Color(0xFF98A2B3);
}

/// Raw color palette for dark mode.
///
/// Dark surfaces use a warm, near-black neutral so long reading sessions do not
/// feel harsh. Brand accents shift to lighter tints for contrast on dark
/// backgrounds. Consumers should never hardcode these values; reference the
/// dark [ColorScheme] or [AppThemeExtension] instead.
abstract final class AppDarkColors {
  /// Seed used to derive dynamic Material 3 tonal palettes.
  static const int seed = 0xFFFF9A5F;

  static const Color primary = Color(0xFFFF9A5F);
  static const Color onPrimary = Color(0xFF3B1E00);
  static const Color primaryContainer = Color(0xFF5B2E08);
  static const Color onPrimaryContainer = Color(0xFFFFDBC6);

  static const Color secondary = Color(0xFF9B9DFF);
  static const Color onSecondary = Color(0xFF13166F);
  static const Color secondaryContainer = Color(0xFF3B3F9E);
  static const Color onSecondaryContainer = Color(0xFFE1E2FF);

  static const Color success = Color(0xFF47D16C);
  static const Color onSuccess = Color(0xFF003D1F);
  static const Color successContainer = Color(0xFF0A5C36);
  static const Color onSuccessContainer = Color(0xFFB5F3CC);

  static const Color warning = Color(0xFFFFC24B);
  static const Color onWarning = Color(0xFF5C4000);
  static const Color warningContainer = Color(0xFF7A4400);
  static const Color onWarningContainer = Color(0xFFFFE4B0);

  static const Color error = Color(0xFFF97066);
  static const Color onError = Color(0xFF5C1711);
  static const Color errorContainer = Color(0xFF7A1711);
  static const Color onErrorContainer = Color(0xFFFFD9D6);

  static const Color info = Color(0xFF7CB8FF);
  static const Color onInfo = Color(0xFF003055);
  static const Color infoContainer = Color(0xFF0B4C85);
  static const Color onInfoContainer = Color(0xFFD3E6FF);

  static const Color background = Color(0xFF101214);
  static const Color onBackground = Color(0xFFE7EAEE);

  static const Color surface = Color(0xFF17191D);
  static const Color onSurface = Color(0xFFE7EAEE);

  static const Color card = Color(0xFF1D2126);
  static const Color onCard = Color(0xFFE7EAEE);

  static const Color surfaceVariant = Color(0xFF2E3238);
  static const Color onSurfaceVariant = Color(0xFFB0B7C3);

  static const Color surfaceContainerLowest = Color(0xFF0C0E10);
  static const Color surfaceContainerLow = Color(0xFF17191D);
  static const Color surfaceContainer = Color(0xFF1B1E23);
  static const Color surfaceContainerHigh = Color(0xFF22262C);
  static const Color surfaceContainerHighest = Color(0xFF2A2F36);

  static const Color border = Color(0xFF33383F);
  static const Color divider = Color(0xFF2B3036);
  static const Color outline = Color(0xFF565D66);
  static const Color outlineVariant = Color(0xFF33383F);

  static const Color textPrimary = Color(0xFFEDEFF2);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color textDisabled = Color(0xFF6F7782);
}
