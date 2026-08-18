//**
// frontend/features/splash/logic/splash_state.dart
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
enum SplashState {
  idle,

  initializing,

  waitingMinimumDuration,

  routing,

  completed,

  error,
}
