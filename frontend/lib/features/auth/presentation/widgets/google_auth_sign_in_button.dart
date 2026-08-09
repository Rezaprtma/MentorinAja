import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/auth_strings.dart';
import '../../logic/google_auth_controller.dart';
import 'google_auth_button.dart';

/// Continue-with-Google action including its interaction feedback.
///
/// Reports the outcome through a compact [AppNotificationService] notification
/// and forwards successful sign-ins to the authenticated home screen.
/// TODO(backend): replace the mock service with the real Google OAuth flow.
class GoogleAuthSignInButton extends StatefulWidget {
  const GoogleAuthSignInButton({super.key});

  @override
  State<GoogleAuthSignInButton> createState() => _GoogleAuthSignInButtonState();
}

class _GoogleAuthSignInButtonState extends State<GoogleAuthSignInButton> {
  late final GoogleAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GoogleAuthController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final result = await _controller.signIn();
    if (!mounted) return;

    if (result.isSuccess) {
      AppNotificationService.show(
        context,
        type: AppNotificationType.success,
        title: AuthStrings.notificationSuccessTitle,
        message: AuthStrings.notificationSuccessMessage,
        actionLabel: 'Got it',
      );
      await Future<void>.delayed(AppDurations.slowest);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      AppNotificationService.show(
        context,
        type: AppNotificationType.error,
        title: AuthStrings.notificationErrorTitle,
        message: result.error ?? AuthStrings.notificationErrorMessage,
        actionLabel: 'Try again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return GoogleAuthButton(
          onPressed: _signIn,
          isLoading: _controller.isBusy,
        );
      },
    );
  }
}
