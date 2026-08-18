//**
// frontend/shared/design_system/loaders/app_empty_state.dart
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
import '../buttons/app_button.dart';
import '../layout/app_gap.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final spacing = compact ? AppSpacing.md : AppSpacing.xl;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 56 : 72,
              height: compact ? 56 : 72,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: compact ? AppIconSizes.xxl : AppIconSizes.xxxl,
                color: scheme.onPrimaryContainer,
              ),
            ),
            AppGap.lg,
            Text(
              title,
              style: AppTypeScale.titleMedium.copyWith(color: ext.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppGap.xs,
              Text(
                message!,
                style: AppTypeScale.bodyMedium.copyWith(
                  color: ext.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppGap.lg,
              AppButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
