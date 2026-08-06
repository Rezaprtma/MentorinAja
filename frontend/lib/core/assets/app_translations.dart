/// Translation file asset paths.
///
/// Maps locale codes to their ARB (Application Resource Bundle) file paths.
/// When `flutter_localizations` or `intl` is added, these paths feed the
/// localization loader.
///
/// Asset files do not exist yet. Add ARB files under `assets/translations/`
/// and the constants resolve automatically.
abstract final class AppTranslations {
  const AppTranslations._();

  /// Base path for all translation files.
  static const String _basePath = 'assets/translations';

  /// ARB file for Indonesian (primary).
  static const String indonesian = '$_basePath/id.arb';

  /// ARB file for English.
  static const String english = '$_basePath/en.arb';

  /// Maps locale language code to its ARB file path.
  static const Map<String, String> files = {'id': indonesian, 'en': english};

  /// Returns the ARB file path for a given language code.
  ///
  /// Falls back to [indonesian] if the code is not found.
  static String forLanguage(String languageCode) {
    return files[languageCode] ?? indonesian;
  }
}
