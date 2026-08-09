import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/auth/auth.dart';

void main() {
  group('AuthActionResult', () {
    test('success carries no error', () {
      const result = AuthActionResult.success();
      expect(result.isSuccess, isTrue);
      expect(result.error, isNull);
    });

    test('failure carries an error message', () {
      const result = AuthActionResult.failure('boom');
      expect(result.isSuccess, isFalse);
      expect(result.error, 'boom');
    });
  });

  group('MockAuthService', () {
    const service = MockAuthService(latency: Duration(milliseconds: 1));

    test('resolves to success', () async {
      final result = await service.signInWithGoogle();
      expect(result.isSuccess, isTrue);
      expect(result.error, isNull);
    });

    test('forceFailure resolves to an error', () async {
      final result = await service.signInWithGoogle(forceFailure: true);
      expect(result.isSuccess, isFalse);
      expect(result.error, isNotNull);
    });
  });

  group('GoogleAuthController', () {
    GoogleAuthController buildController() {
      return GoogleAuthController(
        service: const MockAuthService(latency: Duration(milliseconds: 10)),
      );
    }

    test('is busy while signing in, then clears', () async {
      final controller = buildController();
      final future = controller.signIn();
      expect(controller.isBusy, isTrue);

      final result = await future;
      expect(controller.isBusy, isFalse);
      expect(result.isSuccess, isTrue);
      controller.dispose();
    });

    test('ignores a second sign-in while busy', () async {
      final controller = buildController();
      final first = controller.signIn();
      final second = controller.signIn();

      expect((await second).isSuccess, isFalse);
      expect((await first).isSuccess, isTrue);
      expect(controller.isBusy, isFalse);
      controller.dispose();
    });
  });
}
