//**
// frontend/main_profile_preview.dart
//
// frontend:
// Development preview entrypoint. Untuk preview UI secara standalone.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi preview rendering.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

void main() {
  runApp(
    ListenableBuilder(
      listenable: ThemeModeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeModeController.instance.mode,
        routes: {
          AppRoutes.feedback: (_) => const FeedbackPage(),
          AppRoutes.helpCenter: (_) => const HelpCenterPage(),
          AppRoutes.about: (_) => const AboutPage(),
          AppRoutes.privacyPolicy: (_) => const PrivacyPolicyPage(),
          AppRoutes.userPolicy: (_) => const UserPolicyPage(),
          AppRoutes.editProfile: (_) => const EditProfilePage(),
        },
        home: const ProfilePage(),
      ),
    ),
  );
}
