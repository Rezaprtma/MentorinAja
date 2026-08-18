//**
// frontend/shared/widgets/shell/app_shell.dart
//
// frontend:
// Shared widget. Menyediakan reusable UI components untuk feature screens.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering dan behavior.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/behavior/app_behavior.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/layout/responsive_padding.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, this.background});

  final Widget child;

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

  final PreferredSizeWidget? appBar;

  final Widget? body;

  final List<Widget>? children;

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
