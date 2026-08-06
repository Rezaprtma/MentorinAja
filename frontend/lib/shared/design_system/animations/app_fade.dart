import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Animated opacity wrapper with entrance animation support.
///
/// When [visible] is true the widget fades in from transparent using
/// [AppDurations.medium] and [AppEasing.decelerate]. When false it fades out
/// with [AppEasing.accelerate]. Useful for toggling overlays, tooltips and
/// help text without abrupt layout changes.
class AppFade extends StatelessWidget {
  const AppFade({
    super.key,
    required this.visible,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppEasing.standard,
  });

  final bool visible;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: IgnorePointer(ignoring: !visible, child: child),
    );
  }
}

/// One-shot fade-in entrance animation.
///
/// The widget fades from transparent to opaque on the first build. Uses
/// [TweenAnimationBuilder] so no [AnimationController] or [TickerProvider]
/// is required.
class AppFadeIn extends StatelessWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.slow,
    this.curve = AppEasing.decelerate,
    this.begin = 0.0,
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
        return Opacity(opacity: value, child: child);
      },
    );
  }
}
