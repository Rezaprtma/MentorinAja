/// Animation asset paths.
///
/// Supports Lottie (JSON) and Rive (RIV) formats. Each constant points to
/// a single animation file. Wrapper widgets (`AppLottie`, `AppRive`) handle
/// playback.
///
/// Asset files do not exist yet. Add them under `assets/animations/` and
/// the constants resolve automatically.
abstract final class AppAnimations {
  const AppAnimations._();

  // -------------------------------------------------------------------------
  // Loading
  // -------------------------------------------------------------------------

  /// Default loading spinner (Lottie).
  static const String loadingDots = 'assets/animations/loading_dots.json';

  /// Skeleton shimmer effect (Lottie).
  static const String shimmer = 'assets/animations/shimmer.json';

  /// Progress bar animation (Lottie).
  static const String progress = 'assets/animations/progress.json';

  /// Circular loader (Lottie).
  static const String circularLoader = 'assets/animations/circular_loader.json';

  // -------------------------------------------------------------------------
  // Success
  // -------------------------------------------------------------------------

  /// Checkmark success animation (Lottie).
  static const String successCheck = 'assets/animations/success_check.json';

  /// Confetti celebration (Lottie).
  static const String confetti = 'assets/animations/confetti.json';

  /// Achievement unlocked (Rive).
  static const String achievementUnlock =
      'assets/animations/achievement_unlock.riv';

  // -------------------------------------------------------------------------
  // Empty state
  // -------------------------------------------------------------------------

  /// Empty box animation (Lottie).
  static const String emptyBox = 'assets/animations/empty_box.json';

  /// Search not found (Lottie).
  static const String searchEmpty = 'assets/animations/search_empty.json';

  // -------------------------------------------------------------------------
  // Error
  // -------------------------------------------------------------------------

  /// Connection error (Lottie).
  static const String connectionError =
      'assets/animations/connection_error.json';

  /// Server error (Lottie).
  static const String serverError = 'assets/animations/server_error.json';

  // -------------------------------------------------------------------------
  // Onboarding
  // -------------------------------------------------------------------------

  /// Welcome animation (Lottie).
  static const String onboardingWelcome = 'assets/animations/Onboarding1.json';

  /// Explore animation (Lottie).
  static const String onboardingExplore = 'assets/animations/Onboarding2.json';

  /// Learn animation (Lottie).
  static const String onboardingLearn = 'assets/animations/Onboarding3.json';

  // -------------------------------------------------------------------------
  // Authentication
  // -------------------------------------------------------------------------

  /// Welcome hero used on the Authentication landing (Lottie).
  static const String authWelcome = 'assets/animations/Auth.json';

  // -------------------------------------------------------------------------
  // Micro-interactions
  // -------------------------------------------------------------------------

  /// Button press feedback (Lottie).
  static const String buttonPress = 'assets/animations/button_press.json';

  /// Like animation (Lottie).
  static const String likeAnim = 'assets/animations/like_anim.json';

  /// Bookmark saved (Lottie).
  static const String bookmarkSaved = 'assets/animations/bookmark_saved.json';

  /// Streak fire (Rive).
  static const String streakFire = 'assets/animations/streak_fire.riv';

  // -------------------------------------------------------------------------
  // Ambient
  // -------------------------------------------------------------------------

  /// Subtle background animation for splash/loading screens (Rive).
  static const String ambientGradient =
      'assets/animations/ambient_gradient.riv';
}
