//**
// frontend/core/assets/app_brand.dart
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
abstract final class AppBrand {
  const AppBrand._();

  static const String name = 'MentorinAja';

  static const String shortName = 'Mentorin';

  static const String tagline = 'Learn Without Limits';

  static const String bundleId = 'com.mentorin.aja';

  static const String supportEmail = 'support@mentorinaja.com';

  static const String website = 'https://mentorinaja.com';

  static const String instagram = '@mentorinaja';
  static const String twitter = '@mentorinaja';
  static const String youtube = 'MentorinAja';
}
