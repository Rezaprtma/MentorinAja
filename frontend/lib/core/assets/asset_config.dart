//**
// frontend/core/assets/asset_config.dart
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
import 'app_fonts.dart';
import 'app_locales.dart';

abstract final class AssetConfig {
  const AssetConfig._();

  static const int maxImageCacheSize = 100;

  static const int maxImageCacheBytes = 100 * 1024 * 1024;

  static const List<String> precacheOnStartup = [];

  static const List<String> precacheAfterAuth = [];

  static const List<String> precacheFonts = AppFonts.allFamilies;

  static const int maxAudioPlayers = 5;

  static const double defaultSfxVolume = 0.8;

  static const double defaultMusicVolume = 0.5;

  static const Duration networkImageTimeout = Duration(seconds: 15);

  static const int maxConcurrentDownloads = 6;

  static const String defaultLocale = 'id';

  static const List<String> supportedLocales = AppLocales.supportedCodes;
}
