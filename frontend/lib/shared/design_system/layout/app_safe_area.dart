import 'package:flutter/material.dart';

/// Application shell-agnostic safe-area wrapper.
///
/// Thin convenience over [SafeArea] that makes edge handling explicit and
/// composable within any layout (including inside custom scaffolds).
class AppSafeArea extends StatelessWidget {
  const AppSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  /// The content to inset.
  final Widget child;

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// Minimum insets to apply regardless of the device padding.
  final EdgeInsets minimum;

  /// Whether to keep bottom padding for keyboard avoidance.
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}
