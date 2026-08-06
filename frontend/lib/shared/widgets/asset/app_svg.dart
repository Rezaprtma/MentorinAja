import 'package:flutter/material.dart';

/// SVG image widget — stub for future `flutter_svg` integration.
///
/// When `flutter_svg` is added to `pubspec.yaml`, replace the body of
/// [build] with `SvgPicture.asset` or `SvgPicture.network`. The API
/// surface stays identical.
///
/// ```dart
/// AppSvg(AppIcons.home, width: 24, height: 24);
/// ```
class AppSvg extends StatelessWidget {
  const AppSvg(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticsLabel,
  });

  /// SVG asset path from the icon/image registry.
  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with SvgPicture.asset when flutter_svg is added.
    //
    // Scaffold:
    // ```dart
    // return SvgPicture.asset(
    //   assetPath,
    //   width: width,
    //   height: height,
    //   fit: fit,
    //   colorFilter: color != null
    //       ? ColorFilter.mode(color!, BlendMode.srcIn)
    //       : null,
    //   semanticsLabel: semanticsLabel,
    // );
    // ```

    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.grey),
      ),
    );
  }
}
