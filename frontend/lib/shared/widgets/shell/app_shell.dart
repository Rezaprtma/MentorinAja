import 'package:flutter/material.dart';

import 'package:frontend/core/behavior/app_behavior.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/layout/responsive_padding.dart';

/// The outermost application layout.
///
/// [AppShell] wraps the entire app in responsive infrastructure: scroll
/// behavior, keyboard dismissal, and a default page background. Every screen
/// in the app is rendered inside an AppShell — screens never create their own
/// [MaterialApp] or [Scaffold].
///
/// Safe-area handling is intentionally **not** applied here. Screens are
/// responsible for their own SafeArea so that fullscreen screens (splash,
/// onboarding) can paint their backgrounds edge-to-edge. Helper widgets such
/// as [AppPage], [BodyContainer], and [AppSafeArea] provide SafeArea on demand.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => AppShell(child: child!),
/// )
/// ```
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, this.background});

  /// The child route (typically [AppScaffold] or a page).
  final Widget child;

  /// Page background color; defaults to `appColors.background`.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return AppKeyboardDismissOnTap(
      child: ColoredBox(
        color: background ?? context.appColors.background,
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

/// Wrapper that creates a [Scaffold] with consistent theming.
///
/// Most screens do not create their own [Scaffold]. They receive one from
/// [AppScaffold] or [AppPage]. Use this when you need a scaffold with
/// specific [appBar], [bottomNavigationBar], or [floatingActionButton]
/// configurations.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor ?? context.appColors.background,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// A standard page scaffold with optional app bar, scrollable body,
/// safe area, and responsive padding.
///
/// This is the most common screen shell. 90% of screens will use
/// [AppPage] as their root widget.
///
/// ```dart
/// class CourseListScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return AppPage(
///       appBar: AppAppBar(title: 'Courses'),
///       children: [
///         // course tiles
///       ],
///     );
///   }
/// }
/// ```
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    this.appBar,
    this.body,
    this.children,
    this.padding,
    this.scrollController,
    this.physics,
    this.safeArea = true,
    this.background,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.onRefresh,
    this.bottom,
  });

  /// App bar; rendered at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// Raw body widget; mutually exclusive with [children].
  final Widget? body;

  /// Scrollable children; mutually exclusive with [body].
  final List<Widget>? children;

  /// Content padding; defaults to responsive padding.
  final EdgeInsetsGeometry? padding;

  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool safeArea;
  final Color? background;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsivePadding.horizontal(context),
          vertical: AppSpacing.lg,
        );

    Widget content;
    if (body != null) {
      content = body!;
    } else if (children != null && children!.isNotEmpty) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics ?? const BouncingScrollPhysics(),
        padding: effectivePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children!,
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: Theme.of(context).colorScheme.primary,
        child: content,
      );
    }

    if (safeArea) {
      content = AppSafeArea(child: content);
    }

    return AppScaffold(
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: background,
      extendBody: bottomNavigationBar != null,
    );
  }
}

/// A content container that constrains width on large screens.
///
/// On phones, content fills the screen. On tablets and desktops, content
/// is centered and capped at [maxWidth] so line lengths stay readable.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}

/// A content container with background surface and optional elevation.
///
/// Used to visually separate a content block from the page background
/// (e.g. a form card on a settings page).
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.radius,
    this.elevation,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double? radius;
  final double? elevation;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final radiusValue = radius ?? AppRadius.large;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? ext.card,
        borderRadius: BorderRadius.circular(radiusValue),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: elevation! * 4,
                  offset: Offset(0, elevation!),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// A scroll-constrained body container.
///
/// Constrains scroll extent on large screens so content doesn't stretch
/// too wide. Wraps [SingleChildScrollView] with [AppSafeArea].
class BodyContainer extends StatelessWidget {
  const BodyContainer({
    super.key,
    required this.children,
    this.padding,
    this.scrollController,
    this.maxWidth = 720,
    this.safeArea = true,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final double maxWidth;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsivePadding.horizontal(context),
          vertical: AppSpacing.lg,
        );

    Widget content = SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: effectivePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );

    if (safeArea) {
      content = AppSafeArea(child: content);
    }

    return content;
  }
}
