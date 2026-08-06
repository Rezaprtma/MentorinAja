import 'package:flutter/material.dart';

/// Guard that controls navigation access based on a predicate.
///
/// Used with the router to implement authentication guards, feature flags,
/// maintenance mode, etc. The guard evaluates [canAccess] and either allows
/// navigation or redirects to [redirectTo].
///
/// ```dart
/// RouteGuard(
///   canAccess: () => authService.isAuthenticated,
///   redirectTo: AppRoutes.authentication,
///   child: AppShell(child: router),
/// )
/// ```
class RouteGuard extends StatelessWidget {
  const RouteGuard({
    super.key,
    required this.canAccess,
    required this.redirectTo,
    required this.child,
    this.builder,
  });

  /// Predicate evaluated on each navigation.
  final bool Function() canAccess;

  /// Route to redirect to when [canAccess] returns false.
  final String redirectTo;

  /// The child widget (typically the router).
  final Widget child;

  /// Optional builder that receives the guard result.
  final Widget Function(BuildContext context, bool allowed, Widget child)?
  builder;

  @override
  Widget build(BuildContext context) {
    final allowed = canAccess();

    if (builder != null) {
      return builder!(context, allowed, child);
    }

    if (!allowed) {
      // Instead of navigating, show a redirect placeholder.
      // The actual navigation happens in the router delegate.
      return _GuardRedirectPlaceholder(route: redirectTo);
    }

    return child;
  }
}

/// Placeholder shown while the guard redirects.
class _GuardRedirectPlaceholder extends StatelessWidget {
  const _GuardRedirectPlaceholder({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    // Schedule navigation after the current frame to avoid
    // "setState() or markNeedsBuild() called during build" errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// A [RouteInformationParser] extension that applies guards before resolving.
///
/// Not used directly by the router — provided as a utility for future
/// guard integration.
class GuardedRouteParser {
  const GuardedRouteParser({required this.guards});

  final List<RouteGuardConfig> guards;

  /// Evaluates all guards. Returns the first redirect route, or `null`
  /// if all guards pass.
  String? evaluate(String routeName) {
    for (final guard in guards) {
      if (guard.routes.contains(routeName) && !guard.canAccess()) {
        return guard.redirectTo;
      }
    }
    return null;
  }
}

/// Configuration for a single guard rule.
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
