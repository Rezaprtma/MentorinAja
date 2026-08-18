//**
// frontend/features/splash/presentation/screens/splash_screen.dart
//
// frontend:
// Renders startup loading sequence while holding the native splash.
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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:frontend/core/theme/theme.dart';

import '../../logic/splash_controller.dart';
import '../../logic/splash_state.dart';

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
    // Use minimumDuration = zero so that it completes initialization immediately,
    // transiting seamlessly into the actual page under the native splash framework.
    _controller = SplashController(minimumDuration: Duration.zero);
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
      FlutterNativeSplash.remove();
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
    // Return a solid Primary Color scaffold matching the native splash background,
    // with NO logo image. This prevents the "double logo/double splash animation" experience.
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox.shrink(),
    );
  }
}
