//**
// frontend/core/assets/app_logo.dart
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
abstract final class AppLogo {
  const AppLogo._();

  static const String onLight = 'assets/icons/logo/icon-w.svg';

  static const String onBrand = 'assets/icons/logo/icon.svg';

  static const String primary = 'assets/icons/logo/icon.svg';

  static const String splash = 'assets/icons/logo/icon.svg';
}
