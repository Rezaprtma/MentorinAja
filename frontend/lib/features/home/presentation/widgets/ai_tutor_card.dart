import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Compact AI-tutor entry point on the Home screen.
///
/// A soft, tinted assistant strip: a small brand icon, a short title and a
/// supporting line. Rendered on a very light orange surface with no shadow so
/// it reads as a helpful nudge rather than a promotional banner, without
/// competing with the "Continue learning" call to action.
class AiTutorCard extends StatelessWidget {
  const AiTutorCard({super.key, this.onPressed});

  /// Opens the tutor conversation surface.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: 'Ask your AI tutor',
      child: AppBaseCard(
        onTap: onPressed,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: scheme.primaryContainer,
        elevation: AppElevation.flat,
        radius: AppRadius.extraLarge,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: scheme.onPrimary,
                size: AppIconSizes.md,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your AI tutor',
                    style: AppTypeScale.titleSmall.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Need help with your lesson?',
                    style: AppTypeScale.bodySmall.copyWith(
                      color: scheme.onPrimaryContainer.withValues(alpha: 0.72),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.primary,
              size: AppIconSizes.lg,
            ),
          ],
        ),
      ),
    );
  }
}
