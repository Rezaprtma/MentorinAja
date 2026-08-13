import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/core/theme/theme.dart';

import '../../logic/splash_controller.dart';
import '../../logic/splash_state.dart';

/// Static splash screen displaying the brand logo on a solid background.
///
/// The orange background fills the viewport edge-to-edge (no SafeArea inset);
/// only the centered logo sits inside the screen. Remains completely static for
/// the minimum duration, then navigates to the resolved destination once
/// initialization completes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = SplashController();
    _controller.addListener(_onControllerStateChanged);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.start();
    });
  }

  void _onControllerStateChanged() {
    if (mounted) setState(() {});
    _maybeNavigate();
  }

  bool get _canNavigate =>
      _controller.state == SplashState.routing &&
      _controller.destination != null;

  void _maybeNavigate() {
    if (_canNavigate && !_hasNavigated && mounted) {
      _hasNavigated = true;
      Navigator.pushReplacementNamed(context, _controller.destination!);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerStateChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Semantics(
          label: 'MentorinAja',
          child: FractionallySizedBox(
            widthFactor: 0.30,
            child: SvgPicture.asset(
              'assets/icons/icon.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
