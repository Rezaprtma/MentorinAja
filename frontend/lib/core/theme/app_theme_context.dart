//**
// frontend/core/theme/app_theme_context.dart
//
// frontend:
// Theme system. Menyediakan colors, typography, spacing, dan theme configuration.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi theme rendering di light/dark mode.
//**
import 'package:flutter/material.dart';

import 'app_theme_extension.dart';

extension AppThemeContext on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;

  ThemeData get appTheme => Theme.of(this);
}
