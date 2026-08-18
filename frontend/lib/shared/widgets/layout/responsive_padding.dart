//**
// frontend/shared/widgets/layout/responsive_padding.dart
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

import '../../../core/theme/theme.dart';

abstract final class ResponsivePadding {
  static double horizontal(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return AppSpacing.xl;
    if (width >= 840) return AppSpacing.lg;
    return AppSpacing.md;
  }

  static double vertical(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.xl;
    return AppSpacing.lg;
  }

  static EdgeInsets symmetric(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontal(context),
      vertical: vertical(context),
    );
  }
}

abstract final class ResponsiveSpacing {
  static double sectionGap(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.xl;
    return AppSpacing.lg;
  }

  static double itemGap(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 840) return AppSpacing.md;
    return AppSpacing.sm;
  }
}
