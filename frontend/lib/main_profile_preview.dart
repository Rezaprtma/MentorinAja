import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Preview harness for the profile experience.
///
/// Registers the same sub-page routes the real app does so the preview can be
/// exercised end to end without a full app bootstrap.
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
