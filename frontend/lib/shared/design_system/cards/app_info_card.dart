//**
// frontend/shared/design_system/cards/app_info_card.dart
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
import 'app_base_card.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.variant = AppInfoCardVariant.info,
    this.action,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final IconData? icon;

  final String title;

  final String? message;

  final AppInfoCardVariant variant;

  final Widget? action;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final colors = _variantColors(scheme, ext);

    return AppBaseCard(
      onTap: onTap,
      padding: padding,
      color: colors.$1,
      elevation: AppElevation.flat,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? colors.$3, color: colors.$2, size: AppIconSizes.xl),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypeScale.titleSmall.copyWith(color: colors.$2),
                ),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    message!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: colors.$2.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }

  (Color, Color, IconData) _variantColors(
    ColorScheme scheme,
    AppThemeExtension ext,
  ) {
    return switch (variant) {
      AppInfoCardVariant.info => (
        ext.infoContainer,
        ext.onInfoContainer,
        Icons.info_outline,
      ),
      AppInfoCardVariant.success => (
        ext.successContainer,
        ext.onSuccessContainer,
        Icons.check_circle_outline,
      ),
      AppInfoCardVariant.warning => (
        ext.warningContainer,
        ext.onWarningContainer,
        Icons.warning_amber_rounded,
      ),
      AppInfoCardVariant.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.error_outline,
      ),
    };
  }
}

enum AppInfoCardVariant { info, success, warning, error }
