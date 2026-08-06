import 'package:flutter/material.dart';

import 'navigation_service.dart';

/// Convenience extensions on [BuildContext] for navigation.
///
/// Reduces boilerplate at call sites:
/// ```dart
/// context.push(AppRoutes.settings);
/// context.pushReplacement(AppRoutes.home);
/// context.pop();
/// ```
extension AppNavigationContext on BuildContext {
  NavigationService get nav => NavigationService.of(this);

  /// Pushes a named route.
  Future<T?> push<T>(String routeName, {Object? arguments}) =>
      nav.push<T>(routeName, arguments: arguments);

  /// Pushes a custom page with [PageRouteBuilder].
  Future<T?> pushPage<T>(Widget page) => nav.pushCustom<T>(page);

  /// Replaces the current route.
  Future<T?> pushReplacement<T, TO>(String routeName, {TO? result}) =>
      nav.pushReplacement<T, TO>(routeName, result: result);

  /// Pushes a route and removes all previous routes.
  Future<T?> pushAndRemoveAll<T>(String routeName) =>
      nav.pushAndRemoveAll<T>(routeName);

  /// Pops the current route.
  bool pop<T>([T? result]) => nav.pop<T>(result);

  /// Pops to the root route.
  void popToRoot() => nav.popToRoot();

  /// Whether the navigator can pop.
  bool get canPop => nav.canPop;
}
