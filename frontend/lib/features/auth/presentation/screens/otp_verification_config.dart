//**
// frontend/features/auth/presentation/screens/otp_verification_config.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
import 'package:flutter/services.dart';

import 'package:frontend/routing/route_names.dart';

import '../../logic/auth_strings.dart';

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

  final String title;

  final String subtitle;

  final String buttonLabel;

  final String resendButtonLabel;

  final String successMessage;

  final int length;

  final bool autofocus;

  final List<String> autofillHints;

  final String destination;
}
