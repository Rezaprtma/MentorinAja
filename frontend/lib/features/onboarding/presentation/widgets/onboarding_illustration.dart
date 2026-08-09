import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/widgets/widgets.dart';

/// Renders the onboarding SVG as a large, centered visual focal point.
///
/// No decorative geometry is painted behind the artwork — the background stays
/// clean and the illustration is scaled to roughly three quarters of the
/// available space, preserving aspect ratio within safe margins.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.assetPath});

  /// SVG illustration asset path.
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          constraints.maxWidth * 0.82,
          constraints.maxHeight * 0.85,
        );

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: AppSvg(
              assetPath,
              fit: BoxFit.contain,
              semanticsLabel: 'Onboarding illustration',
            ),
          ),
        );
      },
    );
  }
}
