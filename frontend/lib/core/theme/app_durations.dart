import 'package:flutter/animation.dart';

/// Motion duration scale for the MentorinAja design system.
///
/// Keeps animation consistent with the calm, purposeful motion direction:
/// transitions are short and never distracting. Prefer the M3 emphasized easing
/// ([AppEasing.emphasized]) for most state changes.
abstract final class AppDurations {
  /// 75ms — micro-interactions and pressed feedback.
  static const Duration fastest = Duration(milliseconds: 75);

  /// 150ms — quick state changes, hover/focus feedback.
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms — standard transitions (page fades, dialogs).
  static const Duration medium = Duration(milliseconds: 250);

  /// 350ms — larger transitions such as sheets and banners.
  static const Duration slow = Duration(milliseconds: 350);

  /// 500ms — deliberately noticeable transitions (hero animations).
  static const Duration slower = Duration(milliseconds: 500);

  /// 900ms — held confirmation states before navigation (success hand-off).
  static const Duration slowest = Duration(milliseconds: 900);
}

/// Motion easing presets aligned with Material 3.
abstract final class AppEasing {
  /// Default easing for standard transitions (M3 "emphasized").
  static const Curve standard = Curves.easeInOutCubicEmphasized;

  /// Easing for elements entering the screen.
  static const Curve decelerate = Curves.easeOutCubic;

  /// Easing for elements leaving the screen.
  static const Curve accelerate = Curves.easeInCubic;

  /// Easing for progress-like, continuous motion.
  static const Curve linear = Curves.linear;
}
