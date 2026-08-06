import 'package:flutter/material.dart';

import '../../../core/responsive/app_breakpoints.dart';
import '../../../core/theme/theme.dart';

/// A container that constrains its child's width and centers it on large
/// screens.
///
/// On phones, the child fills available width. On tablets and desktops,
/// content is centered within [maxWidth] so line lengths stay readable.
/// This is the primary content-width constraint for the entire app.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// A width-constraining container for form-like or article content.
///
/// Stricter than [ResponsiveContainer]. Used for reading-heavy layouts
/// (articles, lesson content, quiz questions) where line length matters.
class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth = 560,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// A responsive grid that adapts column count to screen width.
///
/// Instead of manually choosing grid layouts per screen, declare intent:
///
/// ```dart
/// AdaptiveGrid(
///   phoneColumns: 1,
///   tabletColumns: 2,
///   desktopColumns: 3,
///   spacing: AppSpacing.md,
///   children: items.map((i) => CourseCard(course: i)).toList(),
/// )
/// ```
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    this.phoneColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = AppSpacing.md,
    this.runSpacing,
    required this.children,
    this.padding,
  });

  final int phoneColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double? runSpacing;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final columns = _columns(context);
    final effectiveRunSpacing = runSpacing ?? spacing;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSpacing = spacing * (columns - 1);
          final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: effectiveRunSpacing,
            children: children
                .map((child) => SizedBox(width: itemWidth, child: child))
                .toList(),
          );
        },
      ),
    );
  }

  int _columns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.tablet) return desktopColumns;
    if (width >= AppBreakpoints.phone) return tabletColumns;
    return phoneColumns;
  }
}

/// A responsive column layout that switches between vertical and horizontal.
///
/// On phones: vertical stack. On wider screens: horizontal row with
/// proportional widths. Useful for detail pages (image + info side by side).
class AdaptiveColumn extends StatelessWidget {
  const AdaptiveColumn({
    super.key,
    this.compactDirection = Axis.vertical,
    this.expandedDirection = Axis.horizontal,
    this.breakpoint = AppBreakpoints.smallTablet,
    this.spacing = AppSpacing.md,
    required this.children,
  });

  final Axis compactDirection;
  final Axis expandedDirection;
  final double breakpoint;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isExpanded = width >= breakpoint;
    final direction = isExpanded ? expandedDirection : compactDirection;

    if (direction == Axis.horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(children, Axis.horizontal),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _withSpacing(children, Axis.vertical),
    );
  }

  List<Widget> _withSpacing(List<Widget> items, Axis axis) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        result.add(
          axis == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
      result.add(Expanded(flex: 1, child: items[i]));
    }
    return result;
  }
}
