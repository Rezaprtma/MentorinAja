//**
// frontend/routing/route_guard.dart
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

class RouteGuard extends StatelessWidget {
  const RouteGuard({
    super.key,
    required this.canAccess,
    required this.redirectTo,
    required this.child,
    this.builder,
  });

  final bool Function() canAccess;

  final String redirectTo;

  final Widget child;

  final Widget Function(BuildContext context, bool allowed, Widget child)?
  builder;

  @override
  Widget build(BuildContext context) {
    final allowed = canAccess();

    if (builder != null) {
      return builder!(context, allowed, child);
    }

    if (!allowed) {
      return _GuardRedirectPlaceholder(route: redirectTo);
    }

    return child;
  }
}

class _GuardRedirectPlaceholder extends StatelessWidget {
  const _GuardRedirectPlaceholder({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class GuardedRouteParser {
  const GuardedRouteParser({required this.guards});

  final List<RouteGuardConfig> guards;

  String? evaluate(String routeName) {
    for (final guard in guards) {
      if (guard.routes.contains(routeName) && !guard.canAccess()) {
        return guard.redirectTo;
      }
    }
    return null;
  }
}

class RouteGuardConfig {
  const RouteGuardConfig({
    required this.routes,
    required this.canAccess,
    required this.redirectTo,
  });

  final List<String> routes;
  final bool Function() canAccess;
  final String redirectTo;
}
