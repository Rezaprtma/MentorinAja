//**
// frontend/features/auth/logic/mock_auth_service.dart
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
import 'auth_strings.dart';

class AuthActionResult {
  const AuthActionResult.success() : isSuccess = true, error = null;

  const AuthActionResult.failure(this.error) : isSuccess = false;

  final bool isSuccess;

  final String? error;
}

abstract interface class AuthGoogleService {
  Future<AuthActionResult> signInWithGoogle({bool forceFailure = false});
}

class MockAuthService implements AuthGoogleService {
  const MockAuthService({this.latency = const Duration(milliseconds: 900)});

  final Duration latency;

  @override
  Future<AuthActionResult> signInWithGoogle({bool forceFailure = false}) async {
    await Future<void>.delayed(latency);
    if (forceFailure) {
      return const AuthActionResult.failure(AuthStrings.googleSignInError);
    }
    return const AuthActionResult.success();
  }
}
