//**
// frontend/shared/design_system/layout/app_scrollable_page.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../navigation/app_app_bar.dart';
import 'app_safe_area.dart';

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

  final AppAppBar? appBar;

  final String? title;

  final Future<void> Function()? onRefresh;

  final List<Widget> children;

  final EdgeInsetsGeometry padding;

  final ScrollController? scrollController;

  final ScrollPhysics? physics;

  final bool safeArea;

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
