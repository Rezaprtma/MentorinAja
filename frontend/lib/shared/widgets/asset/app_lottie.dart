import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie animation widget backed by the `lottie` package.
///
/// Renders a Lottie JSON asset, play-once via [repeat] false, and reports
/// natural completion through [onEnd]. Supports reduced motion by displaying
/// the final static frame instead of playing. Load failures surface through
/// [onError].
///
/// ```dart
/// AppLottie(AppAnimations.loadingDots, width: 80);
/// AppLottie(AppAnimations.successCheck, repeat: false, onEnd: () { ... });
/// ```
class AppLottie extends StatefulWidget {
  const AppLottie(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.animate = true,
    this.semanticsLabel,
    this.onLoaded,
    this.onEnd,
    this.onError,
  });

  /// Lottie JSON asset path from the animation registry.
  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Whether to loop the animation. Set to `false` for play-once effects.
  final bool repeat;

  /// Whether to play the animation in reverse.
  final bool reverse;

  /// Whether to start playing immediately. Set to `false` for manual control.
  final bool animate;

  final String? semanticsLabel;

  /// Called when the animation composition finishes loading.
  final void Function(Duration duration)? onLoaded;

  /// Called once when a play-once animation reaches its natural end.
  final VoidCallback? onEnd;

  /// Called when the animation fails to load.
  final void Function(Object error)? onError;

  @override
  State<AppLottie> createState() => _AppLottieState();
}

class _AppLottieState extends State<AppLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _endTimer;
  bool _reducedMotion = false;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(_onControllerTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void dispose() {
    _endTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onControllerTick() {
    if (_controller.value >= 1.0) {
      _notifyEnd();
    }
  }

  void _handleLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;

    if (_reducedMotion) {
      _controller.value = 1.0;
    } else if (!widget.repeat && widget.animate && widget.onEnd != null) {
      _startEndTimer(composition.duration);
    }

    widget.onLoaded?.call(composition.duration);
  }

  void _startEndTimer(Duration duration) {
    _endTimer?.cancel();
    _endTimer = Timer(duration, _notifyEnd);
  }

  void _notifyEnd() {
    if (_ended) {
      return;
    }
    _ended = true;
    widget.onEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final builder = Lottie.asset(
      widget.assetPath,
      controller: _reducedMotion ? _controller : null,
      frameRate: FrameRate.max,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      animate: widget.animate,
      repeat: widget.repeat,
      reverse: widget.reverse,
      onLoaded: _handleLoaded,
      errorBuilder: (context, error, stackTrace) {
        widget.onError?.call(error);
        return const SizedBox.shrink();
      },
    );

    final label = widget.semanticsLabel;
    if (label == null) {
      return builder;
    }
    return Semantics(label: label, image: true, child: builder);
  }
}
