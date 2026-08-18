//**
// frontend/shared/design_system/buttons/app_floating_action_button.dart
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

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.heroTag,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = AppElevation.md,
    this.shape,
  }) : _extended = false,
       label = null;

  const AppFloatingActionButton.extended({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.heroTag,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = AppElevation.md,
    this.shape,
  }) : _extended = true;

  final bool _extended;
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Object? heroTag;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = backgroundColor ?? scheme.primaryContainer;
    final foreground = foregroundColor ?? scheme.onPrimaryContainer;

    return _extended
        ? FloatingActionButton.extended(
            onPressed: onPressed,
            heroTag: heroTag,
            tooltip: tooltip,
            elevation: elevation,
            backgroundColor: background,
            foregroundColor: foreground,
            shape: shape ?? const StadiumBorder(),
            icon: Icon(icon, size: AppIconSizes.lg),
            label: Text(label!),
          )
        : FloatingActionButton(
            onPressed: onPressed,
            heroTag: heroTag,
            tooltip: tooltip,
            elevation: elevation,
            backgroundColor: background,
            foregroundColor: foreground,
            shape: shape,
            child: Icon(icon, size: AppIconSizes.lg),
          );
  }
}
