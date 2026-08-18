//**
// frontend/core/navigation/navigation_service.dart
//
// frontend:
// Navigation service. Menyediakan navigation utilities dan InheritedWidget.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi navigation behavior dan deep linking.
//**
import 'package:flutter/material.dart';

class NavigationService {
  NavigationService(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState? get _navigator => _navigatorKey.currentState;

  static NavigationService of(BuildContext context) {
    return _InheritedNavigationService.of(context);
  }

  Future<T?> push<T>(String routeName, {Object? arguments}) {
    return _navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

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

  Future<T?> pushReplacementCustom<T, TO>(Widget page, {TO? result}) {
    return _navigator!.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  Future<T?> pushAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

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

  bool pop<T>([T? result]) {
    if (_navigator == null) return false;
    if (_navigator!.canPop()) {
      _navigator!.pop<T>(result);
      return true;
    }
    return false;
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    _navigator?.popUntil(predicate);
  }

  void popToRoot() {
    _navigator?.popUntil((route) => route.isFirst);
  }

  Future<bool> maybePop<T>([T? result]) async {
    if (_navigator == null) return false;
    return _navigator!.maybePop<T>(result);
  }

  bool get canPop => _navigator?.canPop() ?? false;

  String? get currentRouteName {
    String? currentPath;
    _navigator?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}

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
