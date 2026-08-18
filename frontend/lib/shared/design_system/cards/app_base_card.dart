//**
// frontend/shared/design_system/cards/app_base_card.dart
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

class AppBaseCard extends StatelessWidget {
  const AppBaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.elevation = AppElevation.sm,
    this.radius,
    this.borderSide,
    this.onTap,
    this.onLongPress,
    this.clipBehavior = Clip.none,
    this.width,
    this.height,
    this.margin,
  });

  final Widget child;

  final EdgeInsetsGeometry padding;

  final Color? color;

  final double elevation;

  final double? radius;

  final BorderSide? borderSide;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final Clip clipBehavior;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final radiusValue = radius ?? AppRadius.large;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusValue),
      side: borderSide ?? BorderSide.none,
    );

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: color ?? ext.card,
        elevation: elevation,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        shape: shape,
        clipBehavior: clipBehavior,
        margin: margin ?? EdgeInsets.zero,
        child: onTap != null || onLongPress != null
            ? InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                borderRadius: BorderRadius.circular(radiusValue),
                child: Padding(padding: padding, child: child),
              )
            : Padding(padding: padding, child: child),
      ),
    );
  }
}
