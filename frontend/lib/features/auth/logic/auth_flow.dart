//**
// frontend/features/auth/logic/auth_flow.dart
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
import 'package:frontend/routing/route_names.dart';

abstract final class AuthFlow {
  const AuthFlow._();

  static const Duration verificationTtl = Duration(seconds: 60);

  static const String verifyStep = AppRoutes.otpVerification;
}
