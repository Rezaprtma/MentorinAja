import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Themed app bar with automatic back-button logic.
///
/// Wraps [AppBar] to standardize the top navigation bar across the app:
/// consistent title style, back-button handling via [Navigator.canPop], and
/// optional bottom widgets. Implements [PreferredSizeWidget] so it slots
/// directly into [Scaffold.appBar].
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

  /// Simple text title; ignored when [titleWidget] is provided.
  final String? title;

  /// Custom title widget; overrides [title].
  final Widget? titleWidget;

  /// Custom leading widget; overrides automatic back-button logic.
  final Widget? leading;

  /// Whether to show a back button when [Navigator.canPop] is true.
  final bool automaticallyImplyLeading;

  /// Trailing action buttons.
  final List<Widget>? actions;

  /// Optional bottom widget (e.g. [TabBar]).
  final PreferredSizeWidget? bottom;

  /// Scroll-under elevation; defaults to [AppElevation.xs].
  final double? elevation;

  /// Background color; defaults to theme background.
  final Color? backgroundColor;

  /// Center the title; defaults to false on mobile, true on wider layouts.
  final bool? centerTitle;

  /// Title spacing; defaults to standard.
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
