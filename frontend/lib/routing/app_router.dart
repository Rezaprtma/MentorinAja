//**
// frontend/routing/app_router.dart
//
// frontend:
// Routing. Menyediakan route definitions dan navigation logic.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi routing behavior dan deep linking.
//**
import 'package:flutter/material.dart';

import '../routing/route_names.dart';

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

@immutable
class AppRouteConfiguration {
  const AppRouteConfiguration({required this.path, this.extra});

  final String path;
  final Object? extra;
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Route: $path')));
  }
}
