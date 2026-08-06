import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom [ScrollBehavior] for MentorinAja.
///
/// Removes the overscroll glow on Android (uses stretch instead) and
/// enables mouse-wheel scrolling on desktop. Material 3 compliant.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // On Android, use ClampingScrollPhysics (no glow) for a cleaner look.
    // On iOS/macOS, use BouncingScrollPhysics (native feel).
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return const ClampingScrollPhysics();
    }
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return const BouncingScrollPhysics();
    }
    // Web, Linux, Windows: bouncing for mouse wheel
    return const BouncingScrollPhysics();
  }
}

/// Dismisses the keyboard when the user taps outside a text field or drags
/// on a scrollable area.
///
/// Wrap any scrollable content or scaffold body in this widget.
///
/// ```dart
/// AppKeyboardDismissOnTap(
///   child: ListView(children: [...]),
/// )
/// ```
class AppKeyboardDismissOnTap extends StatelessWidget {
  const AppKeyboardDismissOnTap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _dismissKeyboard(context),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  void _dismissKeyboard(BuildContext context) {
    final focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus) {
      focus.unfocus();
    }
  }
}

/// Wraps content with keyboard-aware padding to prevent overflow.
///
/// Uses [MediaQuery.viewInsetsOf] to add bottom padding equal to the
/// keyboard height. This prevents the keyboard from overlapping content
/// without using `resizeToAvoidBottomInset: true` (which can cause jumps).
///
/// ```dart
/// AppKeyboardPadding(
///   child: Column(children: [TextField(), ...]),
/// )
/// ```
class AppKeyboardPadding extends StatelessWidget {
  const AppKeyboardPadding({super.key, required this.child, this.minimum = 0});

  final Widget child;

  /// Minimum bottom padding even when keyboard is hidden.
  final double minimum;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final padding = keyboardHeight > minimum ? keyboardHeight : minimum;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: padding),
      child: child,
    );
  }
}

/// Focus traversal button handler for keyboard navigation.
///
/// Wraps a widget so that pressing Enter or Space on a focused button
/// triggers its [onPressed]. Used for accessibility compliance.
class AppKeyboardActivation extends StatelessWidget {
  const AppKeyboardActivation({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): _ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): _ActivateIntent(),
      },
      child: Actions(
        actions: {
          _ActivateIntent: CallbackAction<_ActivateIntent>(
            onInvoke: (_) {
              onPressed?.call();
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}

class _ActivateIntent extends Intent {
  const _ActivateIntent();
}
