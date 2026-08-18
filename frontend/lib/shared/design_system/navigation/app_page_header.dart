//**
// frontend/shared/design_system/navigation/app_page_header.dart
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
import '../layout/app_gap.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.only(
      left: AppSpacing.md,
      right: AppSpacing.md,
      top: AppSpacing.lg,
      bottom: AppSpacing.sm,
    ),
  });

  final String title;

  final String? subtitle;

  final Widget? trailing;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypeScale.headlineSmall.copyWith(
                    color: ext.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  AppGap.xs,
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[AppGap.md, trailing!],
        ],
      ),
    );
  }
}
