//**
// frontend/shared/design_system/buttons/app_icon_button.dart
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

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = AppIconSizes.lg,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.disabledColor,
    this.visualDensity = VisualDensity.standard,
  });

  final IconData icon;

  final VoidCallback? onPressed;

  final String? tooltip;

  final double iconSize;

  final Color? color;

  final Color? backgroundColor;

  final Color? borderColor;

  final Color? disabledColor;

  final VisualDensity visualDensity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFilled = backgroundColor != null;

    return IconButton(
      icon: Icon(icon, size: iconSize),
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      color: color ?? scheme.onSurfaceVariant,
      disabledColor: disabledColor ?? scheme.onSurface.withValues(alpha: 0.38),
      visualDensity: visualDensity,
      style: isFilled
          ? IconButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: color,
              side: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : null,
              shape: const StadiumBorder(),
            )
          : null,
    );
  }
}
