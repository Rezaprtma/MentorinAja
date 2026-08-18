//**
// frontend/core/behavior/app_behavior.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return const ClampingScrollPhysics();
    }
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return const BouncingScrollPhysics();
    }

    return const BouncingScrollPhysics();
  }
}

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

class AppKeyboardPadding extends StatelessWidget {
  const AppKeyboardPadding({super.key, required this.child, this.minimum = 0});

  final Widget child;

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
