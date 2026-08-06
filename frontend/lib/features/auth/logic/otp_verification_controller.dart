import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_flow.dart';
import 'auth_validators.dart';

/// State for the verification-code step.
///
/// Owns the OTP slice of the flow: the entered code, verify loading, an inline
/// error that drives the shake animation, and the resend countdown. No backend
/// is involved — the controller sequences only UI state; a verification service
/// will later perform the real code check.
class OtpVerificationController extends ChangeNotifier {
  OtpVerificationController({
    this.length = 6,
    this.verifyDelay = const Duration(milliseconds: 600),
    this.resendDelay = AuthFlow.verificationTtl,
  });

  /// Number of digits in the code.
  final int length;

  /// How long verify is shown as busy before completing.
  final Duration verifyDelay;

  /// How long the user must wait before requesting a new code.
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

  /// Current aggregated code.
  String get code => _code;

  /// Whether the Verify action is running.
  bool get isVerifying => _isVerifying;

  /// Whether verification successfully completed.
  bool get isVerified => _isVerified;

  /// Latest inline error (also triggers the shake animation).
  String? get error => _error;

  /// Whether a new code may be requested right now.
  bool get canResend => _canResend;

  /// Seconds left before [resendDelay] elapses.
  int get secondsRemaining => _secondsRemaining;

  /// Bumped whenever [error] changes; the UI uses it to replay the shake.
  int get errorEpoch => _errorEpoch;

  /// Formats the countdown as `mm:ss`.
  String get countdownLabel {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Whether [error] is an editable validation issue (not a resend lock).
  bool get hasEditableError => _error != null;

  void updateCode(String value) {
    _code = value;
    if (_error != null) {
      _error = null;
      _notify();
    }
  }

  /// Starts or restarts the resend countdown.
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

  /// Requests a new code and restarts the countdown.
  void resend() {
    _error = null;
    startCountdown();
  }

  /// Runs the Verify transition.
  ///
  /// An incomplete or invalid code sets [error] and resolves to `false`;
  /// otherwise the verify action completes and resolves to `true`. No fake
  /// OTP — the code is not matched against anything.
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
