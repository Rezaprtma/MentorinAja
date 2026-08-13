/// Bottom-sheet builders for the Profile tab.
///
/// [showThemeSheet] hosts the color-mode picker driven by
/// [ThemeModeController], and [showAboutSheet] presents lightweight product
/// information. Both are thin helpers that reuse [AppBottomSheet] and the
/// design-system radio/list components without carrying page state.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Displays the theme selection sheet and applies the chosen mode.
///
/// The sheet observes [ThemeModeController.instance] so the checkmarks track
/// the active mode live, then records new choices through the same controller.
Future<void> showThemeSheet(BuildContext context) {
  return AppBottomSheet.show(
    context,
    title: 'Tema',
    child: AnimatedBuilder(
      animation: ThemeModeController.instance,
      builder: (context, _) {
        final mode = ThemeModeController.instance.mode;
        return AppRadioGroup<String>(
          groupValue: _themeValue(mode),
          onChanged: (value) {
            if (value != null) {
              ThemeModeController.instance.setMode(_themeMode(value));
            }
          },
          options: const [
            AppRadioOption(value: 'light', label: 'Terang'),
            AppRadioOption(value: 'dark', label: 'Gelap'),
            AppRadioOption(value: 'system', label: 'Ikuti Sistem'),
          ],
        );
      },
    ),
  );
}

/// Displays the product information sheet.
Future<void> showAboutSheet(BuildContext context) {
  final ext = context.appColors;

  return AppBottomSheet.show(
    context,
    title: 'Tentang MentorinAja',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.school_rounded,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'MentorinAja',
          style: AppTypeScale.titleLarge.copyWith(color: ext.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Versi 1.0.0',
          style: AppTypeScale.bodySmall.copyWith(color: ext.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Platform pembelajaran Indonesia dengan dukungan mentor dan AI.',
          textAlign: TextAlign.center,
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
      ],
    ),
  );
}

/// Renders the Indonesian label for the active [ThemeMode].
///
/// Shared by the theme sheet and the Preferensi row so a single source keeps
/// the picker and the page's current-value label in sync.
String themeModeLabel(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'Terang',
  ThemeMode.dark => 'Gelap',
  ThemeMode.system => 'Ikuti Sistem',
};

String _themeValue(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
  ThemeMode.system => 'system',
};

ThemeMode _themeMode(String value) => switch (value) {
  'light' => ThemeMode.light,
  'dark' => ThemeMode.dark,
  _ => ThemeMode.system,
};
