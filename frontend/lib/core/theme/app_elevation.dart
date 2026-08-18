//**
// frontend/core/theme/app_elevation.dart
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
import 'package:flutter/painting.dart';

abstract final class AppElevation {
  static const double flat = 0;

  static const double xs = 1;

  static const double sm = 2;

  static const double md = 3;

  static const double lg = 4;

  static const double xl = 6;

  static const double xxl = 8;

  static const double xxxl = 12;
}

abstract final class AppShadow {
  static const BoxShadow soft = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: 0,
    color: Color(0x0A000000),
  );

  static const BoxShadow raised = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
    color: Color(0x0F000000),
  );
}
