//**
// frontend/core/assets/app_illustrations.dart
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
abstract final class AppIllustrations {
  const AppIllustrations._();

  static const String emptyState =
      'assets/images/illustrations/empty_state.png';
  static const String emptyStateDark =
      'assets/images/illustrations/dark/empty_state.png';
  static const String emptyStateCompact =
      'assets/images/illustrations/empty_state_compact.png';

  static const String error = 'assets/images/illustrations/error.png';
  static const String errorDark = 'assets/images/illustrations/dark/error.png';
  static const String errorServer =
      'assets/images/illustrations/error_server.png';
  static const String errorConnection =
      'assets/images/illustrations/error_connection.png';

  static const String offline = 'assets/images/illustrations/offline.png';
  static const String offlineDark =
      'assets/images/illustrations/dark/offline.png';

  static const String maintenance =
      'assets/images/illustrations/maintenance.png';
  static const String maintenanceDark =
      'assets/images/illustrations/dark/maintenance.png';

  static const String notFound = 'assets/images/illustrations/not_found.png';
  static const String notFoundDark =
      'assets/images/illustrations/dark/not_found.png';

  static const String success = 'assets/images/illustrations/success.png';
  static const String successDark =
      'assets/images/illustrations/dark/success.png';

  static const String achievement =
      'assets/images/illustrations/achievement.png';
  static const String achievementDark =
      'assets/images/illustrations/dark/achievement.png';

  static const String learning = 'assets/images/illustrations/learning.png';
  static const String learningDark =
      'assets/images/illustrations/dark/learning.png';
  static const String reading = 'assets/images/illustrations/reading.png';
  static const String studying = 'assets/images/illustrations/studying.png';

  static const String onboarding1 = 'assets/icons/onboarding/onboarding1.svg';

  static const String onboarding2 = 'assets/icons/onboarding/onboarding2.svg';

  static const String onboarding3 = 'assets/icons/onboarding/onboarding3.svg';

  static const String onboardingWelcome =
      'assets/images/illustrations/onboarding_welcome.png';
  static const String onboardingExplore =
      'assets/images/illustrations/onboarding_explore.png';
  static const String onboardingLearn =
      'assets/images/illustrations/onboarding_learn.png';
  static const String onboardingAchieve =
      'assets/images/illustrations/onboarding_achieve.png';

  static const String profileEmpty =
      'assets/images/illustrations/profile_empty.png';

  static const String quizComplete =
      'assets/images/illustrations/quiz_complete.png';
  static const String quizEmpty = 'assets/images/illustrations/quiz_empty.png';

  static const String courseEmpty =
      'assets/images/illustrations/course_empty.png';
  static const String courseLocked =
      'assets/images/illustrations/course_locked.png';

  static const String maintenanceBanner =
      'assets/images/illustrations/maintenance_banner.png';
}
