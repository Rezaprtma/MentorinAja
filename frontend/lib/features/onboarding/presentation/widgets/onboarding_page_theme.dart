//**
// frontend/features/onboarding/presentation/widgets/onboarding_page_theme.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/core/theme/theme.dart';

enum OnboardingChapter { discover, adapt, start }

abstract final class OnboardingColors {
  const OnboardingColors._();

  static const Color white = Color(0xFFFFFFFF);

  static const Color brand = AppColors.primary;

  static const Color indigo = AppColors.secondary;

  static const Color whiteMuted = Color(0xE6FFFFFF);

  static const Color whiteGhost = Color(0x66FFFFFF);

  static const Color neutral900 = Color(0xFF171717);

  static const Color neutral600 = Color(0xFF525252);

  static const Color neutral200 = Color(0xFFE5E5E5);
}

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

  final Color background;

  final String brandLogoPath;

  final Color accent;

  final Color indicatorInactive;

  final Color titleColor;

  final Color descriptionColor;

  final Color skipColor;

  final Color ctaBackground;

  final Color ctaForeground;

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

  static OnboardingPageTheme of(OnboardingChapter chapter) {
    return switch (chapter) {
      OnboardingChapter.discover => discover,
      OnboardingChapter.adapt => adapt,
      OnboardingChapter.start => start,
    };
  }
}
