//**
// frontend/features/auth/logic/google_auth_controller.dart
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
import 'package:flutter/foundation.dart';

import 'auth_strings.dart';
import 'mock_auth_service.dart';

class GoogleAuthController extends ChangeNotifier {
  GoogleAuthController({AuthGoogleService service = const MockAuthService()})
    : _service = service;

  final AuthGoogleService _service;

  bool _isBusy = false;
  bool _disposed = false;

  bool get isBusy => _isBusy;

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
