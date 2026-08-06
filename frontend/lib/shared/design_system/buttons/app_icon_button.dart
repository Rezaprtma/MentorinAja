import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Accessible icon-only button.
///
/// Wraps the Material [IconButton] with the design tokens. A [tooltip] is
/// recommended — and required for accessibility — since icon-only buttons have
/// no visible label; the tooltip doubles as the semantics label.
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

  /// The glyph to render.
  final IconData icon;

  /// Tap handler; null disables the button.
  final VoidCallback? onPressed;

  /// Semantics + long-press label. Strongly recommended.
  final String? tooltip;

  /// Icon size; defaults to [AppIconSizes.lg].
  final double iconSize;

  /// Icon color; defaults to `onSurfaceVariant`.
  final Color? color;

  /// Fill color. When set the button becomes a filled tonal icon button.
  final Color? backgroundColor;

  /// Optional border color (pairs with [backgroundColor]).
  final Color? borderColor;

  /// Disabled icon color.
  final Color? disabledColor;

  /// Tap target density.
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
