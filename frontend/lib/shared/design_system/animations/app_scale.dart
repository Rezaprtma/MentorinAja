//**
// frontend/shared/design_system/animations/app_scale.dart
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
