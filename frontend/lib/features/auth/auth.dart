/// Authentication feature public API.
///
/// Import this barrel for screen, controller, and pure-logic access.
///
/// ```dart
/// import 'package:frontend/features/auth/auth.dart';
/// ```
library;

export 'logic/auth_flow.dart';
export 'logic/auth_strings.dart';
export 'logic/auth_validators.dart';
export 'logic/otp_verification_controller.dart';
export 'logic/verification_request_controller.dart';
export 'presentation/screens/authentication_screen.dart';
export 'presentation/screens/create_account_screen.dart';
export 'presentation/screens/otp_verification_config.dart';
export 'presentation/screens/otp_verification_screen.dart';
export 'presentation/screens/sign_in_screen.dart';
