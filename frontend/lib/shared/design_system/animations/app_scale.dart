import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Animated scale wrapper for scale transitions.
///
/// Controlled scale that animates between values using [AppDurations.medium]
/// and [AppEasing.standard]. Useful for grow/shrink effects (reveal, pop-in,
/// focus expansion).
class AppScale extends StatelessWidget {
  const AppScale({
    super.key,
    required this.scale,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppEasing.standard,
    this.alignment = Alignment.center,
  });

  final double scale;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }
}

/// One-shot scale-in entrance animation (grows from small to full size).
class AppScaleIn extends StatelessWidget {
  const AppScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.medium,
    this.curve = AppEasing.decelerate,
    this.begin = 0.8,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double begin;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: 1.0),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, _) {
        return Transform.scale(scale: value, child: child);
      },
    );
  }
}
