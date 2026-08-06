import 'package:frontend/routing/route_names.dart';

/// Pure navigation logic for the splash screen.
///
/// Determines the destination route based on:
/// - First launch status
/// - Authentication status
///
/// This class has no Flutter dependencies (no BuildContext, no Navigator).
/// It returns a route string that the controller uses to trigger navigation.
///
/// ```dart
/// final destination = SplashRouter.determineDestination(
///   isFirstLaunch: true,
///   isAuthenticated: false,
/// );
/// // Returns AppRoutes.onboarding
/// ```
abstract final class SplashRouter {
  const SplashRouter._();

  /// Determines the navigation destination after splash.
  ///
  /// Logic:
  /// ```text
  /// if isFirstLaunch → /onboarding
  /// else if isAuthenticated → /home
  /// else → /authentication
  /// ```
  ///
  /// Returns a route path from [AppRoutes].
  static String determineDestination({
    required bool isFirstLaunch,
    required bool isAuthenticated,
  }) {
    if (isFirstLaunch) {
      return AppRoutes.onboarding;
    }

    if (isAuthenticated) {
      return AppRoutes.home;
    }

    return AppRoutes.authentication;
  }
}
