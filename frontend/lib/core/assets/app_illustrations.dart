/// Illustration asset paths organized by semantic category.
///
/// Each category maps to a specific user-facing context. Screens pick the
/// right illustration by category — never by raw path. Theme variants are
/// provided as separate constants; the `AssetExtensions` on `BuildContext`
/// selects the correct one automatically.
///
/// Asset files do not exist yet. Add them under
/// `assets/images/illustrations/` and the constants resolve automatically.
abstract final class AppIllustrations {
  const AppIllustrations._();

  // -------------------------------------------------------------------------
  // Empty state
  // -------------------------------------------------------------------------

  static const String emptyState =
      'assets/images/illustrations/empty_state.png';
  static const String emptyStateDark =
      'assets/images/illustrations/dark/empty_state.png';
  static const String emptyStateCompact =
      'assets/images/illustrations/empty_state_compact.png';

  // -------------------------------------------------------------------------
  // Error
  // -------------------------------------------------------------------------

  static const String error = 'assets/images/illustrations/error.png';
  static const String errorDark = 'assets/images/illustrations/dark/error.png';
  static const String errorServer =
      'assets/images/illustrations/error_server.png';
  static const String errorConnection =
      'assets/images/illustrations/error_connection.png';

  // -------------------------------------------------------------------------
  // Offline
  // -------------------------------------------------------------------------

  static const String offline = 'assets/images/illustrations/offline.png';
  static const String offlineDark =
      'assets/images/illustrations/dark/offline.png';

  // -------------------------------------------------------------------------
  // Maintenance
  // -------------------------------------------------------------------------

  static const String maintenance =
      'assets/images/illustrations/maintenance.png';
  static const String maintenanceDark =
      'assets/images/illustrations/dark/maintenance.png';

  // -------------------------------------------------------------------------
  // 404 / Not found
  // -------------------------------------------------------------------------

  static const String notFound = 'assets/images/illustrations/not_found.png';
  static const String notFoundDark =
      'assets/images/illustrations/dark/not_found.png';

  // -------------------------------------------------------------------------
  // Success
  // -------------------------------------------------------------------------

  static const String success = 'assets/images/illustrations/success.png';
  static const String successDark =
      'assets/images/illustrations/dark/success.png';

  // -------------------------------------------------------------------------
  // Achievement
  // -------------------------------------------------------------------------

  static const String achievement =
      'assets/images/illustrations/achievement.png';
  static const String achievementDark =
      'assets/images/illustrations/dark/achievement.png';

  // -------------------------------------------------------------------------
  // Learning
  // -------------------------------------------------------------------------

  static const String learning = 'assets/images/illustrations/learning.png';
  static const String learningDark =
      'assets/images/illustrations/dark/learning.png';
  static const String reading = 'assets/images/illustrations/reading.png';
  static const String studying = 'assets/images/illustrations/studying.png';

  // -------------------------------------------------------------------------
  // Onboarding
  // -------------------------------------------------------------------------

  /// First chapter artwork — discovery of personalized learning.
  static const String onboarding1 = 'assets/icons/onboarding1.svg';

  /// Second chapter artwork — adaptive learning pacing.
  static const String onboarding2 = 'assets/icons/onboarding2.svg';

  /// Third chapter artwork — starting the journey today.
  static const String onboarding3 = 'assets/icons/onboarding3.svg';

  static const String onboardingWelcome =
      'assets/images/illustrations/onboarding_welcome.png';
  static const String onboardingExplore =
      'assets/images/illustrations/onboarding_explore.png';
  static const String onboardingLearn =
      'assets/images/illustrations/onboarding_learn.png';
  static const String onboardingAchieve =
      'assets/images/illustrations/onboarding_achieve.png';

  // -------------------------------------------------------------------------
  // Profile
  // -------------------------------------------------------------------------

  static const String profileEmpty =
      'assets/images/illustrations/profile_empty.png';

  // -------------------------------------------------------------------------
  // Quiz
  // -------------------------------------------------------------------------

  static const String quizComplete =
      'assets/images/illustrations/quiz_complete.png';
  static const String quizEmpty = 'assets/images/illustrations/quiz_empty.png';

  // -------------------------------------------------------------------------
  // Course
  // -------------------------------------------------------------------------

  static const String courseEmpty =
      'assets/images/illustrations/course_empty.png';
  static const String courseLocked =
      'assets/images/illustrations/course_locked.png';

  // -------------------------------------------------------------------------
  // Maintenance banner
  // -------------------------------------------------------------------------

  static const String maintenanceBanner =
      'assets/images/illustrations/maintenance_banner.png';
}
