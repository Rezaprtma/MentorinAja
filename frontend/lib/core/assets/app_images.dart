//**
// frontend/core/assets/app_images.dart
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
abstract final class AppImages {
  const AppImages._();

  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';

  static const String coursePlaceholder =
      'assets/images/course_placeholder.png';
  static const String lessonPlaceholder =
      'assets/images/lesson_placeholder.png';

  static const String avatarPlaceholder =
      'assets/images/avatar_placeholder.png';
  static const String profileBanner = 'assets/images/profile_banner.png';

  static const String hero = 'assets/images/hero.png';
  static const String emptyDashboard = 'assets/images/empty_dashboard.png';

  static const String placeholder = 'assets/images/placeholder.png';
  static const String errorGeneric = 'assets/images/error_generic.png';
}
