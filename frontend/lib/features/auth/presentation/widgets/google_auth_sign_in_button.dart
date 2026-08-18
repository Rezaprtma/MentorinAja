//**
// frontend/features/auth/presentation/widgets/google_auth_sign_in_button.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/auth_strings.dart';
import '../../logic/google_auth_controller.dart';
import 'google_auth_button.dart';

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
