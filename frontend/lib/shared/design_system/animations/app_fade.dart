//**
// frontend/shared/design_system/animations/app_fade.dart
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

import '../../../core/theme/theme.dart';

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
