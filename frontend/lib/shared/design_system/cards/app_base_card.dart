import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Foundation card widget used by all card variants.
///
/// Wraps Material [Card] with the design tokens: consistent radius, surface
/// color, elevation and optional ink feedback when [onTap] is provided. Cards
/// are the primary container for grouped content (course previews, stats,
/// info blocks) and appear in lists, grids and standalone positions.
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

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Card background; defaults to theme card color.
  final Color? color;

  /// Surface lift; defaults to [AppElevation.sm].
  final double elevation;

  /// Corner radius; defaults to [AppRadius.large].
  final double? radius;

  /// Optional border; set to get an outlined card.
  final BorderSide? borderSide;

  /// Tap handler; renders an [InkWell] when non-null.
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
