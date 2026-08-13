/// App-wide color-mode selection singleton.
///
/// A single shared instance drives [App]'s `themeMode` so the Profile tab can
/// switch between light, dark and system themes at runtime. Defaults to
/// [ThemeMode.system] to match the operating system preference.
library;

import 'package:flutter/material.dart';

/// Holds the currently selected [ThemeMode] and notifies listeners.
class ThemeModeController extends ChangeNotifier {
  ThemeModeController._();

  /// Shared instance used by [App] and the Profile settings.
  static final ThemeModeController instance = ThemeModeController._();

  ThemeMode _mode = ThemeMode.system;

  /// Currently selected color mode.
  ThemeMode get mode => _mode;

  /// Updates the color mode and notifies listeners.
  void setMode(ThemeMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
  }
}
