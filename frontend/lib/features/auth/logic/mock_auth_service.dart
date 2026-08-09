import 'auth_strings.dart';

/// Outcome of a single authentication attempt.
///
/// Only what the frontend needs today: whether the attempt succeeded plus an
/// optional human-readable failure reason. A back-end contract will map into
/// this sealed value when the real service lands.
class AuthActionResult {
  const AuthActionResult.success() : isSuccess = true, error = null;

  const AuthActionResult.failure(this.error) : isSuccess = false;

  /// Whether the attempt resolved successfully.
  final bool isSuccess;

  /// Failure reason; `null` on success.
  final String? error;
}

/// Contract the authentication UI drives.
///
/// Every screen depends only on this seam, so swapping the mock for a real
/// OAuth/back-end implementation is a single dependency change.
abstract interface class AuthGoogleService {
  /// Signs the user in with Google.
  ///
  /// [forceFailure] lets UI flows exercise the error path deterministically.
  Future<AuthActionResult> signInWithGoogle({bool forceFailure = false});
}

/// Frontend-only stand-in for Google authentication.
///
/// No real OAuth happens: the flow reports loading, then resolves with a
/// simulated success (or forced error) after a short latency so every UI state
/// can be previewed before the backend exists.
///
/// TODO(backend): replace with the real Google OAuth / identity provider.
class MockAuthService implements AuthGoogleService {
  const MockAuthService({this.latency = const Duration(milliseconds: 900)});

  /// Simulated round-trip duration before the result resolves.
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
