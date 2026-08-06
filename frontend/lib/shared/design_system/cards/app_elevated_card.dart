import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_base_card.dart';

/// Card with subtle elevation and soft shadow — for interactive or highlighted
/// content (featured courses, primary CTAs).
class AppElevatedCard extends StatelessWidget {
  const AppElevatedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.onLongPress,
    this.elevation = AppElevation.sm,
    this.radius,
    this.color,
    this.width,
    this.height,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double elevation;
  final double? radius;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: padding,
      elevation: elevation,
      color: color,
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
