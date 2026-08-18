//**
// frontend/shared/design_system/extensions/context_extensions.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/responsive/app_breakpoints.dart';

extension AppContextBreakpoints on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenAspectRatio => screenWidth / screenHeight;

  bool get isCompact => screenWidth < AppBreakpoints.phone;

  bool get isMedium =>
      screenWidth >= AppBreakpoints.phone &&
      screenWidth < AppBreakpoints.smallTablet;

  bool get isExpanded =>
      screenWidth >= AppBreakpoints.smallTablet &&
      screenWidth < AppBreakpoints.tablet;

  bool get isLarge =>
      screenWidth >= AppBreakpoints.tablet &&
      screenWidth < AppBreakpoints.desktop;

  bool get isExtraLarge => screenWidth >= AppBreakpoints.desktop;

  bool get isPhone => isCompact;

  bool get isTablet => isMedium || isExpanded;

  bool get isDesktop => isLarge || isExtraLarge;

  bool get isWide => screenWidth >= AppBreakpoints.phone;

  AppLayoutTier get layoutTier {
    if (isExtraLarge) return AppLayoutTier.extraLarge;
    if (isLarge) return AppLayoutTier.large;
    if (isExpanded) return AppLayoutTier.expanded;
    if (isMedium) return AppLayoutTier.medium;
    return AppLayoutTier.compact;
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isPortrait => !isLandscape;

  double get paddingTop => MediaQuery.paddingOf(this).top;

  double get paddingBottom => MediaQuery.paddingOf(this).bottom;

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  bool get isKeyboardVisible => keyboardHeight > 0;

  TextTheme get appTextTheme => Theme.of(this).textTheme;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
