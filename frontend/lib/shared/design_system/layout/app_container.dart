//**
// frontend/shared/design_system/layout/app_container.dart
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

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.radius,
    this.borderColor,
    this.borderWidth = 1,
    this.shadow,
    this.onTap,
    this.onLongPress,
    this.alignment,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  });

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final Color? color;

  final double? radius;

  final Color? borderColor;

  final double borderWidth;

  final BoxShadow? shadow;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final AlignmentGeometry? alignment;

  final double? width;

  final double? height;

  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final radiusValue = radius ?? AppRadius.large;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusValue),
      side: borderColor == null
          ? BorderSide.none
          : BorderSide(color: borderColor!, width: borderWidth),
    );

    final decoration = BoxDecoration(
      color: color ?? context.appColors.card,
      borderRadius: BorderRadius.circular(radiusValue),
      boxShadow: shadow == null ? null : [shadow!],
    );

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );

    Widget surface = Material(color: Colors.transparent, child: content);

    if (onTap != null || onLongPress != null) {
      surface = Material(
        color: decoration.color,
        shadowColor: shadow?.color,
        elevation: shadow == null ? 0 : AppElevation.xs,
        shape: shape,
        clipBehavior: clipBehavior,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radiusValue),
          child: content,
        ),
      );
      return Container(
        width: width,
        height: height,
        alignment: alignment,
        margin: margin,
        decoration: BoxDecoration(
          color: decoration.color,
          borderRadius: BorderRadius.circular(radiusValue),
          boxShadow: shadow == null ? null : [shadow!],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiusValue),
          child: surface,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: content,
    );
  }
}
