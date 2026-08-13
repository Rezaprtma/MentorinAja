/// Defines the visual identity resolved per onboarding chapter.
library;

import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/core/theme/theme.dart';

/// The three onboarding chapters, each with its own color identity.
enum OnboardingChapter { discover, adapt, start }

/// Fixed color tokens for the onboarding endstate.
///
/// The three pages build a strong color progression — secondary indigo,
/// neutral white, then primary orange — so the flow never drifts in dark mode.
/// Values are compile-time constants and reference the design-system token
/// where it exposes the exact brand color.
abstract final class OnboardingColors {
  const OnboardingColors._();

  /// Neutral white surface for the adapt chapter.
  static const Color white = Color(0xFFFFFFFF);

  /// Primary brand orange for the start chapter.
  static const Color brand = AppColors.primary;

  /// Secondary brand indigo for the discover chapter.
  static const Color indigo = AppColors.secondary;

  /// White text that slightly recedes on colored surfaces.
  static const Color whiteMuted = Color(0xE6FFFFFF);

  /// White pagination used for inactive dots on colored surfaces.
  static const Color whiteGhost = Color(0x66FFFFFF);

  /// Dark neutral title on white surfaces.
  static const Color neutral900 = Color(0xFF171717);

  /// Muted neutral body text on white surfaces.
  static const Color neutral600 = Color(0xFF525252);

  /// Quiet neutral pagination dot on white surfaces.
  static const Color neutral200 = Color(0xFFE5E5E5);
}

/// Visual identity of a single onboarding chapter.
///
/// Each chapter owns a solid, clean background, the brand logo variant that
/// reads on it, text tones for that surface, pagination colors, and the colors
/// for its primary action. The palette is theme-independent so the flow looks
/// identical in light and dark mode.
@immutable
class OnboardingPageTheme {
  const OnboardingPageTheme({
    required this.background,
    required this.brandLogoPath,
    required this.accent,
    required this.indicatorInactive,
    required this.titleColor,
    required this.descriptionColor,
    required this.skipColor,
    required this.ctaBackground,
    required this.ctaForeground,
  });

  /// Page background color — indigo, white, or brand orange.
  final Color background;

  /// Brand logomark variant that stays legible on [background].
  final String brandLogoPath;

  /// Chapter accent used for the active pagination dot.
  final Color accent;

  /// Inactive pagination dot color.
  final Color indicatorInactive;

  /// Title text color.
  final Color titleColor;

  /// Description text color.
  final Color descriptionColor;

  /// "Skip" action color.
  final Color skipColor;

  /// Primary CTA background — the compact circle fills or the wide CTA fill.
  final Color ctaBackground;

  /// Primary CTA foreground — the compact circle icon or the wide CTA text.
  final Color ctaForeground;

  /// Indigo chapter — white mark, white compact CTA with an indigo arrow.
  static const OnboardingPageTheme discover = OnboardingPageTheme(
    background: OnboardingColors.indigo,
    brandLogoPath: AppLogo.onBrand,
    accent: Colors.white,
    indicatorInactive: OnboardingColors.whiteGhost,
    titleColor: Colors.white,
    descriptionColor: OnboardingColors.whiteMuted,
    skipColor: Colors.white,
    ctaBackground: Colors.white,
    ctaForeground: OnboardingColors.indigo,
  );

  /// White chapter — orange mark, indigo compact CTA with a white arrow.
  static const OnboardingPageTheme adapt = OnboardingPageTheme(
    background: OnboardingColors.white,
    brandLogoPath: AppLogo.onLight,
    accent: OnboardingColors.indigo,
    indicatorInactive: OnboardingColors.neutral200,
    titleColor: OnboardingColors.neutral900,
    descriptionColor: OnboardingColors.neutral600,
    skipColor: OnboardingColors.neutral600,
    ctaBackground: OnboardingColors.indigo,
    ctaForeground: Colors.white,
  );

  /// Orange action chapter — pale mark, wide white CTA with dark-orange text.
  static const OnboardingPageTheme start = OnboardingPageTheme(
    background: OnboardingColors.brand,
    brandLogoPath: AppLogo.onBrand,
    accent: Colors.white,
    indicatorInactive: OnboardingColors.whiteGhost,
    titleColor: Colors.white,
    descriptionColor: OnboardingColors.whiteMuted,
    skipColor: Colors.white,
    ctaBackground: Colors.white,
    ctaForeground: AppColors.primaryPressed,
  );

  /// Resolves the preset theme for a [chapter].
  static OnboardingPageTheme of(OnboardingChapter chapter) {
    return switch (chapter) {
      OnboardingChapter.discover => discover,
      OnboardingChapter.adapt => adapt,
      OnboardingChapter.start => start,
    };
  }
}
