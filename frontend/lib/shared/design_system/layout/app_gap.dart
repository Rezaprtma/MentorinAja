//**
// frontend/shared/design_system/layout/app_gap.dart
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

class AppGap extends StatelessWidget {
  const AppGap(this.size, {super.key}) : _width = size, _height = size;

  const AppGap.h(double width, {super.key})
    : _width = width,
      _height = null,
      size = null;

  const AppGap.v(double height, {super.key})
    : _width = null,
      _height = height,
      size = null;

  final double? _width;
  final double? _height;
  final double? size;

  static const AppGap xxs = AppGap(AppSpacing.xxs);

  static const AppGap xs = AppGap(AppSpacing.xs);

  static const AppGap sm = AppGap(AppSpacing.sm);

  static const AppGap md = AppGap(AppSpacing.md);

  static const AppGap lg = AppGap(AppSpacing.lg);

  static const AppGap xl = AppGap(AppSpacing.xl);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: _width ?? size, height: _height ?? size);
  }
}
