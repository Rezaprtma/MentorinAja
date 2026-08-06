import 'package:flutter/material.dart';

/// Unified icon widget that handles Material icons and custom asset icons.
///
/// [AppIcon] provides a single API for both Flutter's built-in [IconData]
/// icons and custom PNG/SVG icon assets. When the project adds a custom
/// icon font, this widget resolves codepoints from [AppIcons]. When SVG
/// icons are added, it delegates to [AppSvg].
///
/// ```dart
/// AppIcon(AppIcons.homeOutlined, size: 24);
/// AppIcon.asset(AppIconPaths.bookmark, size: 20);
/// ```
class AppIcon extends StatelessWidget {
  /// Creates an icon from Flutter [IconData] (Material or custom font).
  const AppIcon(
    this.iconData, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
  }) : _assetPath = null;

  /// Creates an icon from an asset path (PNG/SVG).
  ///
  /// Currently renders a placeholder. When SVG support is added, this
  /// delegates to [AppSvg].
  const AppIcon.asset(
    String assetPath, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
  }) : iconData = null,
       _assetPath = assetPath,
       fill = null,
       weight = null,
       grade = null,
       opticalSize = null;

  /// The [IconData] to display. Null when using asset path.
  final IconData? iconData;

  /// Asset path when using `AppIcon.asset()`.
  final String? _assetPath;

  final double? size;
  final Color? color;
  final String? semanticsLabel;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;

  @override
  Widget build(BuildContext context) {
    if (_assetPath != null) {
      return _buildAssetIcon(context);
    }

    final effectiveSize = size ?? 24;
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    final icon = Icon(
      iconData,
      size: effectiveSize,
      color: effectiveColor,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
    );

    if (semanticsLabel != null) {
      return Semantics(label: semanticsLabel, child: icon);
    }

    return icon;
  }

  Widget _buildAssetIcon(BuildContext context) {
    // TODO: When SVG support is added, detect format and delegate:
    // if (_assetPath!.endsWith('.svg')) {
    //   return AppSvg(_assetPath!, width: size, height: size, color: color);
    // }

    // For now, render as a placeholder.
    return Icon(
      Icons.image_outlined,
      size: size ?? 24,
      color: color ?? Colors.grey,
    );
  }
}
