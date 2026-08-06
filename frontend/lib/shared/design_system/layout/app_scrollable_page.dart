import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../navigation/app_app_bar.dart';
import 'app_safe_area.dart';

/// A scaffold-ready scrollable page with safe-area, padding and refresh
/// support.
///
/// The most common screen shell: an optional [AppAppBar], a
/// [RefreshIndicator] when [onRefresh] is provided, a vertical scroll view and
/// consistent horizontal padding from the design tokens. Use this for
/// read-mostly pages (home, profile, settings) so every screen inherits the
/// same content insets and keyboard behavior.
class AppScrollablePage extends StatelessWidget {
  const AppScrollablePage({
    super.key,
    this.appBar,
    this.title,
    this.onRefresh,
    this.children = const [],
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.lg,
    ),
    this.scrollController,
    this.physics,
    this.safeArea = true,
    this.background,
  });

  /// Optional app bar rendered at the top of the scaffold.
  final AppAppBar? appBar;

  /// When [appBar] is null a simple title-only bar is shown if set.
  final String? title;

  /// Pull-to-refresh callback; enables [RefreshIndicator] when non-null.
  final Future<void> Function()? onRefresh;

  /// Scrollable content.
  final List<Widget> children;

  /// Content padding; defaults to `16` horizontal / `24` vertical.
  final EdgeInsetsGeometry padding;

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  /// Optional scroll physics override.
  final ScrollPhysics? physics;

  /// Whether to wrap the body in an [AppSafeArea].
  final bool safeArea;

  /// Background color; defaults to `appColors.background`.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    Widget body = SingleChildScrollView(
      controller: scrollController,
      physics: physics,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (onRefresh != null) {
      body = RefreshIndicator(
        onRefresh: onRefresh!,
        color: Theme.of(context).colorScheme.primary,
        child: body,
      );
    }

    if (safeArea) {
      body = AppSafeArea(child: body);
    }

    return Scaffold(
      backgroundColor: background ?? context.appColors.background,
      appBar: appBar ?? (title != null ? AppAppBar(title: title!) : null),
      body: body,
    );
  }
}
