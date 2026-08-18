//**
// frontend/core/theme/app_typography.dart
//
// frontend:
// Theme system. Menyediakan colors, typography, spacing, dan theme configuration.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi theme rendering di light/dark mode.
//**
import 'package:flutter/material.dart';

abstract final class AppFontFamilies {
  static const String heading = 'PlusJakartaSans';

  static const String body = 'Inter';

  static const String code = 'JetBrainsMono';
}

abstract final class AppTypeScale {
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

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.50,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static const TextStyle code = TextStyle(
    fontFamily: AppFontFamilies.code,
    fontSize: 13,
    height: 1.60,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );
}

abstract final class AppTypography {
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

  static TextStyle get display => AppTypeScale.displayMedium;

  static TextStyle get headline => AppTypeScale.headlineMedium;

  static TextStyle get title => AppTypeScale.titleLarge;

  static TextStyle get body => AppTypeScale.bodyLarge;

  static TextStyle get label => AppTypeScale.labelLarge;

  static TextStyle get caption => AppTypeScale.caption;
}
