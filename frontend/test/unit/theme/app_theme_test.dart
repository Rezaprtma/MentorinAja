import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/theme/theme.dart';

void main() {
  group('AppTheme', () {
    test('light() builds a Material 3 theme with the semantic extension', () {
      final theme = AppTheme.light();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.extension<AppThemeExtension>(), isNotNull);
      expect(theme.extension<AppThemeExtension>()!.success, AppColors.success);
      expect(theme.colorScheme.primary, AppColors.primary);
    });

    test('dark() builds a Material 3 theme with dark semantics', () {
      final theme = AppTheme.dark();

      expect(theme.brightness, Brightness.dark);
      expect(
        theme.extension<AppThemeExtension>()!.background,
        AppDarkColors.background,
      );
      expect(theme.colorScheme.surface, AppDarkColors.surface);
    });

    test('light() and dark() expose every M3 text role', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        expect(theme.textTheme.displayLarge, isNotNull);
        expect(theme.textTheme.displayMedium, isNotNull);
        expect(theme.textTheme.displaySmall, isNotNull);
        expect(theme.textTheme.headlineLarge, isNotNull);
        expect(theme.textTheme.headlineMedium, isNotNull);
        expect(theme.textTheme.headlineSmall, isNotNull);
        expect(theme.textTheme.titleLarge, isNotNull);
        expect(theme.textTheme.titleMedium, isNotNull);
        expect(theme.textTheme.titleSmall, isNotNull);
        expect(theme.textTheme.bodyLarge, isNotNull);
        expect(theme.textTheme.bodyMedium, isNotNull);
        expect(theme.textTheme.bodySmall, isNotNull);
        expect(theme.textTheme.labelLarge, isNotNull);
        expect(theme.textTheme.labelMedium, isNotNull);
        expect(theme.textTheme.labelSmall, isNotNull);
      }
    });

    test('fromColorScheme() honors a custom scheme and brightness', () {
      final scheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF123456),
        brightness: Brightness.light,
      );
      final theme = AppTheme.fromColorScheme(scheme);

      expect(theme.colorScheme, same(scheme));
      expect(theme.extension<AppThemeExtension>(), isNotNull);
    });

    test('dynamic() derives a scheme from a seed', () {
      for (final brightness in Brightness.values) {
        final theme = AppTheme.dynamic(brightness);
        expect(theme.brightness, brightness);
        expect(theme.extension<AppThemeExtension>(), isNotNull);
      }
    });
  });

  group('AppThemeExtension', () {
    test('copyWith() overrides only the supplied fields', () {
      final updated = AppThemeExtension.light.copyWith(
        success: AppColors.warning,
      );

      expect(updated.success, AppColors.warning);
      expect(updated.warning, AppColors.warning);
      expect(updated.background, AppColors.background);
    });

    test('lerp() interpolates between light and dark', () {
      final mid = AppThemeExtension.light.lerp(AppThemeExtension.dark, 0.5);

      expect(mid, isNotNull);
      expect(mid.background, isNot(AppThemeExtension.light.background));
      expect(mid.background, isNot(AppThemeExtension.dark.background));
    });
  });

  group('Design tokens', () {
    test('spacing scale is strictly increasing', () {
      const values = [
        AppSpacing.xxs,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ];
      for (var i = 1; i < values.length; i++) {
        expect(values[i], greaterThan(values[i - 1]));
      }
    });

    test('radius tokens are positive and ordered', () {
      expect(AppRadius.small, greaterThan(0));
      expect(AppRadius.large, greaterThan(AppRadius.medium));
      expect(AppRadius.extraLarge, greaterThan(AppRadius.large));
      expect(AppRadius.pill, greaterThan(AppRadius.extraLarge));
      expect(AppRadius.circle, greaterThan(AppRadius.pill));
    });

    test('icon sizes are positive and ordered', () {
      const sizes = [
        AppIconSizes.xs,
        AppIconSizes.sm,
        AppIconSizes.md,
        AppIconSizes.lg,
        AppIconSizes.xl,
        AppIconSizes.xxl,
        AppIconSizes.xxxl,
        AppIconSizes.xxxxl,
      ];
      for (var i = 1; i < sizes.length; i++) {
        expect(sizes[i], greaterThan(sizes[i - 1]));
      }
    });

    test('durations are positive', () {
      for (final duration in [
        AppDurations.fastest,
        AppDurations.fast,
        AppDurations.medium,
        AppDurations.slow,
        AppDurations.slower,
      ]) {
        expect(duration.inMilliseconds, greaterThan(0));
      }
    });

    test('semantic palettes are consistent for both brightness modes', () {
      const palettes = [AppThemeExtension.light, AppThemeExtension.dark];
      for (final palette in palettes) {
        expect(palette.success, isNotNull);
        expect(palette.onSuccess, isNotNull);
        expect(palette.warning, isNotNull);
        expect(palette.info, isNotNull);
        expect(palette.textPrimary, isNotNull);
        expect(palette.textSecondary, isNotNull);
        expect(palette.textDisabled, isNotNull);
        expect(palette.card, isNotNull);
        expect(palette.divider, isNotNull);
        expect(palette.border, isNotNull);
      }
    });
  });
}
