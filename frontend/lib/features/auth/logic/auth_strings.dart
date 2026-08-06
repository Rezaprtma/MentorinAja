/// Centralized copy for the authentication feature.
///
/// Single source of truth for every user-visible string. Localization later
/// swaps these constants for generated lookups without touching the widgets.
abstract final class AuthStrings {
  const AuthStrings._();

  // Authentication landing
  static const String createAccountButton = 'Create Account';
  static const String signInButton = 'Sign In';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String orDivider = 'or';
  static const String termsFooter =
      'Dengan melanjutkan, kamu menyetujui\n'
      'Ketentuan Layanan & Kebijakan Privasi';
  static const String googleUnavailable =
      'Google Sign-In akan segera tersedia.';

  // Create account
  static const String createTitle = 'Create Account';
  static const String createSubtitle =
      'Buat akun MentorinAja untuk memulai perjalanan belajarmu.';

  // Sign in
  static const String signInTitle = 'Sign In';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signInSubtitle =
      'Masukkan email yang terdaftar untuk melanjutkan.';

  // Shared form
  static const String continueButton = 'Continue';
  static const String emailLabel = 'Email';
  static const String emailHint = 'you@example.com';
  static const String usernameLabel = 'Username';
  static const String usernameHint = 'How should we call you?';

  // Validation
  static const String emailRequired = 'Enter your email address';
  static const String emailInvalid = 'Enter a valid email address';
  static const String usernameRequired = 'Enter a username';
  static const String usernameTooShort =
      'Username must be at least 3 characters';
  static const String otpRequired = 'Enter the verification code';

  /// Message telling the user to enter all [length] digits.
  static String otpIncomplete(int length) => 'Enter all $length digits';

  static const String otpDigitsOnly = 'The code contains only digits';

  // OTP verification
  static const String otpTitle = 'Verifikasi Email';
  static const String otpSubtitle =
      'Masukkan 6 digit kode yang telah dikirim ke email kamu.';
  static const String otpVerifyButton = 'Verify';
  static const String otpResendButton = 'Resend Code';
  static const String otpCanResend = 'Kode dapat dikirim ulang';
  static const String otpResendIn = 'Kirim ulang dalam';
  static const String otpSuccess = 'Email berhasil diverifikasi';
}
