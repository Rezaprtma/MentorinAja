import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/auth/auth.dart';
import 'package:frontend/features/auth/presentation/widgets/google_auth_button.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    routes: {
      AppRoutes.authentication: (_) => const AuthenticationScreen(),
      AppRoutes.createAccount: (_) => const CreateAccountScreen(),
      AppRoutes.signIn: (_) => const SignInScreen(),
      AppRoutes.otpVerification: (_) => const OtpVerificationScreen(),
      AppRoutes.home: (_) => const Scaffold(body: Center(child: Text('Home'))),
    },
    initialRoute: AppRoutes.authentication,
  );
}

/// Minimal app rooted at the OTP screen — isolates the verification page from
/// the wider authentication surface under the blocky test font.
Widget _buildOtpApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    routes: {
      AppRoutes.otpVerification: (_) => const OtpVerificationScreen(),
      AppRoutes.home: (_) => const Scaffold(body: Center(child: Text('Home'))),
    },
    initialRoute: AppRoutes.otpVerification,
  );
}

/// Pops the current route so screens disposing timers clean up their state.
Future<void> _popCurrentRoute(WidgetTester tester) async {
  final navigator = tester.state<NavigatorState>(find.byType(Navigator));
  navigator.pop();
  await _pumpTransition(tester);
}

/// Pumps enough real frames to drive a route transition to completion.
///
/// `pumpAndSettle` is avoided because the landing screen's animated transition
/// and timers can cause flakiness under the blocky test font.
Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Mimics a phone viewport (tall, 3x density) so the OTP page fits without
/// scrolling on the default test surface.
void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    'Continue with Google shows a loading state then success feedback',
    (tester) async {
      await tester.pumpWidget(_buildApp());

      final googleButton = find.byType(GoogleAuthButton);
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pump();

      expect(
        find.descendant(
          of: googleButton,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(AuthStrings.notificationSuccessTitle), findsOneWidget);
      expect(find.text(AuthStrings.notificationSuccessMessage), findsOneWidget);

      await tester.pump(AppToast.displayDuration);
      await tester.pump(const Duration(milliseconds: 400));
    },
  );

  testWidgets('Create Account opens its screen and forwards the email to OTP', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());

    final createButton = find.widgetWithText(
      AppButton,
      AuthStrings.createAccountButton,
    );
    await tester.ensureVisible(createButton);
    await tester.tap(createButton);
    await _pumpTransition(tester);

    expect(find.text(AuthStrings.createTitle), findsOneWidget);

    await tester.enterText(find.byType(AppTextField).at(0), 'ana123');
    await tester.enterText(find.byType(AppTextField).at(1), 'ana@example.com');

    final continueButton = find.widgetWithText(
      AppButton,
      AuthStrings.continueButton,
    );
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await _pumpTransition(tester);

    expect(find.text(AuthStrings.otpTitle), findsOneWidget);
    expect(find.text('ana@example.com'), findsOneWidget);

    await _popCurrentRoute(tester);
  });

  testWidgets('Sign In forwards the email to the OTP screen', (tester) async {
    await tester.pumpWidget(_buildApp());

    final signInLink = find.widgetWithText(
      TextButton,
      AuthStrings.signInButton,
    );
    await tester.ensureVisible(signInLink);
    await tester.tap(signInLink);
    await _pumpTransition(tester);

    expect(find.text(AuthStrings.signInTitle), findsOneWidget);

    await tester.enterText(find.byType(AppTextField).first, 'user@example.com');

    final continueButton = find.widgetWithText(
      AppButton,
      AuthStrings.continueButton,
    );
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await _pumpTransition(tester);

    expect(find.text(AuthStrings.otpTitle), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);

    await _popCurrentRoute(tester);
  });

  testWidgets('Incomplete code shows an Error notification', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(_buildOtpApp());

    for (final digit in '1234'.split('')) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }

    final verifyButton = find.widgetWithText(
      AppButton,
      AuthStrings.otpVerifyButton,
    );
    await tester.tap(verifyButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(AuthStrings.otpErrorTitle), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pump(const Duration(milliseconds: 400));
  });

  testWidgets('Valid code shows success notification and lands on Home', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(_buildOtpApp());

    for (final digit in '123456'.split('')) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text(AuthStrings.otpSuccessTitle), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await _pumpTransition(tester);

    expect(find.text('Home'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));
  });
}
