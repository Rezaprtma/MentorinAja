//**
// frontend/shared/widgets/asset/asset_extensions.dart
//
// frontend:
// Shared widget. Menyediakan reusable UI components untuk feature screens.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering dan behavior.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_brand.dart';
import 'package:frontend/core/assets/app_illustrations.dart';
import 'package:frontend/core/assets/app_logo.dart';

extension AssetContextExtensions on BuildContext {
  String get emptyStateIllustration => isDarkMode
      ? AppIllustrations.emptyStateDark
      : AppIllustrations.emptyState;

  String get errorIllustration =>
      isDarkMode ? AppIllustrations.errorDark : AppIllustrations.error;

  String get offlineIllustration =>
      isDarkMode ? AppIllustrations.offlineDark : AppIllustrations.offline;

  String get maintenanceIllustration => isDarkMode
      ? AppIllustrations.maintenanceDark
      : AppIllustrations.maintenance;

  String get notFoundIllustration =>
      isDarkMode ? AppIllustrations.notFoundDark : AppIllustrations.notFound;

  String get successIllustration =>
      isDarkMode ? AppIllustrations.successDark : AppIllustrations.success;

  String get achievementIllustration => isDarkMode
      ? AppIllustrations.achievementDark
      : AppIllustrations.achievement;

  String get learningIllustration =>
      isDarkMode ? AppIllustrations.learningDark : AppIllustrations.learning;

  String get brandLogo => AppLogo.primary;

  String get brandIcon => AppLogo.primary;

  String get brandWordmark => AppLogo.primary;

  String get splashLogo => AppLogo.splash;

  String get brandName => AppBrand.name;

  String get brandTagline => AppBrand.tagline;
}

extension _DarkModeHelper on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
