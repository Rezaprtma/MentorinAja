import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG image widget backed by `flutter_svg`.
///
/// Renders an SVG asset with [BoxFit.contain] by default. Pass [color] to
/// tint monochrome SVG artwork via [ColorFilter.mode]. [width]/[height] are
/// optional; when omitted the natural SVG size is used.
///
/// ```dart
/// AppSvg(AppIllustrations.onboardingWelcome, width: 240, height: 240);
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
    final widget = SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticsLabel,
    );

    if (semanticsLabel == null) {
      return widget;
    }
    return Semantics(label: semanticsLabel, image: true, child: widget);
  }
}
