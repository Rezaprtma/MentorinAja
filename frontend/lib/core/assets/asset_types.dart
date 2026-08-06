/// Asset type definitions for MentorinAja.
///
/// Enums and types used across the asset system. Keeping them in one file
/// ensures consistent vocabulary and prevents duplicate enum definitions.
library;

/// Supported raster image formats.
enum AssetImageFormat {
  png('png'),
  webp('webp'),
  jpeg('jpeg'),
  gif('gif'),
  bmp('bmp');

  const AssetImageFormat(this.extension);
  final String extension;
}

/// Animation source format.
enum AssetAnimationFormat {
  lottie('json'),
  rive('riv');

  const AssetAnimationFormat(this.extension);
  final String extension;
}

/// Audio file format.
enum AssetAudioFormat {
  mp3('mp3'),
  wav('wav'),
  aac('aac'),
  ogg('ogg'),
  m4a('m4a');

  const AssetAudioFormat(this.extension);
  final String extension;
}

/// Categories for illustrations. Each category maps to a specific user-facing
/// context so screens pick the correct illustration without hardcoding paths.
enum IllustrationCategory {
  emptyState,
  error,
  offline,
  maintenance,
  notFound,
  success,
  achievement,
  learning,
  onboarding,
  profile,
  course,
  quiz,
}

/// Audio usage categories for future audio routing and volume control.
enum AudioCategory { sfx, music, voice, ambient, notification }

/// Semantic size presets for icons that need platform-adaptive sizing.
enum AppIconSize {
  xs(16),
  sm(20),
  md(24),
  lg(32),
  xl(40),
  xxl(48),
  xxxl(64);

  const AppIconSize(this.size);
  final double size;
}
