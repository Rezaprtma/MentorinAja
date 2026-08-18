//**
// frontend/shared/design_system/layout/app_section.dart
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
import '../navigation/app_section_header.dart';
import 'app_gap.dart';

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

  final String title;

  final String? subtitle;

  final Widget? trailing;

  final List<Widget> children;

  final double spacing;

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
