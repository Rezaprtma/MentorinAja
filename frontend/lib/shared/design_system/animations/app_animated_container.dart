import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Themed [AnimatedContainer] with the design-system motion tokens.
///
/// Animates changes to decoration, size and padding using [AppDurations.medium]
/// and [AppEasing.standard] by default, so every property change in the app
/// shares the same rhythm.
class AppAnimatedContainer extends StatelessWidget {
  const AppAnimatedContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.duration = AppDurations.medium,
    this.curve = AppEasing.standard,
    this.alignment,
    this.child,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final Duration duration;
  final Curve curve;
  final AlignmentGeometry? alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      color: color,
      duration: duration,
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }
}

/// Themed [AnimatedSwitcher] that cross-fades between child changes.
///
/// Use when a container's content changes dynamically (e.g. loading → data)
/// and you want a smooth visual transition.
class AppAnimatedSwitcher extends StatelessWidget {
  const AppAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppEasing.standard,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: child,
    );
  }
}
