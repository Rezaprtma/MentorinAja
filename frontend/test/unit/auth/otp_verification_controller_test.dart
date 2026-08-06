import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/auth/auth.dart';

void main() {
  group('OtpVerificationController', () {
    test('starts idle without a countdown', () {
      final controller = OtpVerificationController();
      expect(controller.code, isEmpty);
      expect(controller.isVerifying, isFalse);
      expect(controller.isVerified, isFalse);
      expect(controller.error, isNull);
      expect(controller.canResend, isFalse);
      expect(controller.secondsRemaining, 0);
      controller.dispose();
    });

    test('updateCode clears a previous error', () async {
      final controller = OtpVerificationController();
      controller.updateCode('12345');
      await controller.verify();
      expect(controller.error, isNotNull);

      controller.updateCode('98625');
      expect(controller.error, isNull);
      controller.dispose();
    });

    test('verify rejects an incomplete code without verifying', () async {
      final controller = OtpVerificationController(
        verifyDelay: const Duration(milliseconds: 1),
      );
      controller.updateCode('12345');
      final result = await controller.verify();
      expect(result, isFalse);
      expect(controller.isVerified, isFalse);
      expect(controller.isVerifying, isFalse);
      controller.dispose();
    });

    test('verify completes for a full valid code', () async {
      final controller = OtpVerificationController(
        verifyDelay: const Duration(milliseconds: 1),
      );
      controller.updateCode('998877');
      final result = await controller.verify();
      expect(result, isTrue);
      expect(controller.isVerified, isTrue);
      expect(controller.isVerifying, isFalse);
      controller.dispose();
    });

    test('startCountdown disables resend and counts down', () {
      final controller = OtpVerificationController(
        resendDelay: const Duration(seconds: 2),
      );
      controller.startCountdown();
      expect(controller.secondsRemaining, 2);
      expect(controller.canResend, isFalse);
      expect(controller.countdownLabel, '00:02');
      controller.dispose();
    });
  });
}
