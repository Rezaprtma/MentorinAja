import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../buttons/app_button.dart';
import '../layout/app_gap.dart';

/// Friendly empty-state placeholder shown when a list or section has no data.
///
/// Composes an icon, title, message and optional action button. Designed to
/// keep users oriented when content is unavailable rather than showing a blank
/// screen.
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
