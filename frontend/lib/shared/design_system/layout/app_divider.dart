//**
// frontend/shared/design_system/layout/app_divider.dart
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

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = AppSpacing.md,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  final double height;

  final double? thickness;

  final double indent;

  final double endIndent;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.appColors.divider,
    );
  }
}
