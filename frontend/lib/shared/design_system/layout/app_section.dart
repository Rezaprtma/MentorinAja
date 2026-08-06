import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../navigation/app_section_header.dart';
import 'app_gap.dart';

/// A titled block of content with consistent vertical rhythm.
///
/// Composes [AppSectionHeader] (title + optional action) with a column of
/// [children] separated by [spacing]. Sections give screens a repeatable
/// "heading + content" unit so page layout stays consistent across the app.
class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.children = const [],
    this.spacing = AppSpacing.sm,
    this.padding = EdgeInsets.zero,
  });

  /// Section title shown in the header.
  final String title;

  /// Optional supporting text under the title.
  final String? subtitle;

  /// Optional trailing widget in the header (e.g. a "See all" button).
  final Widget? trailing;

  /// Content of the section.
  final List<Widget> children;

  /// Vertical gap between header and children and between children.
  final double spacing;

  /// Outer padding around the whole section.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Padding(
        padding: padding,
        child: AppSectionHeader(
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      );
    }
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          ),
          AppGap.v(spacing),
          ..._spaced(children),
        ],
      ),
    );
  }

  List<Widget> _spaced(List<Widget> items) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) result.add(AppGap.v(spacing));
      result.add(items[i]);
    }
    return result;
  }
}
