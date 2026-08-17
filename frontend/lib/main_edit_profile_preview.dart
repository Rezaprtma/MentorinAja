import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Preview harness for the Edit Profil experience.
///
/// Boots straight into the editor so the focused username + photo flow can be
/// exercised without a full app bootstrap.
void main() {
  runApp(
    ListenableBuilder(
      listenable: ThemeModeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeModeController.instance.mode,
        home: const EditProfilePage(),
      ),
    ),
  );
}
