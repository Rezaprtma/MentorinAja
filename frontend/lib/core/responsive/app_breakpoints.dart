import 'package:flutter/material.dart';

/// Breakpoint constants for the MentorinAja responsive system.
///
/// Follows Material 3 window size classes with additional tiers for
/// large-screen education layouts (course grids, split-view lessons).
/// All values are in logical pixels (dp).
abstract final class AppBreakpoints {
  /// Small phones (`< 360dp`).
  static const double smallPhone = 360;

  /// Standard phones (`< 600dp`).
  static const double phone = 600;

  /// Small tablets / large phones (`< 840dp`).
  static const double smallTablet = 840;

  /// Tablets (`< 1200dp`).
  static const double tablet = 1200;

  /// Desktop (`< 1440dp`).
  static const double desktop = 1440;

  /// Ultra-wide / large desktop (`>= 1440dp`).
  static const double ultraWide = 1440;
}

/// Describes which layout tier the current screen belongs to.
enum AppLayoutTier {
  /// `< 600dp` — phones.
  compact,

  /// `600dp – 839dp` — large phones, small tablets.
  medium,

  /// `840dp – 1199dp` — tablets.
  expanded,

  /// `1200dp – 1439dp` — desktop-class layouts.
  large,

  /// `>= 1440dp` — ultra-wide split-view.
  extraLarge,
}

/// Resolves a value based on the current breakpoint tier.
///
/// Instead of scattering `if (isDesktop)` checks throughout screens,
/// declare the full responsive intent in one place:
///
/// ```dart
/// final columns = AdaptiveValue<int>(phone: 1, tablet: 2, desktop: 3)
///     .resolve(context);
/// ```
class AdaptiveValue<T> {
  const AdaptiveValue({
    required this.phone,
    this.tablet,
    this.desktop,
    this.large,
    this.extraLarge,
  });

  /// Value for compact layouts (`< 600dp`).
  final T phone;

  /// Value for medium layouts (`600dp – 839dp`); falls back to [phone].
  final T? tablet;

  /// Value for expanded layouts (`840dp – 1199dp`); falls back to [tablet] ?? [phone].
  final T? desktop;

  /// Value for large layouts (`1200dp – 1439dp`); falls back to [desktop].
  final T? large;

  /// Value for extra-large layouts (`>= 1440dp`); falls back to [large].
  final T? extraLarge;

  /// Returns the value matching the current screen width.
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
