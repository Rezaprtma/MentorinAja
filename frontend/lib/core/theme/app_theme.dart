import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_elevation.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

/// Theme factory for the MentorinAja design system.
///
/// Every theme is Material 3, is built from the design tokens (never raw
/// values), and registers the semantic [AppThemeExtension] so the whole app
/// reads a consistent palette. The `fromColorScheme`/`dynamic` entry points
/// make the system ready for OS dynamic color without any package today.
abstract final class AppTheme {
  const AppTheme._();

  /// Light theme. Pass a custom [colorScheme] to override branding (used when
  /// a dynamic system palette is available).
  static ThemeData light({ColorScheme? colorScheme}) {
    final scheme = colorScheme ?? _buildLightColorScheme();
    return _build(scheme, AppThemeExtension.light);
  }

  /// Dark theme. Pass a custom [colorScheme] to override branding.
  static ThemeData dark({ColorScheme? colorScheme}) {
    final scheme = colorScheme ?? _buildDarkColorScheme();
    return _build(scheme, AppThemeExtension.dark);
  }

  /// Builds a theme from any [ColorScheme], deriving the semantic palette from
  /// [brightness]. This is the seam a future dynamic-color adapter uses to
  /// inject the platform's tonal palette.
  static ThemeData fromColorScheme(
    ColorScheme colorScheme, {
    AppThemeExtension? themeExtension,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return _build(
      colorScheme,
      themeExtension ??
          (isDark ? AppThemeExtension.dark : AppThemeExtension.light),
    );
  }

  /// Dynamic-color-ready theme derived from a seed.
  ///
  /// Without an OS dynamic-color package this is deterministic: pass a [seed]
  /// (defaults to the brand orange) and a Material 3 [DynamicSchemeVariant].
  static ThemeData dynamic(
    Brightness brightness, {
    Color seed = const Color(AppColors.seed),
    DynamicSchemeVariant variant = DynamicSchemeVariant.fidelity,
  }) {
    return fromColorScheme(
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
        dynamicSchemeVariant: variant,
      ),
    );
  }

  static ColorScheme _buildLightColorScheme() {
    return const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
    );
  }

  static ColorScheme _buildDarkColorScheme() {
    return const ColorScheme.dark(
      primary: AppDarkColors.primary,
      onPrimary: AppDarkColors.onPrimary,
      primaryContainer: AppDarkColors.primaryContainer,
      onPrimaryContainer: AppDarkColors.onPrimaryContainer,
      secondary: AppDarkColors.secondary,
      onSecondary: AppDarkColors.onSecondary,
      secondaryContainer: AppDarkColors.secondaryContainer,
      onSecondaryContainer: AppDarkColors.onSecondaryContainer,
      error: AppDarkColors.error,
      onError: AppDarkColors.onError,
      errorContainer: AppDarkColors.errorContainer,
      onErrorContainer: AppDarkColors.onErrorContainer,
      surface: AppDarkColors.surface,
      onSurface: AppDarkColors.onSurface,
      onSurfaceVariant: AppDarkColors.onSurfaceVariant,
      outline: AppDarkColors.outline,
      outlineVariant: AppDarkColors.outlineVariant,
      surfaceContainerLowest: AppDarkColors.surfaceContainerLowest,
      surfaceContainerLow: AppDarkColors.surfaceContainerLow,
      surfaceContainer: AppDarkColors.surfaceContainer,
      surfaceContainerHigh: AppDarkColors.surfaceContainerHigh,
      surfaceContainerHighest: AppDarkColors.surfaceContainerHighest,
    );
  }

  static ThemeData _build(ColorScheme scheme, AppThemeExtension extension) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: extension.background,
      fontFamily: AppFontFamilies.body,
      textTheme: AppTypography.textTheme().apply(
        bodyColor: extension.textPrimary,
        displayColor: extension.textPrimary,
      ),
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: extension.background,
        foregroundColor: extension.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.flat,
        scrolledUnderElevation: AppElevation.xs,
        centerTitle: false,
        titleTextStyle: AppTypeScale.titleLarge.copyWith(
          color: extension.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: extension.card,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.sm,
        shadowColor: Colors.black,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: extension.divider,
        thickness: 1,
        space: AppSpacing.md,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: AppSpacing.xs,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          textStyle: AppTypeScale.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: extension.card,
          foregroundColor: extension.textPrimary,
          elevation: AppElevation.sm,
          minimumSize: const Size.fromHeight(48),
          shape: StadiumBorder(side: BorderSide(color: extension.border)),
          textStyle: AppTypeScale.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: extension.border),
          shape: const StadiumBorder(),
          textStyle: AppTypeScale.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: AppTypeScale.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: extension.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppRadius.medium),
          ),
          borderSide: BorderSide(color: extension.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
          borderSide: BorderSide.none,
        ),
        labelStyle: AppTypeScale.bodyMedium.copyWith(
          color: extension.textSecondary,
        ),
        hintStyle: AppTypeScale.bodyMedium.copyWith(
          color: extension.textDisabled,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: extension.textPrimary,
        contentTextStyle: AppTypeScale.bodyMedium.copyWith(
          color: isDark ? AppDarkColors.onSurface : AppColors.onSurface,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: extension.card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.extraLarge)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: extension.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.extraLarge),
          ),
        ),
      ),
    );
  }
}
