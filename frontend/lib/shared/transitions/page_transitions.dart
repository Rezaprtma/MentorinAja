import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Reusable page transition presets.
///
/// All transitions consume [AppDurations] and [AppEasing] for consistent
/// motion. Each method returns a [Widget Function] that wraps a page in a
/// [PageRouteBuilder] with the specified transition.
abstract final class AppPageTransitions {
  const AppPageTransitions._();

  /// Cross-fade — subtle, non-directional. Good for same-level screens.
  static PageRouteBuilder<T> fade<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.medium,
      reverseTransitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide from right — standard push. Default for most navigation.
  static PageRouteBuilder<T> slideFromRight<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.medium,
      reverseTransitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppEasing.standard));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from bottom — modal-style, sheets, login.
  static PageRouteBuilder<T> slideFromBottom<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.slow,
      reverseTransitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppEasing.standard));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Scale + fade — pop-in for dialogs and overlays.
  static PageRouteBuilder<T> scaleFade<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.medium,
      reverseTransitionDuration: AppDurations.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: AppEasing.decelerate));
        final fadeTween = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: AppEasing.decelerate));
        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade + slide up — hero-style entrance (splash, onboarding).
  static PageRouteBuilder<T> fadeSlideUp<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.slow,
      reverseTransitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).chain(CurveTween(curve: AppEasing.standard));
        final fadeTween = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: AppEasing.standard));
        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          ),
        );
      },
    );
  }

  /// Platform-adaptive: uses the platform's default transition.
  ///
  /// On iOS/macOS → cupertino-style slide. On Android/web → Material fade.
  static PageRouteBuilder<T> platform<T>(Widget page, {String? name}) {
    return PageRouteBuilder<T>(
      settings: name != null ? RouteSettings(name: name) : null,
      pageBuilder: (_, _, _) => page,
      transitionDuration: AppDurations.medium,
      reverseTransitionDuration: AppDurations.medium,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final platform = Theme.of(context).platform;
        final isApple =
            platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

        if (isApple) {
          final tween = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }

        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
