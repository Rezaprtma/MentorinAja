//**
// frontend/core/assets/app_translations.dart
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
abstract final class AppTranslations {
  const AppTranslations._();

  static const String _basePath = 'assets/translations';

  static const String indonesian = '$_basePath/id.arb';

  static const String english = '$_basePath/en.arb';

  static const Map<String, String> files = {'id': indonesian, 'en': english};

  static String forLanguage(String languageCode) {
    return files[languageCode] ?? indonesian;
  }
}
