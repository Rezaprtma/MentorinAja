import 'package:flutter/material.dart';

/// Locale constants for MentorinAja.
///
/// Defines supported locales, fallback behavior, and locale-specific
/// configuration. No `flutter_localizations` package is installed yet —
/// this is pure data architecture ready for i18n integration.
abstract final class AppLocales {
  const AppLocales._();

  /// Default locale when no match is found.
  static const Locale fallback = Locale('id');

  /// All supported locales in priority order.
  static const List<Locale> supported = [
    Locale('id'), // Indonesian (primary)
    Locale('en'), // English
  ];

  /// Locale language codes for programmatic use.
  static const List<String> supportedCodes = ['id', 'en'];

  /// Human-readable locale names.
  static const Map<String, String> languageNames = {
    'id': 'Bahasa Indonesia',
    'en': 'English',
  };

  /// Locale flags (emoji) for language pickers.
  static const Map<String, String> languageFlags = {'id': '🇮🇩', 'en': '🇺🇸'};

  /// Whether a given locale is supported.
  static bool isSupported(Locale locale) {
    return supportedCodes.contains(locale.languageCode);
  }

  /// Resolves the best-match locale from a list of user-preferred locales.
  static Locale resolve(List<Locale> preferredLocales) {
    for (final preferred in preferredLocales) {
      for (final supported in AppLocales.supported) {
        if (preferred.languageCode == supported.languageCode) {
          return supported;
        }
      }
    }
    return fallback;
  }
}
