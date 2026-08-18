//**
// frontend/shared/design_system/animations/app_animated_container.dart
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
