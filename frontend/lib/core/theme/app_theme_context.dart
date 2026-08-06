import 'package:flutter/material.dart';

import 'app_theme_extension.dart';

/// Convenient accessors for design-system values from any widget.
extension AppThemeContext on BuildContext {
  /// The resolved semantic color palette for the current theme.
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;

  /// The full [ThemeData] for the current context.
  ThemeData get appTheme => Theme.of(this);
}
