//**
// frontend/core/theme/app_durations.dart
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
import 'package:flutter/animation.dart';

abstract final class AppDurations {
  static const Duration fastest = Duration(milliseconds: 75);

  static const Duration fast = Duration(milliseconds: 150);

  static const Duration medium = Duration(milliseconds: 250);

  static const Duration slow = Duration(milliseconds: 350);

  static const Duration slower = Duration(milliseconds: 500);

  static const Duration slowest = Duration(milliseconds: 900);
}

abstract final class AppEasing {
  static const Curve standard = Curves.easeInOutCubicEmphasized;

  static const Curve decelerate = Curves.easeOutCubic;

  static const Curve accelerate = Curves.easeInCubic;

  static const Curve linear = Curves.linear;
}
