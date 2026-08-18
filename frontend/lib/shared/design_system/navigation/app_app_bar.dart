//**
// frontend/shared/design_system/navigation/app_app_bar.dart
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

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.elevation,
    this.backgroundColor,
    this.centerTitle,
    this.titleSpacing,
  });

  final String? title;

  final Widget? titleWidget;

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final List<Widget>? actions;

  final PreferredSizeWidget? bottom;

  final double? elevation;

  final Color? backgroundColor;

  final bool? centerTitle;

  final double? titleSpacing;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final canPop = Navigator.of(context).canPop();

    final effectiveLeading =
        (automaticallyImplyLeading && canPop && leading == null)
        ? const BackButton()
        : leading;

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: effectiveLeading,
      automaticallyImplyLeading: false,
      actions: actions,
      bottom: bottom,
      elevation: elevation ?? AppElevation.xs,
      scrolledUnderElevation: AppElevation.xs,
      backgroundColor: backgroundColor ?? ext.background,
      foregroundColor: ext.textPrimary,
      centerTitle: centerTitle ?? false,
      titleSpacing: titleSpacing,
      titleTextStyle: AppTypeScale.titleLarge.copyWith(color: ext.textPrimary),
    );
  }
}
