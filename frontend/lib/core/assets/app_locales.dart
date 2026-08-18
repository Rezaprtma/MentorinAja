//**
// frontend/core/assets/app_locales.dart
//
// frontend:
// Asset management. Menyediakan paths dan konfigurasi untuk icons, images, fonts.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi asset loading dan rendering.
//**
import 'package:flutter/material.dart';

abstract final class AppLocales {
  const AppLocales._();

  static const Locale fallback = Locale('id');

  static const List<Locale> supported = [Locale('id'), Locale('en')];

  static const List<String> supportedCodes = ['id', 'en'];

  static const Map<String, String> languageNames = {
    'id': 'Bahasa Indonesia',
    'en': 'English',
  };

  static const Map<String, String> languageFlags = {'id': '🇮🇩', 'en': '🇺🇸'};

  static bool isSupported(Locale locale) {
    return supportedCodes.contains(locale.languageCode);
  }

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
