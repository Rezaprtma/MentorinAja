//**
// frontend/features/auth/presentation/widgets/google_auth_button.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/logo/google-icon.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: 'Google',
    );
  }
}

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
