import 'package:flutter/foundation.dart';

import 'auth_strings.dart';
import 'mock_auth_service.dart';

/// State for the "Continue with Google" slice of the auth screens.
///
/// Owns the loading flag that disables the action while a sign-in runs and
/// delegates the actual (mock) attempt to an [AuthGoogleService]. Screens stay
/// dumb: they render [isBusy] and translate the returned [AuthActionResult]
/// into user-facing feedback.
class GoogleAuthController extends ChangeNotifier {
  GoogleAuthController({AuthGoogleService service = const MockAuthService()})
    : _service = service; // ignore: prefer_initializing_formals

  final AuthGoogleService _service;

  bool _isBusy = false;
  bool _disposed = false;

  /// Whether a sign-in attempt is currently running.
  bool get isBusy => _isBusy;

  /// Starts a sign-in and resolves when the attempt finishes.
  ///
  /// Re-entrant calls while busy resolve as a failure instead of queueing, so
  /// the action can never be triggered twice.
  Future<AuthActionResult> signIn() async {
    if (_isBusy) {
      return const AuthActionResult.failure(
        AuthStrings.googleSignInAlreadyRunning,
      );
    }
    _isBusy = true;
    _notify();
    final result = await _service.signInWithGoogle();
    if (!_disposed) {
      _isBusy = false;
      _notify();
    }
    return result;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
