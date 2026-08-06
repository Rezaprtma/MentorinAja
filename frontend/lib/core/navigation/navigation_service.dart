import 'package:flutter/material.dart';

/// Imperative navigation API that decouples screens from the router
/// implementation.
///
/// Screens call `NavigationService.of(context).push(...)` instead of
/// `Navigator.of(context).push(...)`. This abstraction makes it trivial to
/// swap the navigation backend (Navigator → GoRouter → auto_route) without
/// touching screen code.
///
/// Obtain via `NavigationService.of(context)` or inject via constructor.
class NavigationService {
  NavigationService(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  /// The current [NavigatorState]. Returns `null` if not yet mounted.
  NavigatorState? get _navigator => _navigatorKey.currentState;

  /// Static accessor for descendant widgets.
  static NavigationService of(BuildContext context) {
    return _InheritedNavigationService.of(context);
  }

  // -------------------------------------------------------------------------
  // Push
  // -------------------------------------------------------------------------

  /// Pushes a new route onto the stack.
  Future<T?> push<T>(String routeName, {Object? arguments}) {
    return _navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Pushes a [PageRoute] with a custom [PageRouteBuilder].
  Future<T?> pushCustom<T>(
    Widget page, {
    RouteSettings? settings,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionsBuilder,
  }) {
    return _navigator!.push<T>(
      PageRouteBuilder(
        settings: settings,
        transitionDuration:
            transitionDuration ?? const Duration(milliseconds: 300),
        reverseTransitionDuration:
            reverseTransitionDuration ?? const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            transitionsBuilder ??
            (context, animation, secondaryAnimation, child) => child,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Push replacement
  // -------------------------------------------------------------------------

  /// Replaces the current route.
  Future<T?> pushReplacement<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Replaces the current route with a custom [PageRoute].
  Future<T?> pushReplacementCustom<T, TO>(Widget page, {TO? result}) {
    return _navigator!.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  // -------------------------------------------------------------------------
  // Push and remove
  // -------------------------------------------------------------------------

  /// Pushes a route and removes all previous routes.
  Future<T?> pushAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Pushes a route and removes routes until [predicate] returns true.
  Future<T?> pushUntil<T>(
    String routeName, {
    required bool Function(Route<dynamic>) predicate,
    Object? arguments,
  }) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  // -------------------------------------------------------------------------
  // Pop
  // -------------------------------------------------------------------------

  /// Pops the current route. Returns `true` if a route was popped.
  bool pop<T>([T? result]) {
    if (_navigator == null) return false;
    if (_navigator!.canPop()) {
      _navigator!.pop<T>(result);
      return true;
    }
    return false;
  }

  /// Pops routes until [predicate] returns true.
  void popUntil(bool Function(Route<dynamic>) predicate) {
    _navigator?.popUntil(predicate);
  }

  /// Pops all routes, returning to the root.
  void popToRoot() {
    _navigator?.popUntil((route) => route.isFirst);
  }

  /// Attempts a maybePop (respects WillPopScope / PopScope).
  Future<bool> maybePop<T>([T? result]) async {
    if (_navigator == null) return false;
    return _navigator!.maybePop<T>(result);
  }

  // -------------------------------------------------------------------------
  // Context helpers
  // -------------------------------------------------------------------------

  /// Whether the current navigator can pop (has more than one route).
  bool get canPop => _navigator?.canPop() ?? false;

  /// The current route name, if available.
  String? get currentRouteName {
    String? currentPath;
    _navigator?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}

/// Inherited widget that provides [NavigationService] down the tree.
class _InheritedNavigationService extends InheritedWidget {
  const _InheritedNavigationService({
    required this.service,
    required super.child,
  });

  final NavigationService service;

  static NavigationService of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_InheritedNavigationService>();
    assert(inherited != null, 'No NavigationService found in context');
    return inherited!.service;
  }

  @override
  bool updateShouldNotify(_InheritedNavigationService oldWidget) =>
      service != oldWidget.service;
}

/// Provider widget that makes [NavigationService] available to descendants.
class NavigationProvider extends StatelessWidget {
  const NavigationProvider({
    super.key,
    required this.service,
    required this.child,
  });

  final NavigationService service;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedNavigationService(service: service, child: child);
  }
}
