//**
// frontend/core/assets/app_fonts.dart
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
abstract final class AppFonts {
  const AppFonts._();

  static const String heading = 'PlusJakartaSans';

  static const String body = 'Inter';

  static const String mono = 'JetBrainsMono';

  static const String display = heading;

  static const String fallback = '.SF Pro Display';

  static const List<String> allFamilies = [heading, body, mono];
}
