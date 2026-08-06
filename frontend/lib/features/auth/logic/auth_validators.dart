import 'auth_strings.dart';

/// Form validation rules for the passwordless authentication screens.
///
/// Pure, stateless function references compatible with Flutter's
/// `FormFieldValidator<String>`. No value is ever stored or transmitted.
abstract final class AuthValidators {
  const AuthValidators._();

  /// Validates a non-empty, well-formed email address.
  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AuthStrings.emailRequired;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return AuthStrings.emailInvalid;
    }
    return null;
  }

  /// Validates a non-empty username (at least 3 characters).
  static String? username(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return AuthStrings.usernameRequired;
    if (username.length < 3) return AuthStrings.usernameTooShort;
    return null;
  }

  /// Validates a complete numeric verification code of the expected length.
  static String? otp(String? value, {int expectedLength = 6}) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) return AuthStrings.otpRequired;
    if (code.length != expectedLength) {
      return AuthStrings.otpIncomplete(expectedLength);
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(code)) {
      return AuthStrings.otpDigitsOnly;
    }
    return null;
  }
}
