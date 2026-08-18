//**
// frontend/features/auth/logic/otp_verification_controller.dart
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
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_flow.dart';
import 'auth_validators.dart';

class OtpVerificationController extends ChangeNotifier {
  OtpVerificationController({
    this.length = 6,
    this.verifyDelay = const Duration(milliseconds: 600),
    this.resendDelay = AuthFlow.verificationTtl,
  });

  final int length;

  final Duration verifyDelay;

  final Duration resendDelay;

  String _code = '';
  bool _isVerifying = false;
  bool _isVerified = false;
  String? _error;
  int _secondsRemaining = 0;
  bool _canResend = false;
  Timer? _countdownTimer;
  bool _disposed = false;
  int _errorEpoch = 0;

  String get code => _code;

  bool get isVerifying => _isVerifying;

  bool get isVerified => _isVerified;

  String? get error => _error;

  bool get canResend => _canResend;

  int get secondsRemaining => _secondsRemaining;

  int get errorEpoch => _errorEpoch;

  String get countdownLabel {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get hasEditableError => _error != null;

  void updateCode(String value) {
    _code = value;
    if (_error != null) {
      _error = null;
      _notify();
    }
  }

  void startCountdown() {
    _countdownTimer?.cancel();
    _secondsRemaining = resendDelay.inSeconds;
    _canResend = false;
    _notify();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsRemaining -= 1;
      if (_secondsRemaining <= 0) {
        _countdownTimer?.cancel();
        _canResend = true;
      }
      _notify();
    });
  }

  void resend() {
    _error = null;
    startCountdown();
  }

  Future<bool> verify() async {
    final validationError = AuthValidators.otp(_code, expectedLength: length);
    if (validationError != null) {
      _error = validationError;
      _errorEpoch += 1;
      _notify();
      return false;
    }

    _error = null;
    _isVerifying = true;
    _notify();
    await Future<void>.delayed(verifyDelay);
    if (_disposed) return false;

    _isVerifying = false;
    _isVerified = true;
    _countdownTimer?.cancel();
    _notify();
    return true;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _countdownTimer?.cancel();
    super.dispose();
  }
}
