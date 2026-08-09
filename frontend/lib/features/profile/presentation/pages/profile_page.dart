import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Profile tab placeholder.
///
/// Scaffold for the account surface. Content will be built by the profile
/// feature owner; for now it renders an oriented empty state so the tab shell
/// has a stable, theme-aware page.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppSafeArea(
        child: AppEmptyState(
          icon: Icons.person_outline_rounded,
          title: 'Your profile',
          message: 'Account details and settings live here.',
        ),
      ),
    );
  }
}
