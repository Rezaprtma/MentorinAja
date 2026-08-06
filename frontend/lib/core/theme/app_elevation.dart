import 'package:flutter/painting.dart';

/// Material 3 elevation levels for the MentorinAja design system.
///
/// Elevation communicates surface depth: flat surfaces are `0`, and the scale
/// climbs gradually so cards, overlays, and critical panels lift one step at a
/// time without looking heavy.
abstract final class AppElevation {
  /// 0 — surfaces resting directly on the background.
  static const double flat = 0;

  /// 1 — minimal lift for scrolled-under app bars.
  static const double xs = 1;

  /// 2 — resting cards.
  static const double sm = 2;

  /// 3 — hovered cards and subtle overlays.
  static const double md = 3;

  /// 4 — elevated menus and popovers.
  static const double lg = 4;

  /// 6 — dialogs and bottom sheets.
  static const double xl = 6;

  /// 8 — temporary floating panels.
  static const double xxl = 8;

  /// 12 — the highest emphasized surfaces.
  static const double xxxl = 12;
}

/// Soft, diffused shadow presets.
///
/// The product direction calls for thin, blended shadows rather than hard,
/// heavy ones. Use [AppShadow.soft] for cards and [AppShadow.raised] for
/// floating overlays.
abstract final class AppShadow {
  /// `0 4 16 rgba(0, 0, 0, 0.04)` — resting card shadow.
  static const BoxShadow soft = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: 0,
    color: Color(0x0A000000),
  );

  /// `0 8 24 rgba(0, 0, 0, 0.06)` — floating/overlay shadow.
  static const BoxShadow raised = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    spreadRadius: 0,
    color: Color(0x0F000000),
  );
}
