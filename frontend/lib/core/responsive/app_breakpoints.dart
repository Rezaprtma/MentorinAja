//**
// frontend/core/responsive/app_breakpoints.dart
//
// frontend:
// Responsive system. Menyediakan breakpoints dan layout tiers.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi responsive behavior di berbagai screen size.
//**
import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const double smallPhone = 360;

  static const double phone = 600;

  static const double smallTablet = 840;

  static const double tablet = 1200;

  static const double desktop = 1440;

  static const double ultraWide = 1440;
}

enum AppLayoutTier { compact, medium, expanded, large, extraLarge }

class AdaptiveValue<T> {
  const AdaptiveValue({
    required this.phone,
    this.tablet,
    this.desktop,
    this.large,
    this.extraLarge,
  });

  final T phone;

  final T? tablet;

  final T? desktop;

  final T? large;

  final T? extraLarge;

  T resolve(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.ultraWide) {
      return extraLarge ?? large ?? desktop ?? tablet ?? phone;
    }
    if (width >= AppBreakpoints.tablet) {
      return large ?? desktop ?? tablet ?? phone;
    }
    if (width >= AppBreakpoints.smallTablet) return desktop ?? tablet ?? phone;
    if (width >= AppBreakpoints.phone) return tablet ?? phone;
    return phone;
  }
}
