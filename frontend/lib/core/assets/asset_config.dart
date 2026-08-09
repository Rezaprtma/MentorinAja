import 'app_fonts.dart';
import 'app_locales.dart';

/// Asset loading configuration.
///
/// Centralizes caching strategy, precache lists, and performance tuning
/// constants. Screens and services consume this instead of hardcoding
/// cache sizes or precache lists.
abstract final class AssetConfig {
  const AssetConfig._();

  // -------------------------------------------------------------------------
  // Image cache
  // -------------------------------------------------------------------------

  /// Maximum number of images to keep in the in-memory cache.
  static const int maxImageCacheSize = 100;

  /// Maximum bytes for the image cache (default ~100 MB).
  static const int maxImageCacheBytes = 100 * 1024 * 1024;

  // -------------------------------------------------------------------------
  // Precache lists
  // -------------------------------------------------------------------------

  /// Assets to precache at app startup (splash screen assets).
  static const List<String> precacheOnStartup = [
    // Brand / splash — uncomment when assets exist:
    // AppLogo.splash,
    // AppLogo.primary,
  ];

  /// Assets to precache after login (frequently accessed).
  static const List<String> precacheAfterAuth = [
    // Profile, home icons — uncomment when assets exist:
    // AppImages.avatarPlaceholder,
    // AppIconPaths.home,
    // AppIconPaths.profile,
  ];

  /// Font families to preload.
  static const List<String> precacheFonts = AppFonts.allFamilies;

  // -------------------------------------------------------------------------
  // Audio
  // -------------------------------------------------------------------------

  /// Maximum number of audio players to keep in the pool.
  static const int maxAudioPlayers = 5;

  /// Default volume for sound effects (0.0 – 1.0).
  static const double defaultSfxVolume = 0.8;

  /// Default volume for background music (0.0 – 1.0).
  static const double defaultMusicVolume = 0.5;

  // -------------------------------------------------------------------------
  // Network images
  // -------------------------------------------------------------------------

  /// Timeout for fetching a network image.
  static const Duration networkImageTimeout = Duration(seconds: 15);

  /// Maximum number of concurrent network image downloads.
  static const int maxConcurrentDownloads = 6;

  // -------------------------------------------------------------------------
  // Localization
  // -------------------------------------------------------------------------

  /// The default locale used when no match is found.
  static const String defaultLocale = 'id';

  /// Supported locale codes.
  static const List<String> supportedLocales = AppLocales.supportedCodes;
}
