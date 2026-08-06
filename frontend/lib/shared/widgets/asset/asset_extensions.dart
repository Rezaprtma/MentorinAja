import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_brand.dart';
import 'package:frontend/core/assets/app_illustrations.dart';
import 'package:frontend/core/assets/app_logo.dart';

/// Asset-related convenience extensions on [BuildContext].
///
/// Provides theme-aware asset lookups so screens never hardcode
/// light/dark variant selection.
///
/// ```dart
/// Image.asset(context.emptyStateIllustration);
/// Text(AppBrand.name);
/// ```
extension AssetContextExtensions on BuildContext {
  // -------------------------------------------------------------------------
  // Theme-aware illustrations
  // -------------------------------------------------------------------------

  /// Returns the correct empty-state illustration for the current theme.
  String get emptyStateIllustration => isDarkMode
      ? AppIllustrations.emptyStateDark
      : AppIllustrations.emptyState;

  /// Returns the correct error illustration for the current theme.
  String get errorIllustration =>
      isDarkMode ? AppIllustrations.errorDark : AppIllustrations.error;

  /// Returns the correct offline illustration for the current theme.
  String get offlineIllustration =>
      isDarkMode ? AppIllustrations.offlineDark : AppIllustrations.offline;

  /// Returns the correct maintenance illustration for the current theme.
  String get maintenanceIllustration => isDarkMode
      ? AppIllustrations.maintenanceDark
      : AppIllustrations.maintenance;

  /// Returns the correct not-found illustration for the current theme.
  String get notFoundIllustration =>
      isDarkMode ? AppIllustrations.notFoundDark : AppIllustrations.notFound;

  /// Returns the correct success illustration for the current theme.
  String get successIllustration =>
      isDarkMode ? AppIllustrations.successDark : AppIllustrations.success;

  /// Returns the correct achievement illustration for the current theme.
  String get achievementIllustration => isDarkMode
      ? AppIllustrations.achievementDark
      : AppIllustrations.achievement;

  /// Returns the correct learning illustration for the current theme.
  String get learningIllustration =>
      isDarkMode ? AppIllustrations.learningDark : AppIllustrations.learning;

  // -------------------------------------------------------------------------
  // Theme-aware logos
  // -------------------------------------------------------------------------

  /// Returns the correct logo for the current theme.
  String get brandLogo => AppLogo.primary;

  /// Returns the correct logo icon for the current theme.
  String get brandIcon => AppLogo.primary;

  /// Returns the correct wordmark for the current theme.
  String get brandWordmark => AppLogo.primary;

  /// Returns the correct splash logo for the current theme.
  String get splashLogo => AppLogo.splash;

  // -------------------------------------------------------------------------
  // Brand identity
  // -------------------------------------------------------------------------

  /// The product name.
  String get brandName => AppBrand.name;

  /// The product tagline.
  String get brandTagline => AppBrand.tagline;
}

/// Shortcut for `Theme.of(context).brightness == Brightness.dark`.
extension _DarkModeHelper on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
