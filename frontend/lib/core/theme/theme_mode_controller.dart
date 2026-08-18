//**
// frontend/core/theme/theme_mode_controller.dart
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
library;

import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeModeController._();

  static final ThemeModeController instance = ThemeModeController._();

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
  }
}
