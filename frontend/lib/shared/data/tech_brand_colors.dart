import 'package:flutter/material.dart';

/// Brand-derived color triple for a technology course card.
///
/// Each technology carries its own background, accent, and on-color so the
/// card immediately communicates which technology it represents.
class TechBrandColors {
  const TechBrandColors({
    required this.background,
    required this.accent,
    required this.onAccent,
  });

  final Color background;
  final Color accent;
  final Color onAccent;
}
