import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Themed floating action button.
///
/// Use the default constructor for a circular [FloatingActionButton] and
/// [AppFloatingActionButton.extended] for a labeled one. Defaults follow the
/// M3 spec (primary container surface) but are overridable per screen.
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

  /// Extended FAB with a visible label.
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
