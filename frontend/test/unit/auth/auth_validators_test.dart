import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/auth/auth.dart';

void main() {
  group('AuthValidators.email', () {
    test('accepts a well-formed email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
      expect(AuthValidators.email('  user@example.com  '), isNull);
    });

    test('rejects empty input', () {
      expect(AuthValidators.email(''), isNotNull);
      expect(AuthValidators.email('   '), isNotNull);
      expect(AuthValidators.email(null), isNotNull);
    });

    test('rejects malformed emails', () {
      expect(AuthValidators.email('user@'), isNotNull);
      expect(AuthValidators.email('@example.com'), isNotNull);
      expect(AuthValidators.email('user@example'), isNotNull);
      expect(AuthValidators.email('user example.com'), isNotNull);
    });
  });

  group('AuthValidators.username', () {
    test('accepts usernames of at least 3 characters', () {
      expect(AuthValidators.username('ana'), isNull);
      expect(AuthValidators.username('AnaLearnsAI'), isNull);
    });

    test('rejects empty or short usernames', () {
      expect(AuthValidators.username(''), isNotNull);
      expect(AuthValidators.username('ab'), isNotNull);
      expect(AuthValidators.username(null), isNotNull);
    });
  });

  group('AuthValidators.otp', () {
    test('accepts a complete numeric code', () {
      expect(AuthValidators.otp('123456'), isNull);
      expect(AuthValidators.otp(' 123456 '), isNull);
    });

    test('rejects empty or short codes', () {
      expect(AuthValidators.otp(''), isNotNull);
      expect(AuthValidators.otp('12345'), isNotNull);
      expect(AuthValidators.otp(null), isNotNull);
    });

    test('rejects non-digit codes', () {
      expect(AuthValidators.otp('12345a'), isNotNull);
      expect(AuthValidators.otp('ab12cd'), isNotNull);
    });
  });
}
