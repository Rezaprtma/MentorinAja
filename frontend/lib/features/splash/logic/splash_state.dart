/// Splash screen state machine.
///
/// Defines the deterministic lifecycle of the splash experience:
///
/// ```text
/// Idle → Initializing → WaitingMinimumDuration → Routing → Completed
///                           ↓ (error)
///                         Error → (retry) → Initializing
/// ```
///
/// Each state represents a distinct phase of the splash lifecycle.
/// Transitions are managed exclusively by [SplashController].
enum SplashState {
  /// Initial state before initialization begins.
  ///
  /// Transitions to [initializing] when the widget mounts and
  /// the bootstrap pipeline starts.
  idle,

  /// Running the bootstrap pipeline.
  ///
  /// Activities:
  /// - Initialize theme
  /// - Load user preferences (stub)
  /// - Prepare routing
  /// - Check first launch (stub)
  /// - Check authentication (stub)
  /// - Determine navigation destination
  ///
  /// Simultaneously starts the 2-second minimum duration timer.
  ///
  /// Transitions:
  /// - → [waitingMinimumDuration] if initialization completes before 2 seconds
  /// - → [routing] if initialization completes after 2 seconds
  /// - → [error] if initialization fails
  initializing,

  /// Initialization completed but minimum duration hasn't elapsed.
  ///
  /// This state exists only when initialization is faster than 2 seconds.
  /// The timer continues running in parallel.
  ///
  /// Transitions:
  /// - → [routing] when the 2-second timer completes
  waitingMinimumDuration,

  /// Both conditions met: initialization complete + minimum duration elapsed.
  ///
  /// The navigation destination is determined here. This is a transient state
  /// that immediately triggers navigation.
  ///
  /// Transitions:
  /// - → [completed] after navigation is triggered
  routing,

  /// Splash finished. App is in normal navigation state.
  ///
  /// Terminal state. No further transitions.
  completed,

  /// Initialization failed.
  ///
  /// Shows error screen with retry button.
  ///
  /// Transitions:
  /// - → [initializing] if user taps retry
  error,
}
