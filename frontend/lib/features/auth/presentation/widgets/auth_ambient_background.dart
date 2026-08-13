import 'package:flutter/material.dart';

/// Subtle ambient decoration behind the authentication content.
///
/// Paints a long flowing organic ridge plus two flat translucent corner circles
/// (top-left and bottom-right) so the white page gains quiet depth without
/// competing with the Auth hero. All shapes use the design system's orange
/// family at 4–8% opacity, are drawn from Flutter primitives (no gradients, no
/// assets), stay static, and never sit above content — the only motion on the
/// screen is the Auth Lottie.
class AuthAmbientBackground extends StatelessWidget {
  const AuthAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IgnorePointer(
      child: CustomPaint(
        painter: _AmbientBackgroundPainter(
          primary: scheme.primary,
          primaryContainer: scheme.primaryContainer,
        ),
        size: Size.infinite,
      ),
    );
  }
}

/// Paints the ambient wave and corner shapes, scaled to the canvas size.
class _AmbientBackgroundPainter extends CustomPainter {
  _AmbientBackgroundPainter({
    required this.primary,
    required this.primaryContainer,
  });

  final Color primary;
  final Color primaryContainer;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _paintFlatCircle(
      canvas,
      center: Offset(-w * 0.05, h * 0.02),
      radius: w * 0.30,
      color: primary,
      alpha: 0.05,
    );

    _paintFlatCircle(
      canvas,
      center: Offset(w * 1.05, h * 1.04),
      radius: w * 0.34,
      color: primaryContainer,
      alpha: 0.07,
    );

    // One continuous asymmetric ridge that crests near the hero's lower half,
    // undulates behind the actions, and flows off the right edge.
    final wave = Path()
      ..moveTo(-w * 0.03, h * 0.72)
      ..cubicTo(w * 0.10, h * 0.58, w * 0.24, h * 0.40, w * 0.42, h * 0.44)
      ..cubicTo(w * 0.56, h * 0.47, w * 0.66, h * 0.58, w * 0.78, h * 0.52)
      ..cubicTo(w * 0.88, h * 0.47, w * 0.95, h * 0.55, w * 1.03, h * 0.49)
      ..lineTo(w * 1.03, h * 1.05)
      ..lineTo(-w * 0.03, h * 1.05)
      ..close();

    canvas.drawPath(
      wave,
      Paint()
        ..style = PaintingStyle.fill
        ..color = primaryContainer.withValues(alpha: 0.04),
    );
  }

  /// Draws a flat translucent circle (no gradient) used for quiet depth.
  void _paintFlatCircle(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double alpha,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color.withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(covariant _AmbientBackgroundPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.primaryContainer != primaryContainer;
  }
}
