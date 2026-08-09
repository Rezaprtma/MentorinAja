/// Centralized copy for the authentication feature.
///
/// Single source of truth for every user-visible string. Localization later
/// swaps these constants for generated lookups without touching the widgets.
abstract final class AuthStrings {
  const AuthStrings._();

  // Authentication landing
  static const String tagline = 'Teman Belajar yang Memahami Kamu.';
  static const String taglineDescription =
      'Dapatkan bantuan belajar yang menyesuaikan kebutuhan dan tujuanmu.';
  static const String createAccountButton = 'Create Account';
  static const String signInButton = 'Sign In';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String orDivider = 'or';
  static const String termsFooter =
      'Dengan melanjutkan, kamu menyetujui\n'
      'Ketentuan Layanan & Kebijakan Privasi';

  // Google authentication
  static const String googleSignInError =
      'Google sign-in failed. Please try again.';
  static const String googleSignInAlreadyRunning =
      'Authentication is already in progress.';

  // Notifications
  static const String notificationSuccessTitle = 'Welcome!';
  static const String notificationSuccessMessage = 'Google sign-in complete.';
  static const String notificationErrorTitle = 'Login failed';
  static const String notificationErrorMessage = 'Please try again.';

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
  static const String otpTitle = 'Check your inbox';
  static const String otpSubtitle =
      "We've sent a verification code to your email.";
  static const String otpVerifyButton = 'Verify';
  static const String otpResendButton = 'Resend Code';
  static const String otpCanResend = 'Code sent successfully';
  static const String otpResendIn = 'Resend code in';
  static const String otpDidNotReceive = "Didn't receive the code?";
  static const String otpResendAction = 'Resend code';
  static const String otpEmailEdit = 'Change';
  static const String otpPaste = 'Paste';
  static const String otpSuccess = 'Email verified successfully';
  static const String otpSuccessTitle = 'Email verified!';
  static const String otpSuccessMessage = "You're all set.";
  static const String otpErrorTitle = 'Invalid code';
  static const String otpErrorMessage = 'Check your code.';
  static const String otpResendInfoTitle = 'Code sent!';
  static const String otpResendInfoMessage = 'Check your inbox.';
}
