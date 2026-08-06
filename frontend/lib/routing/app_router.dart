import 'package:flutter/material.dart';

import '../routing/route_names.dart';

/// Navigator 2.0 based router for MentorinAja.
///
/// This router uses Flutter's built-in [Router] API (no third-party package).
/// It parses URL-like route paths into route stacks and delegates navigation
/// to a [RouterDelegate]. When GoRouter or another package is added later,
/// only this file needs to change — screens and services are decoupled via
/// [NavigationService].
///
/// For now, the router maintains a simple path-based stack. Deep-link parsing
/// is handled by [AppRouteInformationParser] and state management by
/// [AppRouterDelegate].
class AppRouter {
  AppRouter({required this.navigatorKey, this.initialRoute = AppRoutes.home});

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  late final AppRouteInformationParser informationParser =
      AppRouteInformationParser();
  late final AppRouterDelegate delegate = AppRouterDelegate(
    navigatorKey: navigatorKey,
    initialRoute: initialRoute,
  );
}

/// Converts between route information (URL strings) and route configuration.
class AppRouteInformationParser
    extends RouteInformationParser<AppRouteConfiguration> {
  @override
  Future<AppRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final path = uri.path.isEmpty ? AppRoutes.home : uri.path;

    return AppRouteConfiguration(path: path);
  }

  @override
  RouteInformation restoreRouteInformation(
    AppRouteConfiguration configuration,
  ) {
    return RouteInformation(uri: Uri.parse(configuration.path));
  }
}

/// Holds the current navigation state as a stack of paths.
class AppRouterDelegate extends RouterDelegate<AppRouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AppRouteConfiguration> {
  AppRouterDelegate({required this.navigatorKey, required this.initialRoute});

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  final List<String> _stack = [];

  @override
  AppRouteConfiguration get currentConfiguration {
    if (_stack.isEmpty) return AppRouteConfiguration(path: initialRoute);
    return AppRouteConfiguration(path: _stack.last);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        final key = page.key?.toString() ?? '';
        _stack.removeWhere((s) => s == key);
        notifyListeners();
      },
    );
  }

  List<Page> _buildPages() {
    if (_stack.isEmpty) {
      return [_buildPage(initialRoute, key: 'initial')];
    }
    return _stack.map((path) => _buildPage(path, key: path)).toList();
  }

  Page _buildPage(String path, {String? key}) {
    final widget = _resolvePage(path);
    return MaterialPage(key: ValueKey(key ?? path), name: path, child: widget);
  }

  Widget _resolvePage(String path) {
    // Route resolution happens here. Each feature module registers its
    // route builder in the app startup. For now, return a placeholder
    // that demonstrates the routing works.
    //
    // Future integration: route registry pattern.
    return _PlaceholderScreen(path: path);
  }

  @override
  Future<bool> popRoute() async {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  Future<void> setNewRoutePath(AppRouteConfiguration configuration) async {
    _stack
      ..clear()
      ..add(configuration.path);
    notifyListeners();
  }

  @override
  Future<void> setRestoredRoutePath(AppRouteConfiguration configuration) async {
    setNewRoutePath(configuration);
  }
}

/// Immutable route configuration (path + optional extra data).
@immutable
class AppRouteConfiguration {
  const AppRouteConfiguration({required this.path, this.extra});

  final String path;
  final Object? extra;
}

/// Placeholder screen used during route resolution.
/// Will be replaced by actual feature screens.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Route: $path')));
  }
}
