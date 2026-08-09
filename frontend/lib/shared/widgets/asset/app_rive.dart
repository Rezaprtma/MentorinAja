import 'package:flutter/material.dart';

/// Rive animation widget — stub for future `rive` integration.
///
/// When the `rive` package is added to `pubspec.yaml`, replace the body
/// of [build] with `RiveAnimation.asset`. The API surface stays identical.
///
/// ```dart
/// AppRive('assets/animations/streak_fire.riv', width: 48, height: 48);
/// ```
class AppRive extends StatelessWidget {
  const AppRive(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.artboard,
    this.stateMachineName,
    this.autoplay = true,
    this.onInit,
  });

  /// Rive (.riv) asset path from the animation registry.
  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Specific artboard to play (defaults to the first artboard).
  final String? artboard;

  /// Specific state machine to control (defaults to the first state machine).
  final String? stateMachineName;

  /// Whether to start playing immediately.
  final bool autoplay;

  /// Called when the Rive controller is initialized.
  final void Function(dynamic controller)? onInit;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with RiveAnimation.asset when rive package is added.
    //
    // Scaffold:
    // ```dart
    // return RiveAnimation.asset(
    //   assetPath,
    //   width: width,
    //   height: height,
    //   fit: fit,
    //   artboard: artboard,
    //   stateMachineName: stateMachineName,
    //   autoplay: autoplay,
    //   onInit: onInit,
    // );
    // ```

    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: Icon(Icons.animation, color: Colors.grey)),
    );
  }
}
