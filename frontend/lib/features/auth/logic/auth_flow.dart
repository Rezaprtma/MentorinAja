import 'package:frontend/routing/route_names.dart';

/// Pure navigation constants for the passwordless authentication flow.
///
/// Encapsulates the single-entry-to-OTP flow shared by Create Account and
/// Sign In. The backend decides whether an account is new or returning later;
/// the frontend only sequences the shared steps (email/username → OTP → Home).
abstract final class AuthFlow {
  const AuthFlow._();

  /// How long a sent verification code stays valid before resend unlocks.
  static const Duration verificationTtl = Duration(seconds: 60);

  /// Destination after a valid email: the verification-code step.
  static const String verifyStep = AppRoutes.otpVerification;
}
