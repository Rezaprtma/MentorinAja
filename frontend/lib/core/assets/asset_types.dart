//**
// frontend/core/assets/asset_types.dart
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
library;

enum AssetImageFormat {
  png('png'),
  webp('webp'),
  jpeg('jpeg'),
  gif('gif'),
  bmp('bmp');

  const AssetImageFormat(this.extension);
  final String extension;
}

enum AssetAnimationFormat {
  rive('riv');

  const AssetAnimationFormat(this.extension);
  final String extension;
}

enum AssetAudioFormat {
  mp3('mp3'),
  wav('wav'),
  aac('aac'),
  ogg('ogg'),
  m4a('m4a');

  const AssetAudioFormat(this.extension);
  final String extension;
}

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

enum AudioCategory { sfx, music, voice, ambient, notification }

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
