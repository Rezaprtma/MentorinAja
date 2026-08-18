//**
// frontend/features/splash/logic/splash_controller.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'splash_router.dart';
import 'splash_state.dart';

class SplashController extends ChangeNotifier {
  SplashController({Duration minimumDuration = const Duration(seconds: 2)})
    : _minimumDuration = minimumDuration;

  final Duration _minimumDuration;

  SplashState _state = SplashState.idle;
  String? _destination;
  Timer? _minimumDurationTimer;
  bool _initializationComplete = false;
  bool _minimumDurationElapsed = false;

  SplashState get state => _state;

  String? get destination => _destination;

  bool _isDisposed = false;

  void start() {
    if (_state != SplashState.idle) return;
    _transitionTo(SplashState.initializing);
    _startInitialization();
    _startMinimumDurationTimer();
  }

  void retry() {
    if (_state != SplashState.error) return;
    _initializationComplete = false;
    _minimumDurationElapsed = false;
    _destination = null;
    _minimumDurationTimer?.cancel();
    _transitionTo(SplashState.initializing);
    _startInitialization();
    _startMinimumDurationTimer();
  }

  Future<void> _startInitialization() async {
    try {
      await _loadPreferencesStub();

      await _prepareRoutingStub();

      final isFirstLaunch = _checkFirstLaunchStub();

      final isAuthenticated = _checkAuthenticationStub();

      _destination = SplashRouter.determineDestination(
        isFirstLaunch: isFirstLaunch,
        isAuthenticated: isAuthenticated,
      );

      _initializationComplete = true;
      _checkTransitionToRouting();
    } catch (e) {
      _transitionTo(SplashState.error);
    }
  }

  void _startMinimumDurationTimer() {
    _minimumDurationTimer?.cancel();
    _minimumDurationTimer = Timer(_minimumDuration, () {
      _minimumDurationElapsed = true;
      _checkTransitionToRouting();
    });
  }

  void _checkTransitionToRouting() {
    if (_initializationComplete && _minimumDurationElapsed) {
      _transitionTo(SplashState.routing);
    }
  }

  void _transitionTo(SplashState newState) {
    if (_state == newState) return;
    _state = newState;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> _loadPreferencesStub() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> _prepareRoutingStub() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  bool _checkFirstLaunchStub() {
    return true;
  }

  bool _checkAuthenticationStub() {
    return false;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _minimumDurationTimer?.cancel();
    _minimumDurationTimer = null;
    super.dispose();
  }
}
