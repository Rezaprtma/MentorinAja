import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/auth/auth.dart';
import 'package:frontend/routing/route_names.dart';

void main() {
  group('AuthFlow', () {
    test('verify step points to the OTP screen', () {
      expect(AuthFlow.verifyStep, AppRoutes.otpVerification);
    });

    test('verification code expires after the TTL', () {
      expect(AuthFlow.verificationTtl, const Duration(seconds: 60));
    });
  });
}
