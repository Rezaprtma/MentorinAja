import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Google brand mark loaded from the official Google SVG asset.
///
/// Renders `assets/icons/google-icon.svg` unmodified so the multicolor G keeps
/// Google's exact brand colors. No recolor, no OAuth, no network.
class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key, this.size = 20});

  /// Render width/height in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google-icon.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: 'Google',
    );
  }
}

/// Full-width Google sign-in button using Google's official icon assets.
///
/// A flat, white button with a hairline border, no elevation and a pill shape.
/// It supports loading, disabled, hover and pressed feedback while keeping the
/// official Google wordmark colors untouched.
class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final enabled = widget.onPressed != null && !widget.isLoading;

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? ext.card : Colors.white,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? ext.textDisabled
            : ext.textPrimary,
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.pressed)
            ? ext.background.withValues(alpha: 0.6)
            : ext.border.withValues(alpha: 0.4),
      ),
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStatePropertyAll(
        BorderSide(color: _hovered ? ext.textDisabled : ext.border, width: 1),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTypeScale.labelLarge.copyWith(color: ext.textPrimary),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: OutlinedButton(
        onPressed: enabled ? widget.onPressed : null,
        style: style,
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.textPrimary,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GoogleMark(size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text('Continue with Google'),
                ],
              ),
      ),
    );
  }
}
