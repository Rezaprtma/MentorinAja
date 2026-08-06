import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Press-scale feedback wrapper for custom button-like widgets.
///
/// Wraps [child] in a [GestureDetector] + [AnimatedScale] + [AnimatedOpacity]
/// so any widget can have button-like tactile feedback. Use for custom cards,
/// image buttons, or non-standard tappable surfaces.
class AppAnimatedButton extends StatefulWidget {
  const AppAnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.95,
    this.duration = AppDurations.fast,
    this.curve = AppEasing.standard,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;
  final Duration duration;
  final Curve curve;

  @override
  State<AppAnimatedButton> createState() => _AppAnimatedButtonState();
}

class _AppAnimatedButtonState extends State<AppAnimatedButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _pressed ? widget.scaleDown : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.8 : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}
