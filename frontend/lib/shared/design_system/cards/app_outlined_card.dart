//**
// frontend/shared/design_system/cards/app_outlined_card.dart
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
import 'app_base_card.dart';

class AppOutlinedCard extends StatelessWidget {
  const AppOutlinedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.onLongPress,
    this.borderColor,
    this.borderWidth = 1,
    this.radius,
    this.width,
    this.height,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? borderColor;
  final double borderWidth;
  final double? radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    return AppBaseCard(
      padding: padding,
      elevation: AppElevation.flat,
      color: ext.card,
      borderSide: BorderSide(
        color: borderColor ?? ext.border,
        width: borderWidth,
      ),
      radius: radius,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      height: height,
      margin: margin,
      child: child,
    );
  }
}
