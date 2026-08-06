/// General image asset paths.
///
/// Screens reference `AppImages.hero` instead of
/// `'assets/images/hero.png'`. Adding a new image means adding one constant
/// here — no other file changes.
///
/// Asset files do not exist yet. Add them under `assets/images/` and the
/// constants resolve automatically.
abstract final class AppImages {
  const AppImages._();

  // -------------------------------------------------------------------------
  // Onboarding
  // -------------------------------------------------------------------------

  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';

  // -------------------------------------------------------------------------
  // Course
  // -------------------------------------------------------------------------

  static const String coursePlaceholder =
      'assets/images/course_placeholder.png';
  static const String lessonPlaceholder =
      'assets/images/lesson_placeholder.png';

  // -------------------------------------------------------------------------
  // Profile
  // -------------------------------------------------------------------------

  static const String avatarPlaceholder =
      'assets/images/avatar_placeholder.png';
  static const String profileBanner = 'assets/images/profile_banner.png';

  // -------------------------------------------------------------------------
  // Home / Hero
  // -------------------------------------------------------------------------

  static const String hero = 'assets/images/hero.png';
  static const String emptyDashboard = 'assets/images/empty_dashboard.png';

  // -------------------------------------------------------------------------
  // Misc
  // -------------------------------------------------------------------------

  static const String placeholder = 'assets/images/placeholder.png';
  static const String errorGeneric = 'assets/images/error_generic.png';
}
