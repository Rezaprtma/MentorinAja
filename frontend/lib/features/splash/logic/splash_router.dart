//**
// frontend/features/splash/logic/splash_router.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'package:frontend/routing/route_names.dart';

abstract final class SplashRouter {
  const SplashRouter._();

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
