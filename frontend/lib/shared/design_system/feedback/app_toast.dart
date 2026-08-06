import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Lightweight, non-modal toast notification overlay.
///
/// Unlike [SnackBar], a toast appears centered at the top of the screen and
/// auto-dismisses without user action. Useful for ephemeral confirmations
/// ("Copied", "Saved") that should not block the UI.
class AppToast {
  AppToast._();

  static OverlayEntry? _current;

  /// Shows a centered toast. Replaces any existing toast.
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    IconData icon = Icons.check_circle_outline,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => _AppToastWidget(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );

    _current = entry;
    overlay.insert(entry);

    Timer(duration, () {
      if (entry.mounted) {
        entry.remove();
        if (_current == entry) _current = null;
      }
    });
  }

  /// Dismisses the current toast immediately.
  static void dismiss() {
    _current?.remove();
    _current = null;
  }
}

class _AppToastWidget extends StatefulWidget {
  const _AppToastWidget({
    required this.message,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.medium,
    );
    _fade = CurvedAnimation(parent: _controller, curve: AppEasing.decelerate);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(_fade);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = widget.backgroundColor ?? scheme.inverseSurface;
    final fg = widget.foregroundColor ?? scheme.onInverseSurface;

    return Positioned(
      top: MediaQuery.paddingOf(context).top + AppSpacing.md,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                boxShadow: const [AppShadow.raised],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: fg, size: AppIconSizes.md),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: AppTypeScale.bodyMedium.copyWith(color: fg),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
