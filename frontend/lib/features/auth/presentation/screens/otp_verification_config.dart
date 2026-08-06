import 'package:flutter/services.dart';

import 'package:frontend/routing/route_names.dart';

import '../../logic/auth_strings.dart';

/// Presentation and routing configuration for the reusable OTP screen.
///
/// Keeps the screen generic: the auth flow uses the defaults today, and future
/// code requests (email change, phone verification, sensitive actions) reuse
/// the screen with their own copy, code length and destination.
class OtpVerificationConfig {
  const OtpVerificationConfig({
    this.title = AuthStrings.otpTitle,
    this.subtitle = AuthStrings.otpSubtitle,
    this.buttonLabel = AuthStrings.otpVerifyButton,
    this.resendButtonLabel = AuthStrings.otpResendButton,
    this.successMessage = AuthStrings.otpSuccess,
    this.length = 6,
    this.autofocus = true,
    this.autofillHints = const [AutofillHints.oneTimeCode],
    this.destination = AppRoutes.home,
  });

  /// Heading shown above the code boxes.
  final String title;

  /// Guidance text describing where the code was sent.
  final String subtitle;

  /// Verify action label.
  final String buttonLabel;

  /// Label for the "request again" action.
  final String resendButtonLabel;

  /// Confirmation message shown after a successful code.
  final String successMessage;

  /// Number of digits expected in the code.
  final int length;

  /// Whether the first box grabs focus on open.
  final bool autofocus;

  /// Autofill hints attached to the code input (e.g. OTP).
  final List<String> autofillHints;

  /// Destination reached after a successful verification.
  ///
  /// The auth flow routes every verified code to Home; the backend later
  /// distinguishes new from returning accounts without frontend changes.
  final String destination;
}
