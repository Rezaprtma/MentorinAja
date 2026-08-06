import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// A reusable, themable surface used by the rest of the design system.
///
/// `AppContainer` centralizes the common decoration concerns — padding,
/// radius, border, shadow and optional tap feedback — so screens and composite
/// widgets never hand-build `BoxDecoration` + `InkWell` pairs. When [onTap] is
/// provided the container renders a Material `InkWell` so the ripple stays
/// clipped to the border radius.
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

  /// The content of the container.
  final Widget child;

  /// Inner padding; defaults to `AppSpacing.md` on all sides.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Fill color; defaults to `appColors.card`.
  final Color? color;

  /// Corner radius; defaults to [AppRadius.large].
  final double? radius;

  /// Optional hairline border color.
  final Color? borderColor;

  /// Border stroke width when [borderColor] is set.
  final double borderWidth;

  /// Optional box shadow (see [AppShadow]).
  final BoxShadow? shadow;

  /// Tap handler; enables ink feedback and semantics.
  final VoidCallback? onTap;

  /// Long-press handler; requires [onTap] semantics to be meaningful.
  final VoidCallback? onLongPress;

  /// Aligns [child] inside the container.
  final AlignmentGeometry? alignment;

  /// Fixed width.
  final double? width;

  /// Fixed height.
  final double? height;

  /// How content is clipped against the rounded bounds.
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
