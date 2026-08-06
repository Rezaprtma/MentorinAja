import 'dart:async';

import 'package:flutter/foundation.dart';

import 'splash_router.dart';
import 'splash_state.dart';

/// Splash screen controller.
///
/// Manages the splash lifecycle:
/// - Runs the bootstrap pipeline
/// - Tracks the state machine
/// - Enforces the minimum duration timer
/// - Exposes state for the UI via [ValueNotifier]
///
/// The controller owns NO widgets and performs NO navigation directly.
/// The screen listens to [state] and triggers navigation when state == [SplashState.routing].
///
/// ```dart
/// final controller = SplashController();
/// controller.addListener(() {
///   if (controller.state == SplashState.routing) {
///     Navigator.pushReplacementNamed(context, controller.destination!);
///   }
/// });
/// controller.start();
/// ```
class SplashController extends ChangeNotifier {
  SplashController({Duration minimumDuration = const Duration(seconds: 2)})
    : _minimumDuration = minimumDuration; // ignore: prefer_initializing_formals

  final Duration _minimumDuration;

  SplashState _state = SplashState.idle;
  String? _destination;
  Timer? _minimumDurationTimer;
  bool _initializationComplete = false;
  bool _minimumDurationElapsed = false;

  /// Current state of the splash lifecycle.
  SplashState get state => _state;

  /// Navigation destination (populated after [SplashState.routing]).
  String? get destination => _destination;

  /// Whether the controller has been disposed.
  bool _isDisposed = false;

  /// Starts the splash lifecycle.
  ///
  /// Called once when the splash screen mounts.
  /// Transitions from [SplashState.idle] to [SplashState.initializing].
  void start() {
    if (_state != SplashState.idle) return;
    _transitionTo(SplashState.initializing);
    _startInitialization();
    _startMinimumDurationTimer();
  }

  /// Retries initialization after an error.
  ///
  /// Transitions from [SplashState.error] to [SplashState.initializing].
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

  /// Starts the bootstrap pipeline.
  ///
  /// This is where theme initialization, preference loading, and
  /// routing preparation happen. Currently stubbed for Phase 6.1.
  Future<void> _startInitialization() async {
    try {
      // Step 1: Initialize Theme (already done by MaterialApp)
      // Step 2: Load User Preferences (stub)
      await _loadPreferencesStub();

      // Step 3: Prepare Routing (stub)
      await _prepareRoutingStub();

      // Step 4: Check First Launch (stub)
      final isFirstLaunch = _checkFirstLaunchStub();

      // Step 5: Check Authentication (stub)
      final isAuthenticated = _checkAuthenticationStub();

      // Step 6: Determine Destination
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

  /// Starts the 2-second minimum duration timer.
  void _startMinimumDurationTimer() {
    _minimumDurationTimer?.cancel();
    _minimumDurationTimer = Timer(_minimumDuration, () {
      _minimumDurationElapsed = true;
      _checkTransitionToRouting();
    });
  }

  /// Checks if both conditions are met to transition to routing.
  void _checkTransitionToRouting() {
    if (_initializationComplete && _minimumDurationElapsed) {
      _transitionTo(SplashState.routing);
    }
  }

  /// Performs a state transition and notifies listeners.
  void _transitionTo(SplashState newState) {
    if (_state == newState) return;
    _state = newState;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Stub methods (to be replaced in future phases)
  // -------------------------------------------------------------------------

  /// Stub: Returns empty preferences.
  Future<void> _loadPreferencesStub() async {
    // Simulate async work
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  /// Stub: Prepares routing.
  Future<void> _prepareRoutingStub() async {
    // Simulate async work
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  /// Stub: Always returns true (first launch).
  bool _checkFirstLaunchStub() {
    return true;
  }

  /// Stub: Always returns false (unauthenticated).
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
