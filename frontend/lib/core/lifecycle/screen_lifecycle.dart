import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Declarative screen state machine.
///
/// Every screen's body can be in one of four states: [loading], [empty],
/// [error], or [ready]. [ScreenLifecycleWrapper] renders the correct
/// UI for each state so screens never rewrite scaffold/chrome code.
///
/// ```dart
/// ScreenLifecycleWrapper(
///   state: _state,
///   onRetry: _loadData,
///   emptyIcon: Icons.school_outlined,
///   emptyTitle: 'No courses yet',
///   ready: ListView(children: _courses),
/// )
/// ```
enum ScreenState {
  /// Data is being fetched.
  loading,

  /// Data loaded successfully but the list/content is empty.
  empty,

  /// An error occurred.
  error,

  /// Data is ready; render [ready] content.
  ready,

  /// Offline — no network connection.
  offline,
}

/// Renders the appropriate UI for the current [ScreenState].
///
/// Screens delegate their state presentation to this widget. This eliminates
/// the pattern where every screen has its own loading/empty/error blocks.
class ScreenLifecycleWrapper extends StatelessWidget {
  const ScreenLifecycleWrapper({
    super.key,
    required this.state,
    required this.ready,
    this.onRetry,
    this.loadingWidget,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.emptyActionLabel,
    this.emptyAction,
    this.errorIcon = Icons.error_outline,
    this.errorTitle = 'Something went wrong',
    this.errorMessage,
    this.errorActionLabel = 'Retry',
    this.offlineIcon = Icons.wifi_off_outlined,
    this.offlineTitle = 'No connection',
    this.offlineMessage,
    this.offlineActionLabel = 'Retry',
  });

  final ScreenState state;
  final Widget ready;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;

  // Empty state
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? emptyAction;

  // Error state
  final IconData errorIcon;
  final String errorTitle;
  final String? errorMessage;
  final String errorActionLabel;

  // Offline state
  final IconData offlineIcon;
  final String offlineTitle;
  final String? offlineMessage;
  final String offlineActionLabel;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScreenState.loading =>
        loadingWidget ?? const AppCircularLoader(centered: true),
      ScreenState.empty => AppEmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: emptyActionLabel,
        onAction: emptyAction ?? onRetry,
      ),
      ScreenState.error => AppEmptyState(
        icon: errorIcon,
        title: errorTitle,
        message: errorMessage,
        actionLabel: errorActionLabel,
        onAction: onRetry,
      ),
      ScreenState.offline => AppEmptyState(
        icon: offlineIcon,
        title: offlineTitle,
        message: offlineMessage,
        actionLabel: offlineActionLabel,
        onAction: onRetry,
      ),
      ScreenState.ready => ready,
    };
  }
}

/// Mixin that provides screen lifecycle state management.
///
/// Use on [StatefulWidget] states that manage async data loading:
///
/// ```dart
/// class _CourseListState extends State<CourseListScreen>
///     with ScreenLifecycleMixin {
///   @override
///   ScreenState get initialState => ScreenState.loading;
///
///   @override
///   void initState() {
///     super.initState();
///     _loadCourses();
///   }
///
///   Future<void> _loadCourses() async {
///     setState(() => screenState = ScreenState.loading);
///     try {
///       final courses = await _repo.getCourses();
///       setState(() {
///         _courses = courses;
///         screenState = courses.isEmpty ? ScreenState.empty : ScreenState.ready;
///       });
///     } catch (e) {
///       setState(() => screenState = ScreenState.error);
///     }
///   }
/// }
/// ```
mixin ScreenLifecycleMixin<T extends StatefulWidget> on State<T> {
  /// The initial state when the widget is first built.
  ScreenState get initialState => ScreenState.loading;

  /// Current screen state. Setting this triggers a rebuild.
  ScreenState get screenState => _screenState;
  set screenState(ScreenState value) {
    if (_screenState != value) {
      setState(() => _screenState = value);
    }
  }

  ScreenState _screenState = ScreenState.loading;

  @override
  void initState() {
    super.initState();
    _screenState = initialState;
  }
}
