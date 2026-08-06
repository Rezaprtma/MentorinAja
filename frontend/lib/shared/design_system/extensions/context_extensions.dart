import 'package:flutter/material.dart';

import 'package:frontend/core/responsive/app_breakpoints.dart';

/// Responsive, theme, and layout helpers available on any [BuildContext].
///
/// Screens use these instead of reaching for `MediaQuery` and `Theme`
/// directly so the design system owns the responsive contract in one place.
/// Widths follow Material 3 window size classes with additional tiers for
/// education layouts.
extension AppContextBreakpoints on BuildContext {
  // -------------------------------------------------------------------------
  // Dimensions
  // -------------------------------------------------------------------------

  /// The width of the enclosing screen in logical pixels.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The height of the enclosing screen in logical pixels.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Aspect ratio (width / height).
  double get screenAspectRatio => screenWidth / screenHeight;

  // -------------------------------------------------------------------------
  // Layout tiers
  // -------------------------------------------------------------------------

  /// Compact layout — phones and smaller windows (`< 600dp`).
  bool get isCompact => screenWidth < AppBreakpoints.phone;

  /// Medium layout — larger phones and 7" tablets (`600dp – 839dp`).
  bool get isMedium =>
      screenWidth >= AppBreakpoints.phone &&
      screenWidth < AppBreakpoints.smallTablet;

  /// Expanded layout — most tablets (`840dp – 1199dp`).
  bool get isExpanded =>
      screenWidth >= AppBreakpoints.smallTablet &&
      screenWidth < AppBreakpoints.tablet;

  /// Large layout — desktop-class (`1200dp – 1439dp`).
  bool get isLarge =>
      screenWidth >= AppBreakpoints.tablet &&
      screenWidth < AppBreakpoints.desktop;

  /// Extra-large layout — ultra-wide (`>= 1440dp`).
  bool get isExtraLarge => screenWidth >= AppBreakpoints.desktop;

  /// Semantic: phone form factor (`< 600dp`).
  bool get isPhone => isCompact;

  /// Semantic: tablet form factor (`>= 600dp && < 1200dp`).
  bool get isTablet => isMedium || isExpanded;

  /// Semantic: desktop-class form factor (`>= 1200dp`).
  bool get isDesktop => isLarge || isExtraLarge;

  /// True when `width >= 600dp`; shorthand for "wide enough for grids".
  bool get isWide => screenWidth >= AppBreakpoints.phone;

  /// The resolved [AppLayoutTier] for the current width.
  AppLayoutTier get layoutTier {
    if (isExtraLarge) return AppLayoutTier.extraLarge;
    if (isLarge) return AppLayoutTier.large;
    if (isExpanded) return AppLayoutTier.expanded;
    if (isMedium) return AppLayoutTier.medium;
    return AppLayoutTier.compact;
  }

  // -------------------------------------------------------------------------
  // Orientation
  // -------------------------------------------------------------------------

  /// Whether the screen is in landscape orientation.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Whether the screen is in portrait orientation.
  bool get isPortrait => !isLandscape;

  // -------------------------------------------------------------------------
  // System insets
  // -------------------------------------------------------------------------

  /// Top safe-area inset (status bar / notch).
  double get paddingTop => MediaQuery.paddingOf(this).top;

  /// Bottom safe-area inset (home indicator).
  double get paddingBottom => MediaQuery.paddingOf(this).bottom;

  /// Current keyboard height (`0` when hidden).
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// Whether the keyboard is currently visible.
  bool get isKeyboardVisible => keyboardHeight > 0;

  // -------------------------------------------------------------------------
  // Theme
  // -------------------------------------------------------------------------

  /// Convenience alias for the parsed [ThemeData] text theme.
  TextTheme get appTextTheme => Theme.of(this).textTheme;

  /// Whether the active theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
